#ifdef GL_ES
precision highp float;
#endif

uniform vec3 uLightDir;
uniform vec3 uCameraPos;
uniform vec3 uLightRadiance;
uniform sampler2D uGDiffuse;
uniform sampler2D uGDepth;
uniform sampler2D uGNormalWorld;
uniform sampler2D uGShadow;
uniform sampler2D uGPosWorld;

varying mat4 vWorldToScreen;
varying highp vec4 vPosWorld;

#define M_PI 3.1415926535897932384626433832795
#define TWO_PI 6.283185307
// 这个意思就是除pi
#define INV_PI 0.31830988618
#define INV_TWO_PI 0.15915494309

float Rand1(inout float p) {
  p = fract(p * .1031);
  p *= p + 33.33;
  p *= p + p;
  return fract(p);
}

vec2 Rand2(inout float p) {
  return vec2(Rand1(p), Rand1(p));
}

float InitRand(vec2 uv) {
	vec3 p3  = fract(vec3(uv.xyx) * .1031);
  p3 += dot(p3, p3.yzx + 33.33);
  return fract((p3.x + p3.y) * p3.z);
}
// 向上半球采样 获得一个方向 局部坐标系 s随机数状态 pdf概率分布方程
vec3 SampleHemisphereUniform(inout float s, out float pdf) {
  vec2 uv = Rand2(s);
  float z = uv.x;
  float phi = uv.y * TWO_PI;
  float sinTheta = sqrt(1.0 - z*z);
  vec3 dir = vec3(sinTheta * cos(phi), sinTheta * sin(phi), z);
  pdf = INV_TWO_PI;
  return dir;
}

// 加权向cos采样 获得一个局部坐标系方向
vec3 SampleHemisphereCos(inout float s, out float pdf) {
  vec2 uv = Rand2(s);
  float z = sqrt(1.0 - uv.x);
  float phi = uv.y * TWO_PI;
  float sinTheta = sqrt(uv.x);
  vec3 dir = vec3(sinTheta * cos(phi), sinTheta * sin(phi), z);
  pdf = z * INV_PI;
  return dir;
}
// 将局部坐标系转换到世界坐标系
// n 局部坐标系的世界坐标法线  b1 b2 切线向量
void LocalBasis(vec3 n, out vec3 b1, out vec3 b2) {
  float sign_ = sign(n.z);
  if (n.z == 0.0) {
    sign_ = 1.0;
  }
  float a = -1.0 / (sign_ + n.z);
  float b = n.x * n.y * a;
  b1 = vec3(1.0 + sign_ * n.x * n.x * a, sign_ * b, -sign_ * n.x);
  b2 = vec3(b, sign_ + n.y * n.y * a, -n.y);
}

vec4 Project(vec4 a) {
  return a / a.w;
}

float GetDepth(vec3 posWorld) {
  float depth = (vWorldToScreen * vec4(posWorld, 1.0)).w;
  return depth;
}

/*
 * Transform point from world space to screen space([0, 1] x [0, 1])
 *
 */
vec2 GetScreenCoordinate(vec3 posWorld) {
  vec2 uv = Project(vWorldToScreen * vec4(posWorld, 1.0)).xy * 0.5 + 0.5;
  return uv;
}

float GetGBufferDepth(vec2 uv) {
  float depth = texture2D(uGDepth, uv).x;
  if (depth < 1e-2) {
    depth = 1000.0;
  }
  return depth;
}

vec3 GetGBufferNormalWorld(vec2 uv) {
  vec3 normal = texture2D(uGNormalWorld, uv).xyz;
  return normal;
}

vec3 GetGBufferPosWorld(vec2 uv) {
  vec3 posWorld = texture2D(uGPosWorld, uv).xyz;
  return posWorld;
}

float GetGBufferuShadow(vec2 uv) {
  float visibility = texture2D(uGShadow, uv).x;
  return visibility;
}

vec3 GetGBufferDiffuse(vec2 uv) {
  vec3 diffuse = texture2D(uGDiffuse, uv).xyz;
  diffuse = pow(diffuse, vec3(2.2));
  return diffuse;
}

/*
 * Evaluate diffuse bsdf value.
 *
 * wi, wo are all in world space.
 * uv is in screen space, [0, 1] x [0, 1].
 *
 */
// 需要用到 GetGBufferDiffuse  获得漫反射率做了伽马校正 应该是颜色值 基本的颜色值
//  GetGBufferNormalWorld 法线
// GetScreenCoordinate 世界坐标系的位置
// bsdf 这里应该是统称，不考虑btdf的情况 本质还是brdf
vec3 EvalDiffuse(vec3 wi, vec3 wo, vec2 uv) {
  vec3 L = vec3(1.0);
  vec3 gBufferDiffuse = GetGBufferDiffuse(uv);
  vec3 normalWorld = GetGBufferNormalWorld(uv);
  vec2 normalScreen = GetScreenCoordinate(normalWorld);
  // todo 有了wi wo normal diffuse 怎么获得 bsdf？ 
  // 如果是lambert diffuse 那么就是 albedo / pi  
  // 其他的diffuse 则和wi wo 有关

  // albedo 应该和directional light 有关
  // albedo / pi  * cos 漫反射入射夹角
  return gBufferDiffuse * INV_PI *  max(0.0,dot(normalize(wi), normalize(normalWorld)));
  // return gBufferDiffuse * vec3(normalScreen,0.0) * (wi + wo);
  // return L;
}

/*
 * Evaluate directional light with shadow map
 * uv is in screen space, [0, 1] x [0, 1].
 *
 */
vec3 EvalDirectionalLight(vec2 uv) {
  vec3 Le = vec3(0.0);
  float flag = GetGBufferuShadow(uv);
  float visibility = clamp(flag, 0.0, 1.0);
  // uLightRadiance 光照radiance 除了物体自己的diffuse 光照本身也可以有自己的颜色或者说能量 需要计算
  return uLightRadiance * visibility;
}
// 间接光照用的
// 这里本质做的是 ray tracing 
// 这里我们不用depth mipmap 使用均匀的step进行处理 每个step 0.001
bool RayMarch(vec3 ori, vec3 dir, out vec3 hitPos) {
  // hitPos 主动赋值为交点 。
  // 参数 ori 和 dir 为世界坐标系中的值，分别代表光线的起点和方向， 其中方向向量为单位向量。
  vec3 tempPos = vec3(0.0);
  float ori_depth = GetDepth(ori);
  float temp_depth = 0.0;
  const float STEP_SUM = 200.0;
  float STEP = 0.0001;
  bool flag = false;

  for (float i = 0.0; i < STEP_SUM; i += 1.0) {
    tempPos = ori + (i * STEP) * dir;
    temp_depth = GetDepth(tempPos);

    if (temp_depth > ori_depth) {
      hitPos = tempPos;
      flag = true;
      break;
    }
    
  }

  return flag;
}

#define SAMPLE_NUM 1

void main() {
  float s = InitRand(gl_FragCoord.xy);
  float seed1 = Rand1(s);
  float seed2 = Rand1(seed1);
  // 直接光照
  vec3 L = vec3(0.0);
  vec3 indir_L = vec3(0.0);
  L = GetGBufferDiffuse(GetScreenCoordinate(vPosWorld.xyz));

  vec2 uv = GetScreenCoordinate(vPosWorld.xyz);
  vec3 wi = uCameraPos - vec3(uv, 1.0);
  vec3 wo = uLightDir - vec3(uv, 1.0);
  vec3 brdf = EvalDiffuse(wi,wo,uv);
  vec3 view = EvalDirectionalLight(uv);
  L = L * brdf * view;

  // 间接光照
  for (int i = 0; i < SAMPLE_NUM; i++) {
    vec3 direction = SampleHemisphereUniform(seed1,seed2);

    // ray tracing
    // 先按照specular 处理
    vec3 ori = vPosWorld.xyz;
    vec3 dir = direction;
    vec3 hitPos = vec3(0.0);
    bool flag = RayMarch(ori, dir, hitPos);
    if (flag) {
      // todo 蒙特卡洛方法 与 本地坐标系转世界坐标系的方法
      vec3 indir_wi = uCameraPos - hitPos;
      vec3 indir_wo = uLightDir - hitPos;
      vec3 indir_uv = GetScreenCoordinate(hitPos);
      L = brdf/seed2 * EvalDiffuse(indir_wi, indir_wo, hitPos) * EvalDirectionalLight(hitPos)
      indir_L = L + indir_L
    }
  }

  L = L + indir_L;
  // clamp的作用是限制 0.0 ~ 1.0 
  vec3 color = pow(clamp(L, vec3(0.0), vec3(1.0)), vec3(1.0 / 2.2));
  gl_FragColor = vec4(vec3(color.rgb), 1.0);
}

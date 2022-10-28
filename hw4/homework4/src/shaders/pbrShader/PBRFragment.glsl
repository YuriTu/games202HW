#ifdef GL_ES
precision mediump float;
#endif

uniform vec3 uLightPos;
uniform vec3 uCameraPos;
uniform vec3 uLightRadiance;
uniform vec3 uLightDir;

uniform sampler2D uAlbedoMap;
uniform float uMetallic;
uniform float uRoughness;
uniform sampler2D uBRDFLut;
uniform samplerCube uCubeTexture;

varying highp vec2 vTextureCoord;
varying highp vec3 vFragPos;
varying highp vec3 vNormal;

const float PI = 3.14159265359;

float DistributionGGX(vec3 N, vec3 H, float roughness)
{
   // TODO: To calculate GGX NDF here
   float alpha = pow(roughness,2.0);
   float alpha_2 = pow(alpha,2.0);
   float NdotH = clamp(dot(N,H), 0.0, 1.0);
   float param1 = pow(dot(N,H),2.0) * ( (alpha_2 - 1.0) + 1.0);
   float param2 = PI * pow(param1,2.0);
   return alpha_2 / param2;
}

float GeometrySchlickGGX(float NdotV, float roughness)
{
    // TODO: To calculate Smith G1 here
    // 注意cos 的情况，否则可能会计算负角度的光搞得特别亮
    NdotV = clamp(NdotV, 0.0, 1.0);
    float k = pow((roughness + 1.0),2.0) / 8.0;
    float result = NdotV / ((NdotV * (1.0 - k)) + k);
    
    return result;
}

float GeometrySmith(vec3 N, vec3 V, vec3 L, float roughness)
{
    // TODO: To calculate Smith G here
    float NdotV = dot(N,V);
    float NdotL = dot(N,L);
    float G1 = GeometrySchlickGGX(NdotL, roughness);
    float G2 = GeometrySchlickGGX(NdotV, roughness);
    return G1 * G2;
}
// F0就是R0  V出射光方向 H半程向量 
// VH的cos情况就可以反映出V与N的接近情况
vec3 fresnelSchlick(vec3 F0, vec3 V, vec3 H)
{
    // TODO: To calculate Schlick F here
    vec3 R0 = F0;
    float VdotH = clamp(dot(V,H), 0.0, 1.0);
    float cosTheta = VdotH;
    vec3 reflactance = R0 + (1.0-R0) * pow( (1.0-cosTheta),5.0);
    
    return reflactance;
}

void main(void) {
  vec3 albedo = pow(texture2D(uAlbedoMap, vTextureCoord).rgb, vec3(2.2));

  vec3 N = normalize(vNormal);
  vec3 V = normalize(uCameraPos - vFragPos);// 入射光方向
  float NdotV = max(dot(N, V), 0.0);
 
  vec3 F0 = vec3(0.04); // 金属的初始颜色值
  F0 = mix(F0, albedo, uMetallic); // 根据金属性与表面颜色进行插值

  vec3 Lo = vec3(0.0);

  vec3 L = normalize(uLightDir);// 出射光方向
  vec3 H = normalize(V + L);// 半程向量
  float NdotL = max(dot(N, L), 0.0); 

  vec3 radiance = uLightRadiance;
    // 计算microfact的brdf
  float NDF = DistributionGGX(N, H, uRoughness);   
  float G   = GeometrySmith(N, V, L, uRoughness); 
  vec3 F = fresnelSchlick(F0, V, H);
      
  vec3 numerator    = NDF * G * F; 
  float denominator = max((4.0 * NdotL * NdotV), 0.001);
  vec3 BRDF = numerator / denominator;
    // 光照方程 Lo * brdf * cos
  Lo += BRDF * radiance * NdotL;
  vec3 color = Lo;

  color = color / (color + vec3(1.0));
  color = pow(color, vec3(1.0/2.2)); // 伽马校正
  gl_FragColor = vec4(color, 1.0);
}
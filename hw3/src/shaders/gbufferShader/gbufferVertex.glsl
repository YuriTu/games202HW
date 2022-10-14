attribute vec3 aVertexPosition;
attribute vec3 aNormalPosition;
attribute vec2 aTextureCoord;

uniform mat4 uLightVP;
uniform mat4 uModelMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;

varying mat4 vWorldToLight;

varying highp vec2 vTextureCoord;
varying highp vec3 vNormalWorld;
varying highp vec4 vPosWorld;
varying highp float vDepth;

void main(void) {
  vec4 posWorld = uModelMatrix * vec4(aVertexPosition, 1.0);
  vPosWorld = posWorld.xyzw / posWorld.w;
  vec4 normalWorld = uModelMatrix * vec4(aNormalPosition, 0.0);
  vNormalWorld = normalize(normalWorld.xyz);
  vTextureCoord = aTextureCoord;
  vWorldToLight = uLightVP;

  gl_Position = uProjectionMatrix * uViewMatrix * uModelMatrix * vec4(aVertexPosition, 1.0);
  // 是w不是z的原因： 因为 w 分量是线性深度值，而 z/w 是渲染管线用到的非线性深度值。
  vDepth = gl_Position.w;
}
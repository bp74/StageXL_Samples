part of custom_filter;

/// The WebGL render program for the custom filter

class ColorMatrixAlphaMaskProgram extends RenderProgramSimple {
  Matrix _matrix = Matrix.fromIdentity();
  Float32List _maskMatrix = Float32List(9);
  Float32List _maskBounds = Float32List(4);

  @override
  String get fragmentShaderSource => """

    precision mediump float;
    uniform sampler2D uTextSampler;
    uniform sampler2D uMaskSampler;
    uniform mat4 uColorMatrix;
    uniform vec4 uColorOffset;
    uniform vec4 uMaskBounds;
    uniform mat3 uMaskMatrix;

    varying vec2 vTextCoord;
    varying float vAlpha;

    void main() {

      vec4 textColor = texture2D(uTextSampler, vTextCoord.xy);
      vec4 color = vec4(textColor.rgb / textColor.a, textColor.a);
      color = uColorOffset + color * uColorMatrix;
      color = vec4(color.rgb * color.a, color.a);

      vec3 maskCoord = vec3(vTextCoord.xy, 1) * uMaskMatrix;
      vec4 maskColor = texture2D(uMaskSampler, maskCoord.xy);
      vec2 s1 = step(uMaskBounds.xy, maskCoord.xy);
      vec2 s2 = step(maskCoord.xy, uMaskBounds.zw);
      float alpha = maskColor.a * s1.x * s1.y * s2.x * s2.y;

      gl_FragColor = ((1.0 - alpha) * color + alpha * textColor) * vAlpha;
    }
    """;

  void configure(ColorMatrixAlphaMaskFilter filter, RenderTextureQuad mainRenderTextureQuad,
      RenderTextureQuad maskRenderTextureQuad) {
    _matrix.copyFromAndConcat(filter.matrix, mainRenderTextureQuad.samplerMatrix);
    _matrix.invertAndConcat(maskRenderTextureQuad.samplerMatrix);

    var vxList = maskRenderTextureQuad.vxList;
    _maskBounds[0] = vxList[2] < vxList[10] ? vxList[2] : vxList[10];
    _maskBounds[1] = vxList[3] < vxList[11] ? vxList[3] : vxList[11];
    _maskBounds[2] = vxList[2] > vxList[10] ? vxList[2] : vxList[10];
    _maskBounds[3] = vxList[3] > vxList[11] ? vxList[3] : vxList[11];

    _maskMatrix[0] = _matrix.a;
    _maskMatrix[1] = _matrix.c;
    _maskMatrix[2] = _matrix.tx;
    _maskMatrix[3] = _matrix.b;
    _maskMatrix[4] = _matrix.d;
    _maskMatrix[5] = _matrix.ty;
    _maskMatrix[6] = 0.0;
    _maskMatrix[7] = 0.0;
    _maskMatrix[8] = 1.0;

    renderingContext.uniform1i(uniforms["uTextSampler"], 0);
    renderingContext.uniform1i(uniforms["uMaskSampler"], 1);
    renderingContext.uniformMatrix4fv(uniforms["uColorMatrix"], false, filter.colorMatrixList);
    renderingContext.uniform4fv(uniforms["uColorOffset"], filter.colorOffsetList);
    renderingContext.uniform4fv(uniforms["uMaskBounds"], _maskBounds);
    renderingContext.uniformMatrix3fv(uniforms["uMaskMatrix"], false, _maskMatrix);
  }
}

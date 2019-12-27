part of custom_filter;

/// A custom filter that applies a color matrix transformation and an
/// alpha mask at the same time. Just as an example ...

class ColorMatrixAlphaMaskFilter extends BitmapFilter {
  final Matrix matrix;
  final BitmapData bitmapData;
  final Float32List colorMatrixList = Float32List(16);
  final Float32List colorOffsetList = Float32List(4);

  ColorMatrixAlphaMaskFilter(this.bitmapData, this.matrix) {
    this.colorMatrixList[00] = 1.0;
    this.colorMatrixList[05] = 1.0;
    this.colorMatrixList[10] = 1.0;
    this.colorMatrixList[15] = 1.0;
  }

  @override
  BitmapFilter clone() => ColorMatrixAlphaMaskFilter(bitmapData, matrix.clone());

  @override
  void renderFilter(RenderState renderState, RenderTextureQuad renderTextureQuad, int pass) {
    RenderContextWebGL renderContext = renderState.renderContext;
    String programName = "ColorMatrixAlphaMaskProgram";
    ColorMatrixAlphaMaskProgram renderProgram;

    renderProgram =
        renderContext.getRenderProgram(programName, () => ColorMatrixAlphaMaskProgram());
    renderContext.activateRenderProgram(renderProgram);
    renderContext.activateRenderTextureAt(renderTextureQuad.renderTexture, 0);
    renderContext.activateRenderTextureAt(bitmapData.renderTexture, 1);
    renderProgram.configure(this, renderTextureQuad, bitmapData.renderTextureQuad);
    renderProgram.renderTextureQuad(renderState, renderTextureQuad);
    renderProgram.flush();
  }
}

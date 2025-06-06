import 'dart:html' as html;
import 'dart:ui' as ui;

/// Helper class to set up web-specific functionality
class ImglyWebSetup {
  /// Register the iframe view factory
  static void registerWebView(String viewType) {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final iframe = html.IFrameElement()
        ..src = 'assets/imgly_editor.html'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allowFullscreen = true;
      return iframe;
    });
  }
}

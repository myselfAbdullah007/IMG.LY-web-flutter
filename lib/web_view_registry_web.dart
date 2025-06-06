// Implementation for web platform
import 'dart:html' as html;
import 'dart:js' as js;

/// Register a web view implementation for web platform
void registerWebViewImpl(String viewType) {
  // Use js interop to register the view factory
  js.context.callMethod('eval', ['''
    // Register the view factory
    window.flutterWebViewRegistry = window.flutterWebViewRegistry || {};
    window.flutterWebViewRegistry['$viewType'] = function(viewId) {
      var iframe = document.createElement('iframe');
      iframe.src = 'assets/imgly_editor.html';
      iframe.style.border = 'none';
      iframe.style.width = '100%';
      iframe.style.height = '100%';
      iframe.allowFullscreen = true;
      return iframe;
    };
  ''']);
}

// This file provides a platform-safe way to register web views
// It uses conditional imports to handle web vs non-web platforms

import 'web_view_registry_web.dart' if (dart.library.io) 'web_view_registry_stub.dart';

/// A class that provides platform-safe web view registration
class WebViewRegistry {
  /// Register a web view with the given type
  static void registerWebView(String viewType) {
    registerWebViewImpl(viewType);
  }
}

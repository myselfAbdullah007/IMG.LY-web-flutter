import 'dart:js' as js;
import 'dart:html' as html;

class ImglyJSInterop {
  static void setupCallbacks({
    required Function(String) onImageEdited,
    required Function() onEditorLoaded,
    required Function(String) onEditorError,
  }) {
    js.context['flutterImageEdited'] = (String imageUrl) {
      onImageEdited(imageUrl);
    };

    js.context['flutterEditorLoaded'] = () {
      onEditorLoaded();
    };

    js.context['flutterEditorError'] = (String error) {
      onEditorError(error);
    };
  }

  static void openEditor() {
    try {
      js.context.callMethod('openImglyEditor');
    } catch (e) {
      print('Error calling openImglyEditor: $e');
    }
  }

  static void loadSampleImage() {
    try {
      js.context.callMethod('loadSampleImage');
    } catch (e) {
      print('Error calling loadSampleImage: $e');
    }
  }

  static bool get isEditorAvailable {
    return js.context.hasProperty('openImglyEditor');
  }
}

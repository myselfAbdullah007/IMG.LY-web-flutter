import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'dart:html' as html;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMG.LY Flutter Integration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: ImglyEditorPage(),
    );
  }
}

class ImglyEditorPage extends StatefulWidget {
  @override
  _ImglyEditorPageState createState() => _ImglyEditorPageState();
}

class _ImglyEditorPageState extends State<ImglyEditorPage> {
  String? _editedImageUrl;
  bool _isEditorLoaded = false;
  html.IFrameElement? _iframe;
  bool _isEditorVisible = false;

  @override
  void initState() {
    super.initState();
    _setupJSInterop();
    // Delay iframe creation to ensure DOM is ready
    Future.delayed(Duration(milliseconds: 500), () {
      _createIframe();
    });
  }

  void _createIframe() {
    try {
      // Create iframe
      _iframe = html.IFrameElement()
        ..src = 'assets/imgly_editor.html'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allowFullscreen = true;
      
      // Add iframe to a div in the HTML document
      final container = html.querySelector('#iframe-container');
      if (container != null) {
        container.children.clear();
        container.append(_iframe!);
        print('Iframe created and added to container');
      } else {
        // Create container if it doesn't exist
        final newContainer = html.DivElement()
          ..id = 'iframe-container'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.position = 'fixed'
          ..style.top = '0'
          ..style.left = '0'
          ..style.right = '0'
          ..style.bottom = '0'
          ..style.zIndex = '1000'
          ..style.display = 'none'
          ..style.background = 'rgba(0,0,0,0.8)';
        newContainer.append(_iframe!);
        html.document.body?.append(newContainer);
        print('Iframe container created and added to body');
      }
      
      // Add show/hide methods to window
      js.context['showImglyEditor'] = () {
        final container = html.querySelector('#iframe-container');
        if (container != null) {
          container.style.display = 'block';
          setState(() {
            _isEditorVisible = true;
          });
          print('Editor shown');
        }
      };
      
      js.context['hideImglyEditor'] = () {
        final container = html.querySelector('#iframe-container');
        if (container != null) {
          container.style.display = 'none';
          setState(() {
            _isEditorVisible = false;
          });
          print('Editor hidden');
        }
      };
    } catch (e) {
      print('Error creating iframe: $e');
    }
  }

  void _setupJSInterop() {
    print('Setting up JavaScript interop callbacks...');
    
    // Set up JavaScript interop callbacks
    js.context['flutterImageEdited'] = (String imageUrl) {
      print('Image edited callback received: ${imageUrl.substring(0, 50)}...');
      setState(() {
        _editedImageUrl = imageUrl;
      });
      _showSuccessDialog();
      
      // Hide editor after successful edit
      js.context.callMethod('hideImglyEditor');
    };

    js.context['flutterEditorLoaded'] = () {
      print('Editor loaded callback received');
      setState(() {
        _isEditorLoaded = true;
      });
    };

    js.context['flutterEditorError'] = (String error) {
      print('Editor error callback received: $error');
      _showErrorDialog(error);
    };
    
    print('JavaScript interop callbacks set up successfully');
  }

  void _openEditor() {
    print('Open editor button clicked');
    if (_isEditorLoaded) {
      try {
        // First show the editor container
        js.context.callMethod('showImglyEditor');
        
        // Use a simpler message format to avoid structured clone issues
        if (_iframe != null && _iframe!.contentWindow != null) {
          // Send a simple string message instead of an object
          _iframe!.contentWindow!.postMessage('openEditor', '*');
          print('PostMessage sent to iframe: openEditor');
        } else {
          print('Iframe or contentWindow is null');
        }
      } catch (e) {
        print('Error opening editor: $e');
      }
    } else {
      print('Editor not loaded yet');
    }
  }

  void _loadSampleImage() {
    print('Load sample image button clicked');
    if (_isEditorLoaded) {
      try {
        // First show the editor container
        js.context.callMethod('showImglyEditor');
        
        // Use a simpler message format to avoid structured clone issues
        if (_iframe != null && _iframe!.contentWindow != null) {
          // Send a simple string message instead of an object
          _iframe!.contentWindow!.postMessage('loadSampleImage', '*');
          print('PostMessage sent to iframe: loadSampleImage');
        } else {
          print('Iframe or contentWindow is null');
        }
      } catch (e) {
        print('Error loading sample image: $e');
      }
    } else {
      print('Editor not loaded yet');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Success'),
          ],
        ),
        content: Text('Image edited successfully!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('Error'),
          ],
        ),
        content: Text('Editor error: $error'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IMG.LY Flutter Integration'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Column(
              children: [
                // Make buttons responsive
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isEditorLoaded ? _openEditor : null,
                      icon: Icon(Icons.edit),
                      label: Text('Open Editor'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _isEditorLoaded ? _loadSampleImage : null,
                      icon: Icon(Icons.image),
                      label: Text('Load Sample'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _isEditorLoaded ? Colors.green.shade100 : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isEditorLoaded ? Colors.green.shade300 : Colors.orange.shade300,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isEditorLoaded ? Icons.check_circle : Icons.hourglass_empty,
                        color: _isEditorLoaded ? Colors.green.shade700 : Colors.orange.shade700,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _isEditorLoaded 
                              ? _isEditorVisible 
                                  ? 'Editor Active' 
                                  : 'Editor Ready'
                              : 'Loading Editor...',
                          style: TextStyle(
                            color: _isEditorLoaded ? Colors.green.shade800 : Colors.orange.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _editedImageUrl != null
                ? Container(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Last Edited Image',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        SizedBox(height: 24),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _editedImageUrl!,
                              fit: BoxFit.contain,
                              height: 400,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 400,
                                  height: 400,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 48,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Failed to load image',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.image_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'No edited images yet',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Click "Open Editor" to start creating',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

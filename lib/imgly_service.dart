import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class ImglyService {
  static const String _baseUrl = 'https://api.img.ly/v1';
  
  // Configuration for IMG.LY SDK
  static Map<String, dynamic> getEditorConfig() {
    return {
      'license': 'MC-wl_23-QB_XIcrJ8DP-B2r2liJxmPr4_OHWNt7Y38Vx9on5QkjtyB0rbR5Ny_m',
      'userId': 'flutter-user-${DateTime.now().millisecondsSinceEpoch}',
      'theme': {
        'primaryColor': '#6366f1',
        'backgroundColor': '#ffffff',
      },
      'features': {
        'export': true,
        'upload': true,
        'library': true,
      },
      'export': {
        'format': 'image/jpeg',
        'quality': 0.9,
      }
    };
  }
  
  // Process image data
  static Future<String> processImageData(Uint8List imageData) async {
    try {
      // Convert to base64 for web transfer
      String base64Image = base64Encode(imageData);
      return 'data:image/jpeg;base64,$base64Image';
    } catch (e) {
      throw Exception('Failed to process image data: $e');
    }
  }
  
  // Validate image format
  static bool isValidImageFormat(String filename) {
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    return validExtensions.any((ext) => 
      filename.toLowerCase().endsWith(ext));
  }
  
  // Convert data URL to Uint8List
  static Uint8List dataUrlToUint8List(String dataUrl) {
    final base64String = dataUrl.split(',')[1];
    return base64Decode(base64String);
  }
  
  // Save image to downloads (web)
  static void downloadImage(String dataUrl, String filename) {
    final bytes = dataUrlToUint8List(dataUrl);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    
    html.Url.revokeObjectUrl(url);
  }
}

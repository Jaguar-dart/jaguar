import 'dart:io';
import 'package:path/path.dart' as p;

/// A namespace class to expose mime type specific features
abstract class MimeType {
  /// Mime type for HTML
  static const String html = "text/html";

  /// Mime type for Javascript
  static const String javascript = "application/javascript";

  /// Mime type for CSS
  static const String css = "text/css";

  /// Mime type for Dart
  static const String dart = "application/dart";

  /// Mime type for PNG
  static const String png = "image/png";

  /// Mime type for JPEG
  static const String jpeg = "image/jpeg";

  /// Mime type for GIF
  static const String gif = "image/gif";

  /// Mime type for JSON
  static const String json = "application/json";

  /// Mime type for SVG
  static const String svg = "image/svg+xml";

  /// Map of file extension to mime type
  static const fromFileExtension = const <String, String>{
    "html": html,
    "js": javascript,
    "css": css,
    "dart": dart,
    "png": png,
    "jpg": jpeg,
    "jpeg": jpeg,
    "gif": gif,
    "svg": svg,
  };

  /// Returns mime type of [file] based on its extension
  static String ofFile(File file) {
    String fileExtension = p.extension(file.path);

    if (fileExtension.startsWith('.'))
      fileExtension = fileExtension.substring(1);

    if (fileExtension.length == 0) return null;

    if (fromFileExtension.containsKey(fileExtension)) {
      return fromFileExtension[fileExtension];
    }

    return null;
  }
}

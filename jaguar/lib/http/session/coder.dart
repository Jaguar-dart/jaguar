import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Codes, encrypts and signs the give [Map].
///
/// Almost like [Converter<Map<String, String>, String>]
abstract class MapCoder {
  /// Encodes the given Map
  String encode(Map<String, String> values);

  /// Decodes [value] into Map
  Map<String, String> decode(String value);
}

/// Encrypts the [Map] using [encrypter]. Signs the [Map] using [signer]. The
/// final result is made HTTP friendly by Base64 URL encoding.
///
/// Both [encrypter] and [signer] are optional.
class JaguarMapCoder extends MapCoder {
  /// The optional encrypter
  final Codec<String, String> encrypter;

  /// The optional signer
  final Converter<List<int>, Digest> signer;

  JaguarMapCoder({this.signer, this.encrypter});

  /// Encodes [values]
  String encode(Map<String, String> values) {
    // Map data to String
    String value = json.encode(values);
    // Encrypt the data
    if (encrypter != null) value = encrypter.encode(value);
    // Base64 URL safe encoding
    String ret = base64UrlEncode(value.codeUnits);
    if (signer == null) return ret;
    // Sign it!
    return ret + '.' + base64UrlEncode(signer.convert(ret.codeUnits).bytes);
  }

  /// Decodes [data] into [Map]
  Map<String, String> decode(String data) {
    if (signer != null) {
      List<String> parts = data.split('.');
      if (parts.length != 2) return null;

      try {
        if (base64Url.encode(signer.convert(parts[0].codeUnits).bytes) !=
            parts[1]) return null;
      } catch (e) {
        return null;
      }

      data = parts[0];
    }

    try {
      String value = String.fromCharCodes(base64Url.decode(data));
      if (encrypter != null) value = encrypter.decode(value);
      Map values = json.decode(value);
      return values.cast<String, String>();
    } catch (e) {
      return null;
    }
  }
}

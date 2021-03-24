import 'dart:convert';
import 'dart:io';

import 'package:cosmosdb/model/resource_type.dart';
import 'package:crypto/crypto.dart';

/// Utils to generate cryptographic keys
class AuthTokenUtils {
  const AuthTokenUtils._();

  /// Generate the auth token by url encoding the components
  static String generateAuthToken(
      {required String signature,
      String keyType = 'master',
      String tokenVersion = '1.0'}) {
    return Uri.encodeComponent(
        'type=$keyType&ver=$tokenVersion&sig=$signature');
  }

  /// Generates an authentication signature specified by cosmosdb
  static String generateAuthSignature(
      {String verb = '',
      ResourceType resourceType = ResourceType.none,
      String resourceLink = '',
      DateTime? date,
      required String key}) {
    final dateOrNow = date ?? DateTime.now();
    final formattedDate = HttpDate.format(dateOrNow);
    final payload = [
          verb.toLowerCase(),
          resourceType.key,
          resourceLink,
          formattedDate.toLowerCase(),
          '',
        ].join('\n') +
        '\n';
    final payloadAsBytes = utf8.encode(payload);
    final hmacSha256 = Hmac(sha256, base64Decode(key));
    final signature = hmacSha256.convert(payloadAsBytes);
    return base64Encode(signature.bytes);
  }
}

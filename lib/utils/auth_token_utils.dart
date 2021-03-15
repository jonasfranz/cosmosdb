import 'dart:convert';
import 'dart:io';

import 'package:cosmosdb/model/resource_type.dart';
import 'package:crypto/crypto.dart';

class AuthTokenUtils {
  const AuthTokenUtils._();

  static String generateAuthToken(
      {required String signature,
      String keyType = "master",
      String tokenVersion = "1.0"}) {
    return Uri.encodeComponent(
        "type=${keyType}&ver=${tokenVersion}&sig=${signature}");
  }

  static String generateAuthSignature(
      {String verb = "",
      ResourceType resourceType = ResourceType.none,
      String resourceLink = "",
      DateTime? date,
      required String key}) {
    final DateTime dateOrNow = date ?? DateTime.now();
    final String formattedDate = HttpDate.format(dateOrNow);
    final String payload = [
          verb.toLowerCase(),
          resourceType.key,
          resourceLink,
          formattedDate.toLowerCase(),
          "",
        ].join("\n") +
        "\n";
    final payloadAsBytes = utf8.encode(payload);
    final hmacSha256 = Hmac(sha256, base64Decode(key));
    final signature = hmacSha256.convert(payloadAsBytes);
    return base64Encode(signature.bytes);
  }
}

// Copyright 2021 Jonas Franz
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:convert';

import 'package:cosmosdb/src/model/resource_type.dart';
import 'package:crypto/crypto.dart';
import 'package:universal_io/io.dart';

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

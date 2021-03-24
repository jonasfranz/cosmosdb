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
import 'package:cosmosdb/src/utils/auth_token_utils.dart';
import 'package:http/http.dart' as http;
import 'package:universal_io/io.dart';

/// An abstraction for the http client to handle common operations
class CosmosDBHttpClient {
  final http.Client _httpClient;
  final String _masterKey;
  final String _baseUrl;

  /// Configures the HTTP client to use the given configuration
  CosmosDBHttpClient({
    required String masterKey,
    required String baseUrl,
    http.Client? httpClient,
  })  : _httpClient = httpClient ?? http.Client(),
        _masterKey = masterKey,
        _baseUrl = baseUrl;

  Future<Map<String, dynamic>> _executeRequest(
    String method,
    String path, {
    required bool removeLastPart,
    Object? body,
    ResourceType resourceType = ResourceType.none,
    Map<String, String> headers = const {},
  }) async {
    final date = DateTime.now().toUtc();
    final request = http.Request(method, Uri.parse(_baseUrl + path));
    final parts = path.split('/');
    if (removeLastPart) {
      parts.removeLast();
    }
    final signature = AuthTokenUtils.generateAuthSignature(
      verb: method,
      key: _masterKey,
      resourceType: resourceType,
      resourceLink: parts.join('/'),
      date: date,
    );

    if (body != null) {
      request.body = jsonEncode(body);
    }
    request.headers.addAll(headers);
    request.headers.addAll({
      'x-ms-date': HttpDate.format(date),
      'x-ms-version': '2018-09-17',
      'authorization': AuthTokenUtils.generateAuthToken(signature: signature)
    });
    final result = await _httpClient.send(request);
    if (result.headers['content-type'] != 'application/json') {
      throw Exception(
          'invalid response: ' + await result.stream.bytesToString());
    }
    final resultString = await result.stream.bytesToString();
    var resultBody = <String, dynamic>{};
    try {
      if (resultString.isNotEmpty) {
        resultBody = jsonDecode(resultString);
      }
    } catch (err) {
      throw Exception('cannot parse received body: $resultString');
    }
    if (result.statusCode ~/ 100 != 2) {
      throw Exception(resultBody['message'] ?? 'Unknown Error');
    }
    return resultBody;
  }

  /// Executes a GET request
  Future<Map<String, dynamic>> get(
    String path, {
    required bool removeLastPart,
    ResourceType resourceType = ResourceType.none,
    Map<String, String> headers = const {},
  }) async {
    return _executeRequest(
      'get',
      path,
      removeLastPart: removeLastPart,
      resourceType: resourceType,
      headers: headers,
    );
  }

  /// Executes a DELETE request
  Future<Map<String, dynamic>> delete(
    String path, {
    required bool removeLastPart,
    ResourceType resourceType = ResourceType.none,
    Map<String, String> headers = const {},
  }) async {
    return _executeRequest(
      'delete',
      path,
      removeLastPart: removeLastPart,
      resourceType: resourceType,
      headers: headers,
    );
  }

  /// Executes a POST request
  Future<Map<String, dynamic>> post(
    String path,
    Object? body, {
    required bool removeLastPart,
    ResourceType resourceType = ResourceType.none,
    Map<String, String> headers = const {},
  }) {
    return _executeRequest(
      'post',
      path,
      removeLastPart: removeLastPart,
      body: body,
      resourceType: resourceType,
      headers: {'Content-Type': 'application/json', ...headers},
    );
  }

  /// Executes a PUT request
  Future<Map<String, dynamic>> put(
    String path,
    Object? body, {
    required bool removeLastPart,
    ResourceType resourceType = ResourceType.none,
    Map<String, String> headers = const {},
  }) async {
    return _executeRequest(
      'put',
      path,
      removeLastPart: removeLastPart,
      body: body,
      resourceType: resourceType,
      headers: {'Content-Type': 'application/json', ...headers},
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:cosmosdb/model/resource_type.dart';
import 'package:cosmosdb/utils/auth_token_utils.dart';
import 'package:http/http.dart' as http;

class CosmosDBHttpClient {
  final http.Client httpClient;
  final String masterKey;
  final String baseUrl;

  CosmosDBHttpClient(
      {required this.masterKey, required this.baseUrl, http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  Future<Map<String, dynamic>> _executeRequest(
    String method,
    String path, {
    required bool removeLastPart,
    Object? body,
    ResourceType resourceType = ResourceType.none,
    Map<String, String> headers = const {},
  }) async {
    final date = DateTime.now().toUtc();
    final request = http.Request(method, Uri.parse(baseUrl + path));
    final parts = path.split('/');
    if (removeLastPart) {
      parts.removeLast();
    }
    final signature = AuthTokenUtils.generateAuthSignature(
      verb: method,
      key: masterKey,
      resourceType: resourceType,
      resourceLink: parts.join('/'),
      date: date,
    );

    if (body != null) {
      request.body = jsonEncode(body);
    }

    request.headers.addAll({
      'x-ms-date': HttpDate.format(date),
      'x-ms-version': '2018-12-31',
      'authorization': AuthTokenUtils.generateAuthToken(signature: signature)
    });
    final result = await httpClient.send(request);
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

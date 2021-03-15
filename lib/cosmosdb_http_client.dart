import 'dart:convert';
import 'dart:io';

import 'package:cosmosdb/model/resource_type.dart';
import 'package:cosmosdb/utils/auth_token_utils.dart';
import 'package:http/http.dart' as http;

class CosmosDBHttpClient {
  final http.Client httpClient = http.Client();
  final String masterKey;
  final String baseUrl;

  CosmosDBHttpClient({
    required this.masterKey,
    required this.baseUrl,
  });

  Future<Map<String, dynamic>> _executeRequest(
    String method,
    String path, {
    Object? body,
    ResourceType resourceType = ResourceType.none,
    Map<String, String> headers = const {},
  }) async {
    final date = DateTime.now().toUtc();
    final request = new http.Request(method, Uri.parse(baseUrl + path));
    final parts = path.split("/");
    if (parts.length > 1) {
      parts.removeLast();
    }
    final signature = AuthTokenUtils.generateAuthSignature(
      verb: method,
      key: masterKey,
      resourceType: resourceType,
      resourceLink: parts.join("/"),
      date: date,
    );

    if (body != null) {
      request.body = jsonEncode(body);
    }

    request.headers.addAll({
      "x-ms-date": HttpDate.format(date),
      "x-ms-version": "2018-12-31",
      "authorization": AuthTokenUtils.generateAuthToken(signature: signature)
    });
    final result = await httpClient.send(request);
    final resultBody = jsonDecode(await result.stream.bytesToString());
    if (result.statusCode ~/ 100 != 2)
      throw Exception(resultBody["message"] ?? "Unknown Error");
    return resultBody;
  }

  Future<Map<String, dynamic>> get(
    String path, {
    ResourceType resourceType = ResourceType.none,
    Map<String, String> headers = const {},
  }) async {
    return _executeRequest("get", path,
        resourceType: resourceType, headers: headers);
  }

  Future<Map<String, dynamic>> post(
    String path,
    Object? body, {
    ResourceType resourceType = ResourceType.none,
    Map<String, String> headers = const {},
  }) {
    return _executeRequest("post", path,
        resourceType: resourceType,
        headers: headers..["Content-Type"] = "application/query+json");
  }

  Future<Map<String, dynamic>> put(
    String path,
    Object? body, {
    ResourceType resourceType = ResourceType.none,
    String resourceId = "",
    Map<String, String> headers = const {},
  }) async {
    return _executeRequest("put", path,
        resourceType: resourceType,
        headers: headers..["Content-Type"] = "application/query+json");
  }
}

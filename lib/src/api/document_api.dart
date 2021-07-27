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

import 'package:cosmosdb/model/query.dart';
import 'package:cosmosdb/model/request_options.dart';
import 'package:cosmosdb/src/cosmosdb_http_client.dart';
import 'package:cosmosdb/src/model/resource_type.dart';

/// Access documents in cosmosdb collections
class DocumentApi {
  final CosmosDBHttpClient _client;

  /// Initializes the api with the http client
  const DocumentApi(this._client);

  /// Lists all documents in the given collection
  Future<Iterable<dynamic>> list(String databaseId, String collectionId,
      {CosmosRequestOptions? options}) async {
    final result = await _client.get(
      'dbs/$databaseId/colls/$collectionId/docs',
      resourceType: ResourceType.item,
      removeLastPart: true,
      headers: options?.toHeaders() ?? const {},
    );
    return result['Documents'];
  }

  /// Executes the query in the given collection
  Future<Iterable<dynamic>> query(
      Query query, String databaseId, String collectionId,
      {CosmosRequestOptions? options}) async {
    final body = query.toMap();
    final result = await _client.post(
      'dbs/$databaseId/colls/$collectionId/docs',
      body,
      resourceType: ResourceType.item,
      removeLastPart: true,
      headers: (options?.toHeaders() ?? {})
        ..addAll({'Content-Type': 'application/query+json'}),
    );
    return result['Documents'];
  }

  /// Replaces the document with the given id with newDocument
  Future<Map<String, dynamic>> replace(Map<String, dynamic> newDocument,
      String databaseId, String collectionId, String documentId,
      {CosmosRequestOptions? options}) {
    options ??= CosmosRequestOptions(partitionKeys: [documentId]);
    return _client.put(
      'dbs/$databaseId/colls/$collectionId/docs/$documentId',
      newDocument,
      resourceType: ResourceType.item,
      removeLastPart: false,
      headers: options.toHeaders(),
    );
  }

  /// Deletes the document with the given id in the collection
  Future<void> delete(String databaseId, String collectionId, String documentId,
      {CosmosRequestOptions? options}) async {
    options ??= CosmosRequestOptions(partitionKeys: [documentId]);
    await _client.delete(
      'dbs/$databaseId/colls/$collectionId/docs/$documentId',
      resourceType: ResourceType.item,
      removeLastPart: false,
      headers: options.toHeaders(),
    );
  }

  /// Returns the document with the given id in the collection
  Future<Map<String, dynamic>> findById(
      String databaseId, String collectionId, String documentId,
      {CosmosRequestOptions? options}) async {
    options ??= CosmosRequestOptions(partitionKeys: [documentId]);
    return await _client.get(
      'dbs/$databaseId/colls/$collectionId/docs/$documentId',
      resourceType: ResourceType.item,
      removeLastPart: false,
      headers: options.toHeaders(),
    );
  }

  /// Creates a new document in the given collection
  /// The document must include an attribute called 'id'
  Future<Map<String, dynamic>> create(
    String databaseId,
    String collectionId,
    Map<String, dynamic> document, {
    CosmosRequestOptions? options,
  }) async {
    if (!document.containsKey('id')) {
      throw ArgumentError('id in document is required');
    }
    options ??= CosmosRequestOptions(partitionKeys: [document['id']]);
    return await _client.post(
      'dbs/$databaseId/colls/$collectionId/docs',
      document,
      removeLastPart: true,
      resourceType: ResourceType.item,
      headers: options.toHeaders(),
    );
  }
}

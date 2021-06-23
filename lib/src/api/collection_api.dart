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

import 'package:cosmosdb/model/request_options.dart';
import 'package:cosmosdb/src/cosmosdb_http_client.dart';
import 'package:cosmosdb/src/model/resource_type.dart';

/// Provides access to collection in a cosmosdb database
class CollectionApi {
  final CosmosDBHttpClient _client;

  /// Initializes the api with the http client
  const CollectionApi(this._client);

  /// Lists all collections in the given database
  Future<Iterable<String>> list(String databaseId,
      {CosmosRequestOptions? options}) async {
    final results = await _client.get(
      'dbs/$databaseId/colls',
      resourceType: ResourceType.container,
      removeLastPart: true,
      headers: options?.toHeaders() ?? const {},
    );
    List<dynamic> collections = results['DocumentCollections'];
    return collections.map((collection) => collection['id']);
  }

  /// Deletes the collection with the given id in the given database
  Future<void> delete(String databaseId, String collectionId,
      {CosmosRequestOptions? options}) {
    return _client.delete(
      'dbs/$databaseId/colls/$collectionId',
      resourceType: ResourceType.container,
      removeLastPart: false,
      headers: options?.toHeaders() ?? const {},
    );
  }

  /// Creates a new collection in the given database
  Future<void> create(String databaseId, String collectionId,
      {CosmosRequestOptions? options}) {
    var partitionKeys = options?.partitionKeys ?? ['/id'];
    return _client.post(
      'dbs/$databaseId/colls',
      {
        'id': collectionId,
        'partitionKey': {
          'paths': partitionKeys,
          'kind': 'Hash',
        }
      },
      resourceType: ResourceType.container,
      removeLastPart: true,
      headers: options?.toHeaders() ?? const {},
    );
  }

  /// Returns the collection id with the given collection id.
  /// Will throw an exception in case it does not exist at the given database.
  Future<String> findById(String databaseId, String collectionId,
      {CosmosRequestOptions? options}) {
    return _client
        .get(
          'dbs/$databaseId/colls/$collectionId',
          resourceType: ResourceType.container,
          removeLastPart: false,
          headers: options?.toHeaders() ?? const {},
        )
        .then((collection) => collection['id']);
  }
}

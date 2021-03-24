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

import 'package:cosmosdb/model/database.dart';
import 'package:cosmosdb/model/request_options.dart';
import 'package:cosmosdb/src/cosmosdb_http_client.dart';
import 'package:cosmosdb/src/model/resource_type.dart';

/// Manage cosmosdb databases
class DatabaseApi {
  final CosmosDBHttpClient _client;

  /// Initializes the api with the http client
  const DatabaseApi(this._client);

  /// Lists all databases on the server
  Future<Iterable<Database>> list({CosmosRequestOptions? options}) async {
    final results = await _client.get(
      'dbs',
      resourceType: ResourceType.database,
      removeLastPart: true,
      headers: options?.toHeaders() ?? const {},
    );
    List<dynamic> databases = results['Databases'];
    return databases.map(_databaseFromMap);
  }

  /// Deletes the database with the given id
  Future<void> delete(String databaseId, {CosmosRequestOptions? options}) {
    return _client.delete(
      'dbs/$databaseId',
      resourceType: ResourceType.database,
      removeLastPart: false,
      headers: options?.toHeaders() ?? const {},
    );
  }

  /// Creates a new database
  Future<Database> create(Database database, {CosmosRequestOptions? options}) {
    return _client
        .post(
          'dbs',
          database.toMap(),
          resourceType: ResourceType.database,
          removeLastPart: true,
          headers: options?.toHeaders() ?? const {},
        )
        .then(_databaseFromMap);
  }

  /// Returns the database with the given id.
  /// Will throw an exception if it does not exist.
  Future<Database> findById(String databaseId,
      {CosmosRequestOptions? options}) {
    return _client
        .get(
          'dbs/$databaseId',
          resourceType: ResourceType.database,
          removeLastPart: false,
          headers: options?.toHeaders() ?? const {},
        )
        .then(_databaseFromMap);
  }

  static Database _databaseFromMap(dynamic map) {
    return Database(id: map['id']);
  }
}

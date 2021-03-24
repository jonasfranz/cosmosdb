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

library cosmosdb;

import 'package:cosmosdb/src/api/collection_api.dart';
import 'package:cosmosdb/src/api/database_api.dart';
import 'package:cosmosdb/src/api/document_api.dart';
import 'package:cosmosdb/src/cosmosdb_http_client.dart';
import 'package:http/http.dart';

export 'model/database.dart';
export 'model/query.dart';
export 'model/request_options.dart';

/// A summary of APIs to access the cosmosdb using the given credentials and options
class CosmosDB {
  final CosmosDBHttpClient _client;

  /// API to access documents
  DocumentApi get documents => DocumentApi(_client);

  /// API to access collections
  CollectionApi get collections => CollectionApi(_client);

  /// API to access databases
  DatabaseApi get databases => DatabaseApi(_client);

  /// Configures the APIs with the credentials and a custom but optional http client
  CosmosDB({required masterKey, required baseUrl, Client? httpClient})
      : _client = CosmosDBHttpClient(
            masterKey: masterKey, baseUrl: baseUrl, httpClient: httpClient);
}

library cosmosdb;

import 'package:cosmosdb/api/collection_api.dart';
import 'package:cosmosdb/api/database_api.dart';
import 'package:cosmosdb/api/document_api.dart';
import 'package:cosmosdb/cosmosdb_http_client.dart';
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

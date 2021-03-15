library cosmosdb;

import 'package:cosmosdb/api/DocumentApi.dart';
import 'package:cosmosdb/cosmosdb_http_client.dart';

export 'model/query.dart';

class CosmosDB {
  final CosmosDBHttpClient _client;

  DocumentApi get documents => DocumentApi(_client);

  CosmosDB({required masterKey, required baseUrl})
      : _client = CosmosDBHttpClient(masterKey: masterKey, baseUrl: baseUrl);
}

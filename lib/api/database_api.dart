import 'package:cosmosdb/cosmosdb_http_client.dart';
import 'package:cosmosdb/model/database.dart';
import 'package:cosmosdb/model/resource_type.dart';

class DatabaseApi {
  final CosmosDBHttpClient _client;

  const DatabaseApi(this._client);

  Future<Iterable<Database>> list() async {
    final results = await _client.get(
      'dbs',
      resourceType: ResourceType.database,
      removeLastPart: true,
    );
    List<dynamic> databases = results['Databases'];
    return databases.map(_databaseFromMap);
  }

  Future<void> delete(String databaseId) {
    return _client.delete(
      'dbs/$databaseId',
      resourceType: ResourceType.database,
      removeLastPart: false,
    );
  }

  Future<Database> create(Database database) {
    return _client
        .post(
          'dbs',
          database.toMap(),
          resourceType: ResourceType.database,
          removeLastPart: true,
        )
        .then(_databaseFromMap);
  }

  Future<Database> findById(String databaseId) {
    return _client
        .get(
          'dbs/$databaseId',
          resourceType: ResourceType.database,
          removeLastPart: false,
        )
        .then(_databaseFromMap);
  }

  static Database _databaseFromMap(dynamic map) {
    return Database(id: map['id']);
  }
}

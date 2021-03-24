import 'package:cosmosdb/cosmosdb_http_client.dart';
import 'package:cosmosdb/model/database.dart';
import 'package:cosmosdb/model/request_options.dart';
import 'package:cosmosdb/model/resource_type.dart';

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

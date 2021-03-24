import 'package:cosmosdb/cosmosdb_http_client.dart';
import 'package:cosmosdb/model/request_options.dart';
import 'package:cosmosdb/model/resource_type.dart';

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
    return _client.post(
      'dbs/$databaseId/colls',
      {'id': collectionId},
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

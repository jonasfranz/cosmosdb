import 'package:cosmosdb/cosmosdb_http_client.dart';
import 'package:cosmosdb/model/request_options.dart';
import 'package:cosmosdb/model/resource_type.dart';

class CollectionApi {
  final CosmosDBHttpClient _client;

  const CollectionApi(this._client);

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

  Future<void> delete(String databaseId, String collectionId,
      {CosmosRequestOptions? options}) {
    return _client.delete(
      'dbs/$databaseId/colls/$collectionId',
      resourceType: ResourceType.container,
      removeLastPart: false,
      headers: options?.toHeaders() ?? const {},
    );
  }

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

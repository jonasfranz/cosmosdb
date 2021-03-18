import 'package:cosmosdb/cosmosdb_http_client.dart';
import 'package:cosmosdb/model/resource_type.dart';

class CollectionApi {
  final CosmosDBHttpClient _client;

  const CollectionApi(this._client);

  Future<Iterable<String>> list(String databaseId) async {
    final results = await _client.get(
      'dbs/$databaseId/colls',
      resourceType: ResourceType.container,
      removeLastPart: true,
    );
    List<dynamic> collections = results['DocumentCollections'];
    return collections.map((collection) => collection['id']);
  }

  Future<void> delete(String databaseId, String collectionId) {
    return _client.delete(
      'dbs/$databaseId/colls/$collectionId',
      resourceType: ResourceType.container,
      removeLastPart: false,
    );
  }

  Future<void> create(String databaseId, String collectionId) {
    return _client.post(
      'dbs/$databaseId/colls',
      {'id': collectionId},
      resourceType: ResourceType.container,
      removeLastPart: true,
    );
  }

  Future<String> findById(String databaseId, String collectionId) {
    return _client
        .get(
          'dbs/$databaseId/colls/$collectionId',
          resourceType: ResourceType.container,
          removeLastPart: false,
        )
        .then((collection) => collection['id']);
  }
}

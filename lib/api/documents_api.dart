import 'package:cosmosdb/cosmosdb_http_client.dart';
import 'package:cosmosdb/model/query.dart';
import 'package:cosmosdb/model/resource_type.dart';

class DocumentApi {
  final CosmosDBHttpClient _client;

  const DocumentApi(this._client);

  Future<Iterable<dynamic>> list(String databaseId, String collectionId) async {
    final result = await _client.get(
      'dbs/$databaseId/colls/$collectionId/docs',
      resourceType: ResourceType.item,
      removeLastPart: true,
    );
    return result['Documents'];
  }

  Future<Iterable<dynamic>> query(
      Query query, String databaseId, String collectionId) async {
    final result = await _client.post(
      'dbs/$databaseId/colls/$collectionId/docs',
      query.toMap(),
      resourceType: ResourceType.item,
      removeLastPart: true,
    );
    return result['Documents'];
  }

  Future<Map<String, dynamic>> replace(Map<String, dynamic> newDocument,
      String databaseId, String collectionId, String documentId) {
    return _client.put(
      'dbs/$databaseId/colls/$collectionId/docs/$documentId',
      newDocument,
      resourceType: ResourceType.item,
      removeLastPart: false,
    );
  }

  Future<void> delete(
      String databaseId, String collectionId, String documentId) async {
    await _client.delete(
      'dbs/$databaseId/colls/$collectionId/docs/$documentId',
      resourceType: ResourceType.item,
      removeLastPart: false,
    );
  }

  Future<Map<String, dynamic>> findById(
      String databaseId, String collectionId, String documentId) async {
    return await _client.get(
      'dbs/$databaseId/colls/$collectionId/docs/$documentId',
      resourceType: ResourceType.item,
      removeLastPart: false,
    );
  }
}

import 'package:cosmosdb/cosmosdb_http_client.dart';
import 'package:cosmosdb/model/query.dart';
import 'package:cosmosdb/model/resource_type.dart';

class DocumentApi {
  final CosmosDBHttpClient _client;

  const DocumentApi(this._client);

  Future<List<Map<String, dynamic>>> list(
      String databaseId, String collectionId) async {
    final result = await _client.get("dbs/$databaseId/colls/$collectionId/docs",
        resourceType: ResourceType.item);
    return result["Documents"];
  }

  Future<List<Map<String, dynamic>>> query(
      Query query, String databaseId, String collectionId) async {
    final result = await _client.post(
      "dbs/$databaseId/colls/$collectionId/docs",
      query.toMap(),
      resourceType: ResourceType.item,
    );
    return result["Documents"];
  }
}

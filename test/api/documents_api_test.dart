import 'package:cosmosdb/cosmosdb.dart';
import 'package:cosmosdb/model/database.dart';
import 'package:test/test.dart';

import 'test_config.dart';
import 'utils.dart';

void main() {
  group('documents api test', () {
    late CosmosDB cosmos;
    late String databaseId;
    setUp(() {
      cosmos = CosmosDB(
        masterKey: TestConfig.cosmosDBMasterKey,
        baseUrl: TestConfig.cosmosDBUrl,
      );
      databaseId = generateDatabaseName();
      return cosmos.databases.create(Database(id: databaseId));
    });
    tearDown(() async {
      await cosmos.databases.delete(databaseId);
    });

    test('check if creating a document works', () {
      expect(1, 1);
    });
  });
}

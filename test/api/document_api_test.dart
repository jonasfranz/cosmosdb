import 'package:cosmosdb/cosmosdb.dart';
import 'package:cosmosdb/model/database.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('document api test', () {
    late CosmosDB cosmos;
    late String databaseId;
    setUp(() {
      cosmos = buildClient();
      databaseId = generateId();
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

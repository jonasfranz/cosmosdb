import 'package:cosmosdb/cosmosdb.dart';
import 'package:cosmosdb/model/database.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('collection api test', () {
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

    test('check if creating a collection works', () async {
      final collectionId = generateId();
      await cosmos.collections.create(databaseId, collectionId);
    });

    test('check if findById works', () async {
      final collectionId = generateId();
      await cosmos.collections.create(databaseId, collectionId);
      final result =
          await cosmos.collections.findById(databaseId, collectionId);
      expect(result, collectionId);
    });

    test('check if delete works', () async {
      final collectionId = generateId();
      await cosmos.collections.create(databaseId, collectionId);
      await cosmos.collections.delete(databaseId, collectionId);
      expect(() => cosmos.collections.findById(databaseId, collectionId),
          throwsException);
    });

    test('check if list works', () async {
      final collectionId = generateId();
      await cosmos.collections.create(databaseId, collectionId);
      final results = await cosmos.collections.list(databaseId);
      expect(results, contains(collectionId));
    });
  });
}

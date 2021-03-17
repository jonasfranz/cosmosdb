import 'package:cosmosdb/model/database.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('database api test', () {
    final cosmos = buildClient();

    test('check if creating and deleting a database works', () async {
      final databaseId = generateDatabaseName();
      expect(
          await cosmos.databases
              .create(Database(id: databaseId))
              .then((db) => db.id),
          databaseId);
      await cosmos.databases.delete(databaseId);
    });

    test('check if listing databases works', () async {
      final databaseId = generateDatabaseName();
      await cosmos.databases.create(Database(id: databaseId));
      final dbs = await cosmos.databases.list();
      expect(dbs.toList()[0].id, databaseId);
      await cosmos.databases.delete(databaseId);
    });

    test('check if findById works', () async {
      final databaseId = generateDatabaseName();
      await cosmos.databases.create(Database(id: databaseId));
      final db = await cosmos.databases.findById(databaseId);
      expect(db.id, databaseId);
      await cosmos.databases.delete(databaseId);
    });
  });
}

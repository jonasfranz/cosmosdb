import 'package:cosmosdb/model/database.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('database api test', () {
    final cosmos = buildClient();

    test('check if creating a database works', () async {
      final databaseId = generateDatabaseName();
      expect(
          await cosmos.databases.create(Database(id: databaseId)), databaseId);
    });
  });
}

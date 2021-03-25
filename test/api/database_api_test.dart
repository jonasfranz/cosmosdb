// Copyright 2021 Jonas Franz
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:cosmosdb/model/database.dart';
import 'package:test/test.dart';

import 'utils.dart';

void main() {
  group('database api test', () {
    final cosmos = buildClient();

    test('check if creating and deleting a database works', () async {
      final databaseId = generateId();
      expect(
          await cosmos.databases
              .create(Database(id: databaseId))
              .then((db) => db.id),
          databaseId);
      await cosmos.databases.delete(databaseId);
    });

    test('check if listing databases works', () async {
      final databaseId = generateId();
      await cosmos.databases.create(Database(id: databaseId));
      final dbs = await cosmos.databases.list();
      expect(dbs.toList().any((db) => db.id == databaseId), true);
      await cosmos.databases.delete(databaseId);
    });

    test('check if findById works', () async {
      final databaseId = generateId();
      await cosmos.databases.create(Database(id: databaseId));
      final db = await cosmos.databases.findById(databaseId);
      expect(db.id, databaseId);
      await cosmos.databases.delete(databaseId);
    });
  });
}

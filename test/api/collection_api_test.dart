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

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
  group('document api test', () {
    late CosmosDB cosmos;
    late String databaseId;
    late String collectionId;
    setUp(() async {
      cosmos = buildClient();
      databaseId = generateId();
      collectionId = generateId();
      await cosmos.databases.create(Database(id: databaseId));
      await cosmos.collections.create(databaseId, collectionId);
    });
    tearDown(() async {
      await cosmos.collections.delete(databaseId, collectionId);
      await cosmos.databases.delete(databaseId);
    });

    test('check if creating a document works', () async {
      final documentId = generateId();
      final result = await cosmos.documents.create(
        databaseId,
        collectionId,
        {
          'id': documentId,
          'test': true,
        },
      );
      expect(result['id'], documentId);
    });

    test('check if listing documents works', () async {
      final documentId = generateId();
      await cosmos.documents
          .create(databaseId, collectionId, {'id': documentId});
      final results = await cosmos.documents.list(databaseId, collectionId);
      expect(results.isNotEmpty, true);
      expect(results.any((doc) => doc['id'] == documentId), true);
    });

    test('check if deleting documents works', () async {
      final documentId = generateId();
      await cosmos.documents
          .create(databaseId, collectionId, {'id': documentId});
      await cosmos.documents.delete(databaseId, collectionId, documentId);
      expect(
          () async => await cosmos.documents
              .findById(databaseId, collectionId, documentId),
          throwsException);
    });

    test('check if replacing a document works', () async {
      final documentId = generateId();
      final result = await cosmos.documents.create(
        databaseId,
        collectionId,
        {
          'id': documentId,
          'test': true,
        },
      );
      expect(result['test'], true);
      final replaced = await cosmos.documents.replace(
        {'id': documentId, 'test': false},
        databaseId,
        collectionId,
        documentId,
      );
      expect(replaced['test'], false);
    });

    test('check if querying a document works', () async {
      final documentId = generateId();
      await cosmos.documents.create(
        databaseId,
        collectionId,
        {
          'id': documentId,
          'test': true,
        },
      );
      final results = await cosmos.documents.query(
        Query(
            query:
                'SELECT * FROM $collectionId c WHERE c.id = @id AND c.test = @test',
            parameters: {
              'id': documentId,
              'test': true,
            }),
        databaseId,
        collectionId,
      );
      expect(results.length, 1);
    });
  });
}

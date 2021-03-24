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

import 'package:cosmosdb/src/model/resource_type.dart';
import 'package:cosmosdb/src/utils/auth_token_utils.dart';
import 'package:test/test.dart';

void main() {
  group('auth token utils', () {
    test('check if signature is as expected', () {
      expect(
          AuthTokenUtils.generateAuthSignature(
            verb: 'GET',
            resourceType: ResourceType.database,
            resourceLink: 'dbs/ToDoList',
            date: DateTime.utc(2017, DateTime.april, 27, 00, 51, 12, 0, 0),
            key:
                'dsZQi3KtZmCv1ljt3VNWNm7sQUF1y5rJfC6kv5JiwvW0EndXdDku/dkKBp8/ufDToSxLzR4y+O/0H/t4bQtVNw==',
          ),
          'c09PEVJrgp2uQRkr934kFbTqhByc7TVr3OHyqlu+c+c=');
    });

    test('check if token is as expected', () {
      expect(
          AuthTokenUtils.generateAuthToken(
                  signature: 'c09PEVJrgp2uQRkr934kFbTqhByc7TVr3OHyqlu+c+c=')
              .toLowerCase(),
          'type%3dmaster%26ver%3d1.0%26sig%3dc09PEVJrgp2uQRkr934kFbTqhByc7TVr3OHyqlu%2bc%2bc%3d'
              .toLowerCase());
    });
  });
}

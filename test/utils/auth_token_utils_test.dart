import 'package:cosmosdb/model/resource_type.dart';
import 'package:cosmosdb/utils/auth_token_utils.dart';
import 'package:test/test.dart';

void main() {
  group('auth token utils', () {
    test('check if signature is as expected', () {
      expect(
          AuthTokenUtils.generateAuthSignature(
            verb: "GET",
            resourceType: ResourceType.database,
            resourceLink: "dbs/ToDoList",
            date: DateTime.utc(2017, DateTime.april, 27, 00, 51, 12, 0, 0),
            key:
                "dsZQi3KtZmCv1ljt3VNWNm7sQUF1y5rJfC6kv5JiwvW0EndXdDku/dkKBp8/ufDToSxLzR4y+O/0H/t4bQtVNw==",
          ),
          "c09PEVJrgp2uQRkr934kFbTqhByc7TVr3OHyqlu+c+c=");
    });

    test('check if token is as expected', () {
      expect(
          AuthTokenUtils.generateAuthToken(
                  signature: "c09PEVJrgp2uQRkr934kFbTqhByc7TVr3OHyqlu+c+c=")
              .toLowerCase(),
          "type%3dmaster%26ver%3d1.0%26sig%3dc09PEVJrgp2uQRkr934kFbTqhByc7TVr3OHyqlu%2bc%2bc%3d"
              .toLowerCase());
    });
  });
}

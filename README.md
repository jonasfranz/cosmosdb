# cosmosdb

[![codecov](https://codecov.io/gh/jonasfranz/cosmosdb/branch/master/graph/badge.svg?token=LLQQAP43A6)](https://codecov.io/gh/jonasfranz/cosmosdb)
[![build](https://github.com/jonasfranz/cosmosdb/workflows/Dart-CI/badge.svg?branch=master)](https://github.com/jonasfranz/cosmosdb/actions) 
[![pub package](https://img.shields.io/pub/v/cosmosdb.svg)](https://pub.dev/packages/cosmosdb)
[![pub points](https://badges.bar/cosmosdb/pub%20points)](https://pub.dev/packages/cosmosdb/score)
 
This projects offers an API client to interact with the CosmosDB SQL-API in Dart. This project is an early state and not considered stable.

## Getting Started

The database can be accessed via the CosmosDB client:
```dart
import 'package:cosmosdb/cosmosdb.dart';

void main() {
    final cosmosDB = CosmosDB(
      masterKey: '<YOUR_MASTER_KEY>',
      baseUrl: '<YOUR_BASE_URL>',
    );
    // get all documents from a collection
    final documents = cosmosDB.documents.list('<YOUR_DATABASE>', '<YOUR_COLLECTION>');
    print(documents);
}
```
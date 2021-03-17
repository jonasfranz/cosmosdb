import 'dart:io';
import 'dart:math';

import 'package:cosmosdb/cosmosdb.dart';
import 'package:crypto/crypto.dart';
import 'package:http/io_client.dart';

import 'test_config.dart';

String generateDatabaseName() {
  final random = Random();
  var values = List<int>.generate(32, (i) => random.nextInt(256));
  return md5.convert(values).toString();
}

CosmosDB buildClient() {
  final client = HttpClient();
  if (TestConfig.ignoreSelfSignedCertificates) {
    client.badCertificateCallback = (_, __, ___) => true;
  }
  return CosmosDB(
    masterKey: TestConfig.cosmosDBMasterKey,
    baseUrl: TestConfig.cosmosDBUrl,
    httpClient: IOClient(client),
  );
}

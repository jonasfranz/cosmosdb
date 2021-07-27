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

import 'package:universal_io/io.dart';

class TestConfig {
  late final String cosmosDBUrl;
  late final String cosmosDBMasterKey;
  late final bool ignoreSelfSignedCertificates;

  TestConfig() {
    cosmosDBUrl =
        Platform.environment['COSMOS_DB_URL'] ?? 'https://localhost:8081/';
    cosmosDBMasterKey = Platform.environment['COSMOS_DB_MASTER_KEY'] ??
        'C2y6yDjf5/R+ob0N8A7Cgv30VRDJIWEHLM+4QDU5DE2nQ9nDuVTqobD4b8mGGyPMbIZnqyMsEcaGQy67XIw/Jw==';
    ignoreSelfSignedCertificates =
        Platform.environment['COSMOS_DB_IGNORE_SSL'] != null;
  }
}

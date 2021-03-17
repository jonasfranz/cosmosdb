class TestConfig {
  const TestConfig._();

  static const cosmosDBUrl = String.fromEnvironment('COSMOS_DB_URL',
      defaultValue: 'https://localhost:8081/');
  static const cosmosDBMasterKey = String.fromEnvironment(
      'COSMOS_DB_MASTER_KEY',
      defaultValue:
          'C2y6yDjf5/R+ob0N8A7Cgv30VRDJIWEHLM+4QDU5DE2nQ9nDuVTqobD4b8mGGyPMbIZnqyMsEcaGQy67XIw/Jw==');
  static const ignoreSelfSignedCertificates =
      bool.fromEnvironment('COSMOS_DB_IGNORE_SSL', defaultValue: true);
}

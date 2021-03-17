class TestConfig {
  const TestConfig._();

  static const cosmosDBUrl =
      String.fromEnvironment('COSMOS_DB_URL', defaultValue: '');
  static const cosmosDBMasterKey =
      String.fromEnvironment('COSMOS_DB_MASTER_KEY', defaultValue: '');
}

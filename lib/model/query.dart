/// SQL Query for querying documents
class Query {
  /// SQL query string
  final String query;

  /// Parameters of the query
  final Map<String, String> parameters;

  /// Creates a new SQL query with optional parameters
  const Query({required this.query, this.parameters = const {}});

  /// Converts query to cosmosdb compatible map
  Map<String, dynamic> toMap() => {
        'query': query,
        'parameters': parameters.entries.map((param) => {
              'name': param.key,
              'value': param.value,
        })
      };
}

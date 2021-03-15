class Query {
  final String query;
  final Map<String, String> parameters;

  const Query({required this.query, this.parameters = const {}});

  Map<String, dynamic> toMap() => {
        "query": query,
        "parameters": parameters.entries.map((param) => {
              "name": param.key,
              "value": param.value,
            })
      };
}

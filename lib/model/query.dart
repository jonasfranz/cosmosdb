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

/// SQL Query for querying documents
class Query {
  /// SQL query string
  final String query;

  /// Parameters of the query
  final Map<String, dynamic> parameters;

  /// Creates a new SQL query with optional parameters
  const Query({required this.query, this.parameters = const {}});

  /// Converts query to cosmosdb compatible map
  Map<String, dynamic> toMap() => {
        'query': query,
        'parameters': parameters.entries
            .map((param) => {
                  'name': '@' + param.key,
                  'value': param.value,
                })
            .toList()
      };
}

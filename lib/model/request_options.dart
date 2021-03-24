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

import 'dart:convert';

/// Common request options for cosmosdb requests
class CosmosRequestOptions {
  /// The partition key value for the requested document or attachment operation.
  /// Required for operations against documents and attachments when the collection definition includes a partition key definition.
  /// This value is used to scope your query to documents that match the partition key criteria.
  /// By design it's a single partition query.
  /// Currently, the SQL API supports a single partition key, so this is an array containing just one value.
  final List<String>? partitionKeys;

  /// An integer indicating the maximum number of items to be returned per page.
  /// An maxItemCount of -1 can be specified to let the service determine the optimal item count.
  /// This is the recommended configuration value for maxItemCount
  final int? maxItemCount;

  /// When this header is set to true and if your query doesn't have a partition key,
  /// Azure Cosmos DB fans out the query across partitions.
  final bool? enableCrossPartition;

  /// When this header is set to true for the Azure Cosmos accounts configured with multiple write locations,
  /// Azure Cosmos DB will allow writes to all locations.
  final bool? allowTentativeWrites;

  /// Construct common request options for cosmosdb requests
  const CosmosRequestOptions({
    this.partitionKeys,
    this.maxItemCount,
    this.enableCrossPartition,
    this.allowTentativeWrites,
  });

  /// Generates HTTP headers for the given options
  Map<String, String> toHeaders() => {
        if (partitionKeys != null)
          'x-ms-documentdb-partitionkey': jsonEncode(partitionKeys),
        if (maxItemCount != null)
          'x-ms-max-item-count': maxItemCount.toString(),
        if (enableCrossPartition != null)
          'x-ms-documentdb-query-enablecrosspartition':
              enableCrossPartition.toString(),
        if (allowTentativeWrites != null)
          'x-ms-cosmos-allow-tentative-writes': allowTentativeWrites.toString(),
      };
}

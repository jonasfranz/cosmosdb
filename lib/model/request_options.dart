import 'dart:convert';

class CosmosRequestOptions {
  final List<String>? partitionKeys;
  final int? maxItemCount;
  final bool? enableCrossPartition;
  final bool? allowTentativeWrites;

  const CosmosRequestOptions({
    this.partitionKeys,
    this.maxItemCount,
    this.enableCrossPartition,
    this.allowTentativeWrites,
  });

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

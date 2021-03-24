/// A cosmosdb database
class Database {
  /// ID of the database
  final String id;

  /// Initialize the database with an id
  const Database({required this.id});

  /// Converts the database to a cosmosdb compatible map
  Map<String, dynamic> toMap() => {'id': id};
}

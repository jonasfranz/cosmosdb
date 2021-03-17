class Database {
  final String id;

  const Database({required this.id});

  Map<String, dynamic> toMap() => {'id': id};
}

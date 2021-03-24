// Internal use only
// ignore_for_file: public_member_api_docs

enum ResourceType {
  none,
  database,
  offer,
  user,
  permission,
  container,
  conflicts,
  sproc,
  udf,
  trigger,
  item,
  pkranges
}

extension ResourceTypeKeys on ResourceType {
  static const Map<ResourceType, String> _keys = {
    ResourceType.none: '',
    ResourceType.database: 'dbs',
    ResourceType.offer: 'offers',
    ResourceType.user: 'users',
    ResourceType.permission: 'permissions',
    ResourceType.container: 'colls',
    ResourceType.conflicts: 'conflicts',
    ResourceType.sproc: 'sprocs',
    ResourceType.udf: 'udfs',
    ResourceType.trigger: 'triggers',
    ResourceType.item: 'docs',
    ResourceType.pkranges: 'pkranges'
  };

  String get key {
    return _keys[this] ?? 'none';
  }
}

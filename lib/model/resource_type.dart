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

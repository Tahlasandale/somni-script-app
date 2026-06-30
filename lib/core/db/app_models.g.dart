// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserConfigCollection on Isar {
  IsarCollection<UserConfig> get userConfigs => this.collection();
}

const UserConfigSchema = CollectionSchema(
  name: r'UserConfig',
  id: 1844971189088430043,
  properties: {
    r'geminiApiKey': PropertySchema(
      id: 0,
      name: r'geminiApiKey',
      type: IsarType.string,
    ),
    r'lastModified': PropertySchema(
      id: 1,
      name: r'lastModified',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 2,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _userConfigEstimateSize,
  serialize: _userConfigSerialize,
  deserialize: _userConfigDeserialize,
  deserializeProp: _userConfigDeserializeProp,
  idName: r'id',
  indexes: {
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _userConfigGetId,
  getLinks: _userConfigGetLinks,
  attach: _userConfigAttach,
  version: '3.1.0+1',
);

int _userConfigEstimateSize(
  UserConfig object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.geminiApiKey.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _userConfigSerialize(
  UserConfig object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.geminiApiKey);
  writer.writeDateTime(offsets[1], object.lastModified);
  writer.writeString(offsets[2], object.userId);
}

UserConfig _userConfigDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserConfig();
  object.geminiApiKey = reader.readString(offsets[0]);
  object.id = id;
  object.lastModified = reader.readDateTime(offsets[1]);
  object.userId = reader.readString(offsets[2]);
  return object;
}

P _userConfigDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userConfigGetId(UserConfig object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userConfigGetLinks(UserConfig object) {
  return [];
}

void _userConfigAttach(IsarCollection<dynamic> col, Id id, UserConfig object) {
  object.id = id;
}

extension UserConfigByIndex on IsarCollection<UserConfig> {
  Future<UserConfig?> getByUserId(String userId) {
    return getByIndex(r'userId', [userId]);
  }

  UserConfig? getByUserIdSync(String userId) {
    return getByIndexSync(r'userId', [userId]);
  }

  Future<bool> deleteByUserId(String userId) {
    return deleteByIndex(r'userId', [userId]);
  }

  bool deleteByUserIdSync(String userId) {
    return deleteByIndexSync(r'userId', [userId]);
  }

  Future<List<UserConfig?>> getAllByUserId(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'userId', values);
  }

  List<UserConfig?> getAllByUserIdSync(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'userId', values);
  }

  Future<int> deleteAllByUserId(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'userId', values);
  }

  int deleteAllByUserIdSync(List<String> userIdValues) {
    final values = userIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'userId', values);
  }

  Future<Id> putByUserId(UserConfig object) {
    return putByIndex(r'userId', object);
  }

  Id putByUserIdSync(UserConfig object, {bool saveLinks = true}) {
    return putByIndexSync(r'userId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUserId(List<UserConfig> objects) {
    return putAllByIndex(r'userId', objects);
  }

  List<Id> putAllByUserIdSync(List<UserConfig> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'userId', objects, saveLinks: saveLinks);
  }
}

extension UserConfigQueryWhereSort
    on QueryBuilder<UserConfig, UserConfig, QWhere> {
  QueryBuilder<UserConfig, UserConfig, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserConfigQueryWhere
    on QueryBuilder<UserConfig, UserConfig, QWhereClause> {
  QueryBuilder<UserConfig, UserConfig, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterWhereClause> userIdEqualTo(
      String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterWhereClause> userIdNotEqualTo(
      String userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension UserConfigQueryFilter
    on QueryBuilder<UserConfig, UserConfig, QFilterCondition> {
  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      geminiApiKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'geminiApiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      geminiApiKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'geminiApiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      geminiApiKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'geminiApiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      geminiApiKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'geminiApiKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      geminiApiKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'geminiApiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      geminiApiKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'geminiApiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      geminiApiKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'geminiApiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      geminiApiKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'geminiApiKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      geminiApiKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'geminiApiKey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      geminiApiKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'geminiApiKey',
        value: '',
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      lastModifiedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastModified',
        value: value,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      lastModifiedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastModified',
        value: value,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      lastModifiedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastModified',
        value: value,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      lastModifiedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastModified',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> userIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> userIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension UserConfigQueryObject
    on QueryBuilder<UserConfig, UserConfig, QFilterCondition> {}

extension UserConfigQueryLinks
    on QueryBuilder<UserConfig, UserConfig, QFilterCondition> {}

extension UserConfigQuerySortBy
    on QueryBuilder<UserConfig, UserConfig, QSortBy> {
  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> sortByGeminiApiKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geminiApiKey', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> sortByGeminiApiKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geminiApiKey', Sort.desc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> sortByLastModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> sortByLastModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.desc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension UserConfigQuerySortThenBy
    on QueryBuilder<UserConfig, UserConfig, QSortThenBy> {
  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenByGeminiApiKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geminiApiKey', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenByGeminiApiKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'geminiApiKey', Sort.desc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenByLastModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenByLastModifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastModified', Sort.desc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension UserConfigQueryWhereDistinct
    on QueryBuilder<UserConfig, UserConfig, QDistinct> {
  QueryBuilder<UserConfig, UserConfig, QDistinct> distinctByGeminiApiKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'geminiApiKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserConfig, UserConfig, QDistinct> distinctByLastModified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastModified');
    });
  }

  QueryBuilder<UserConfig, UserConfig, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension UserConfigQueryProperty
    on QueryBuilder<UserConfig, UserConfig, QQueryProperty> {
  QueryBuilder<UserConfig, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserConfig, String, QQueryOperations> geminiApiKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'geminiApiKey');
    });
  }

  QueryBuilder<UserConfig, DateTime, QQueryOperations> lastModifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastModified');
    });
  }

  QueryBuilder<UserConfig, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMediaHistoryCollection on Isar {
  IsarCollection<MediaHistory> get mediaHistorys => this.collection();
}

const MediaHistorySchema = CollectionSchema(
  name: r'MediaHistory',
  id: 9134992437946436304,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'fullNarrativeText': PropertySchema(
      id: 1,
      name: r'fullNarrativeText',
      type: IsarType.string,
    ),
    r'generatedPlanJson': PropertySchema(
      id: 2,
      name: r'generatedPlanJson',
      type: IsarType.string,
    ),
    r'mediaType': PropertySchema(
      id: 3,
      name: r'mediaType',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 4,
      name: r'title',
      type: IsarType.string,
    ),
    r'userPrompt': PropertySchema(
      id: 5,
      name: r'userPrompt',
      type: IsarType.string,
    )
  },
  estimateSize: _mediaHistoryEstimateSize,
  serialize: _mediaHistorySerialize,
  deserialize: _mediaHistoryDeserialize,
  deserializeProp: _mediaHistoryDeserializeProp,
  idName: r'id',
  indexes: {
    r'mediaType': IndexSchema(
      id: 6292565701790234963,
      name: r'mediaType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'mediaType',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {
    r'audioPreferences': LinkSchema(
      id: 797763188588860653,
      name: r'audioPreferences',
      target: r'AudioPreferences',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _mediaHistoryGetId,
  getLinks: _mediaHistoryGetLinks,
  attach: _mediaHistoryAttach,
  version: '3.1.0+1',
);

int _mediaHistoryEstimateSize(
  MediaHistory object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.fullNarrativeText.length * 3;
  bytesCount += 3 + object.generatedPlanJson.length * 3;
  bytesCount += 3 + object.mediaType.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.userPrompt.length * 3;
  return bytesCount;
}

void _mediaHistorySerialize(
  MediaHistory object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.fullNarrativeText);
  writer.writeString(offsets[2], object.generatedPlanJson);
  writer.writeString(offsets[3], object.mediaType);
  writer.writeString(offsets[4], object.title);
  writer.writeString(offsets[5], object.userPrompt);
}

MediaHistory _mediaHistoryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MediaHistory();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.fullNarrativeText = reader.readString(offsets[1]);
  object.generatedPlanJson = reader.readString(offsets[2]);
  object.id = id;
  object.mediaType = reader.readString(offsets[3]);
  object.title = reader.readString(offsets[4]);
  object.userPrompt = reader.readString(offsets[5]);
  return object;
}

P _mediaHistoryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _mediaHistoryGetId(MediaHistory object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _mediaHistoryGetLinks(MediaHistory object) {
  return [object.audioPreferences];
}

void _mediaHistoryAttach(
    IsarCollection<dynamic> col, Id id, MediaHistory object) {
  object.id = id;
  object.audioPreferences.attach(
      col, col.isar.collection<AudioPreferences>(), r'audioPreferences', id);
}

extension MediaHistoryQueryWhereSort
    on QueryBuilder<MediaHistory, MediaHistory, QWhere> {
  QueryBuilder<MediaHistory, MediaHistory, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension MediaHistoryQueryWhere
    on QueryBuilder<MediaHistory, MediaHistory, QWhereClause> {
  QueryBuilder<MediaHistory, MediaHistory, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterWhereClause> mediaTypeEqualTo(
      String mediaType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'mediaType',
        value: [mediaType],
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterWhereClause>
      mediaTypeNotEqualTo(String mediaType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mediaType',
              lower: [],
              upper: [mediaType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mediaType',
              lower: [mediaType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mediaType',
              lower: [mediaType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mediaType',
              lower: [],
              upper: [mediaType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterWhereClause> createdAtEqualTo(
      DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterWhereClause>
      createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterWhereClause>
      createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterWhereClause> createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterWhereClause> createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MediaHistoryQueryFilter
    on QueryBuilder<MediaHistory, MediaHistory, QFilterCondition> {
  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      fullNarrativeTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullNarrativeText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      fullNarrativeTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fullNarrativeText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      fullNarrativeTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fullNarrativeText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      fullNarrativeTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fullNarrativeText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      fullNarrativeTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fullNarrativeText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      fullNarrativeTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fullNarrativeText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      fullNarrativeTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fullNarrativeText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      fullNarrativeTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fullNarrativeText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      fullNarrativeTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fullNarrativeText',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      fullNarrativeTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fullNarrativeText',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      generatedPlanJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generatedPlanJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      generatedPlanJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'generatedPlanJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      generatedPlanJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'generatedPlanJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      generatedPlanJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'generatedPlanJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      generatedPlanJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'generatedPlanJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      generatedPlanJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'generatedPlanJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      generatedPlanJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'generatedPlanJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      generatedPlanJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'generatedPlanJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      generatedPlanJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generatedPlanJson',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      generatedPlanJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'generatedPlanJson',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      mediaTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      mediaTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      mediaTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      mediaTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mediaType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      mediaTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      mediaTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      mediaTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mediaType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      mediaTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mediaType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      mediaTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mediaType',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      mediaTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mediaType',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      userPromptEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userPrompt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      userPromptGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userPrompt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      userPromptLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userPrompt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      userPromptBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userPrompt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      userPromptStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userPrompt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      userPromptEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userPrompt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      userPromptContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userPrompt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      userPromptMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userPrompt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      userPromptIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userPrompt',
        value: '',
      ));
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      userPromptIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userPrompt',
        value: '',
      ));
    });
  }
}

extension MediaHistoryQueryObject
    on QueryBuilder<MediaHistory, MediaHistory, QFilterCondition> {}

extension MediaHistoryQueryLinks
    on QueryBuilder<MediaHistory, MediaHistory, QFilterCondition> {
  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      audioPreferences(FilterQuery<AudioPreferences> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'audioPreferences');
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterFilterCondition>
      audioPreferencesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'audioPreferences', 0, true, 0, true);
    });
  }
}

extension MediaHistoryQuerySortBy
    on QueryBuilder<MediaHistory, MediaHistory, QSortBy> {
  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy>
      sortByFullNarrativeText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullNarrativeText', Sort.asc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy>
      sortByFullNarrativeTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullNarrativeText', Sort.desc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy>
      sortByGeneratedPlanJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedPlanJson', Sort.asc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy>
      sortByGeneratedPlanJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedPlanJson', Sort.desc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy> sortByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.asc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy> sortByMediaTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.desc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy> sortByUserPrompt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userPrompt', Sort.asc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy>
      sortByUserPromptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userPrompt', Sort.desc);
    });
  }
}

extension MediaHistoryQuerySortThenBy
    on QueryBuilder<MediaHistory, MediaHistory, QSortThenBy> {
  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy>
      thenByFullNarrativeText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullNarrativeText', Sort.asc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy>
      thenByFullNarrativeTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullNarrativeText', Sort.desc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy>
      thenByGeneratedPlanJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedPlanJson', Sort.asc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy>
      thenByGeneratedPlanJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedPlanJson', Sort.desc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy> thenByMediaType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.asc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy> thenByMediaTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mediaType', Sort.desc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy> thenByUserPrompt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userPrompt', Sort.asc);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QAfterSortBy>
      thenByUserPromptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userPrompt', Sort.desc);
    });
  }
}

extension MediaHistoryQueryWhereDistinct
    on QueryBuilder<MediaHistory, MediaHistory, QDistinct> {
  QueryBuilder<MediaHistory, MediaHistory, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QDistinct>
      distinctByFullNarrativeText({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullNarrativeText',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QDistinct>
      distinctByGeneratedPlanJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'generatedPlanJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QDistinct> distinctByMediaType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mediaType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MediaHistory, MediaHistory, QDistinct> distinctByUserPrompt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userPrompt', caseSensitive: caseSensitive);
    });
  }
}

extension MediaHistoryQueryProperty
    on QueryBuilder<MediaHistory, MediaHistory, QQueryProperty> {
  QueryBuilder<MediaHistory, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MediaHistory, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<MediaHistory, String, QQueryOperations>
      fullNarrativeTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullNarrativeText');
    });
  }

  QueryBuilder<MediaHistory, String, QQueryOperations>
      generatedPlanJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generatedPlanJson');
    });
  }

  QueryBuilder<MediaHistory, String, QQueryOperations> mediaTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mediaType');
    });
  }

  QueryBuilder<MediaHistory, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<MediaHistory, String, QQueryOperations> userPromptProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userPrompt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAudioPreferencesCollection on Isar {
  IsarCollection<AudioPreferences> get audioPreferences => this.collection();
}

const AudioPreferencesSchema = CollectionSchema(
  name: r'AudioPreferences',
  id: -707308122596558492,
  properties: {
    r'lofiVolume': PropertySchema(
      id: 0,
      name: r'lofiVolume',
      type: IsarType.double,
    ),
    r'oceanVolume': PropertySchema(
      id: 1,
      name: r'oceanVolume',
      type: IsarType.double,
    ),
    r'rainVolume': PropertySchema(
      id: 2,
      name: r'rainVolume',
      type: IsarType.double,
    ),
    r'sleepTimerDurationMinutes': PropertySchema(
      id: 3,
      name: r'sleepTimerDurationMinutes',
      type: IsarType.long,
    ),
    r'voiceVolume': PropertySchema(
      id: 4,
      name: r'voiceVolume',
      type: IsarType.double,
    ),
    r'whiteNoiseVolume': PropertySchema(
      id: 5,
      name: r'whiteNoiseVolume',
      type: IsarType.double,
    )
  },
  estimateSize: _audioPreferencesEstimateSize,
  serialize: _audioPreferencesSerialize,
  deserialize: _audioPreferencesDeserialize,
  deserializeProp: _audioPreferencesDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'mediaHistory': LinkSchema(
      id: -8860656399628867375,
      name: r'mediaHistory',
      target: r'MediaHistory',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _audioPreferencesGetId,
  getLinks: _audioPreferencesGetLinks,
  attach: _audioPreferencesAttach,
  version: '3.1.0+1',
);

int _audioPreferencesEstimateSize(
  AudioPreferences object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _audioPreferencesSerialize(
  AudioPreferences object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.lofiVolume);
  writer.writeDouble(offsets[1], object.oceanVolume);
  writer.writeDouble(offsets[2], object.rainVolume);
  writer.writeLong(offsets[3], object.sleepTimerDurationMinutes);
  writer.writeDouble(offsets[4], object.voiceVolume);
  writer.writeDouble(offsets[5], object.whiteNoiseVolume);
}

AudioPreferences _audioPreferencesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AudioPreferences();
  object.id = id;
  object.lofiVolume = reader.readDouble(offsets[0]);
  object.oceanVolume = reader.readDouble(offsets[1]);
  object.rainVolume = reader.readDouble(offsets[2]);
  object.sleepTimerDurationMinutes = reader.readLong(offsets[3]);
  object.voiceVolume = reader.readDouble(offsets[4]);
  object.whiteNoiseVolume = reader.readDouble(offsets[5]);
  return object;
}

P _audioPreferencesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _audioPreferencesGetId(AudioPreferences object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _audioPreferencesGetLinks(AudioPreferences object) {
  return [object.mediaHistory];
}

void _audioPreferencesAttach(
    IsarCollection<dynamic> col, Id id, AudioPreferences object) {
  object.id = id;
  object.mediaHistory
      .attach(col, col.isar.collection<MediaHistory>(), r'mediaHistory', id);
}

extension AudioPreferencesQueryWhereSort
    on QueryBuilder<AudioPreferences, AudioPreferences, QWhere> {
  QueryBuilder<AudioPreferences, AudioPreferences, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AudioPreferencesQueryWhere
    on QueryBuilder<AudioPreferences, AudioPreferences, QWhereClause> {
  QueryBuilder<AudioPreferences, AudioPreferences, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AudioPreferencesQueryFilter
    on QueryBuilder<AudioPreferences, AudioPreferences, QFilterCondition> {
  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      lofiVolumeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lofiVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      lofiVolumeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lofiVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      lofiVolumeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lofiVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      lofiVolumeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lofiVolume',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      oceanVolumeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'oceanVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      oceanVolumeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'oceanVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      oceanVolumeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'oceanVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      oceanVolumeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'oceanVolume',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      rainVolumeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rainVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      rainVolumeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rainVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      rainVolumeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rainVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      rainVolumeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rainVolume',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      sleepTimerDurationMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sleepTimerDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      sleepTimerDurationMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sleepTimerDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      sleepTimerDurationMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sleepTimerDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      sleepTimerDurationMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sleepTimerDurationMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      voiceVolumeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'voiceVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      voiceVolumeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'voiceVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      voiceVolumeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'voiceVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      voiceVolumeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'voiceVolume',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      whiteNoiseVolumeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'whiteNoiseVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      whiteNoiseVolumeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'whiteNoiseVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      whiteNoiseVolumeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'whiteNoiseVolume',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      whiteNoiseVolumeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'whiteNoiseVolume',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension AudioPreferencesQueryObject
    on QueryBuilder<AudioPreferences, AudioPreferences, QFilterCondition> {}

extension AudioPreferencesQueryLinks
    on QueryBuilder<AudioPreferences, AudioPreferences, QFilterCondition> {
  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      mediaHistory(FilterQuery<MediaHistory> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'mediaHistory');
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterFilterCondition>
      mediaHistoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'mediaHistory', 0, true, 0, true);
    });
  }
}

extension AudioPreferencesQuerySortBy
    on QueryBuilder<AudioPreferences, AudioPreferences, QSortBy> {
  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      sortByLofiVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lofiVolume', Sort.asc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      sortByLofiVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lofiVolume', Sort.desc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      sortByOceanVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'oceanVolume', Sort.asc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      sortByOceanVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'oceanVolume', Sort.desc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      sortByRainVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rainVolume', Sort.asc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      sortByRainVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rainVolume', Sort.desc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      sortBySleepTimerDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepTimerDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      sortBySleepTimerDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepTimerDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      sortByVoiceVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceVolume', Sort.asc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      sortByVoiceVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceVolume', Sort.desc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      sortByWhiteNoiseVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteNoiseVolume', Sort.asc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      sortByWhiteNoiseVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteNoiseVolume', Sort.desc);
    });
  }
}

extension AudioPreferencesQuerySortThenBy
    on QueryBuilder<AudioPreferences, AudioPreferences, QSortThenBy> {
  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      thenByLofiVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lofiVolume', Sort.asc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      thenByLofiVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lofiVolume', Sort.desc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      thenByOceanVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'oceanVolume', Sort.asc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      thenByOceanVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'oceanVolume', Sort.desc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      thenByRainVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rainVolume', Sort.asc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      thenByRainVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rainVolume', Sort.desc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      thenBySleepTimerDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepTimerDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      thenBySleepTimerDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sleepTimerDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      thenByVoiceVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceVolume', Sort.asc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      thenByVoiceVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceVolume', Sort.desc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      thenByWhiteNoiseVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteNoiseVolume', Sort.asc);
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QAfterSortBy>
      thenByWhiteNoiseVolumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whiteNoiseVolume', Sort.desc);
    });
  }
}

extension AudioPreferencesQueryWhereDistinct
    on QueryBuilder<AudioPreferences, AudioPreferences, QDistinct> {
  QueryBuilder<AudioPreferences, AudioPreferences, QDistinct>
      distinctByLofiVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lofiVolume');
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QDistinct>
      distinctByOceanVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'oceanVolume');
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QDistinct>
      distinctByRainVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rainVolume');
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QDistinct>
      distinctBySleepTimerDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sleepTimerDurationMinutes');
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QDistinct>
      distinctByVoiceVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'voiceVolume');
    });
  }

  QueryBuilder<AudioPreferences, AudioPreferences, QDistinct>
      distinctByWhiteNoiseVolume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'whiteNoiseVolume');
    });
  }
}

extension AudioPreferencesQueryProperty
    on QueryBuilder<AudioPreferences, AudioPreferences, QQueryProperty> {
  QueryBuilder<AudioPreferences, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AudioPreferences, double, QQueryOperations>
      lofiVolumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lofiVolume');
    });
  }

  QueryBuilder<AudioPreferences, double, QQueryOperations>
      oceanVolumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'oceanVolume');
    });
  }

  QueryBuilder<AudioPreferences, double, QQueryOperations>
      rainVolumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rainVolume');
    });
  }

  QueryBuilder<AudioPreferences, int, QQueryOperations>
      sleepTimerDurationMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sleepTimerDurationMinutes');
    });
  }

  QueryBuilder<AudioPreferences, double, QQueryOperations>
      voiceVolumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'voiceVolume');
    });
  }

  QueryBuilder<AudioPreferences, double, QQueryOperations>
      whiteNoiseVolumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'whiteNoiseVolume');
    });
  }
}

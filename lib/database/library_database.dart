import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:library_app/database/category_dao.dart';
import 'package:library_app/database/score_subcategories_dao.dart';
import 'package:library_app/database/scores_dao.dart';
import 'package:library_app/database/session_dao.dart';
import 'package:path_provider/path_provider.dart';

part 'library_database.g.dart';

@DataClassName('UserSessionData')
class Sessions extends Table {
  TextColumn get libraryName => text()();
  TextColumn get userId => text()();
  TextColumn get sheetId => text()();
  TextColumn get driveFolderId => text().nullable()();
  BoolColumn get isAdmin => boolean().withDefault(Constant(false))();
  BoolColumn get isActive => boolean().withDefault(Constant(false))();

  @override
  Set<Column> get primaryKey => {userId};
}

@DataClassName('ScoreData')
@TableIndex(name: 'score_title', columns: {#title})
class Scores extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  IntColumn get composerId => integer().references(Composers, #id)();
  TextColumn get arranger => text().withDefault(const Constant(""))();
  TextColumn get catalogNumber => text()();
  TextColumn get notes => text().withDefault(const Constant(""))();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get status => text()();
  TextColumn get link => text().nullable()();
  DateTimeColumn get changeTime => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('ComposerData')
class Composers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

@DataClassName('SubcategoryData')
class Subcategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get categoryId => integer().references(Categories, #id)();
}

@DataClassName('CategoryData')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get identifier => text().withLength(max: 10)();
}

@DataClassName('ScoreSubcategory')
class ScoreSubcategories extends Table {
  IntColumn get scoreId => integer().references(Scores, #id)();
  IntColumn get subcategoryId => integer().references(Subcategories, #id)();

  @override
  Set<Column<Object>> get primaryKey => {scoreId, subcategoryId};
}

@DriftDatabase(
  tables: [
    Sessions,
    Composers,
    Categories,
    Subcategories,
    ScoreSubcategories,
    Scores,
  ],
  daos: [ScoresDao, ScoreSubcategoriesDao, CategoryDao, SessionDao],
)
class LibraryDatabase extends _$LibraryDatabase {
  LibraryDatabase([QueryExecutor? executor])
    : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'library_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}

/*

SCORE
* string score_id (PK)
* string title
* int composer_id (FK)
* string arranger
* string catalog number
* string notes
* int category_id (FK)
* string status
* string link

COMPOSER
* string composer_id (PK)
* string name

SUBCATEGORY
* int subcategory_id (PK)
* int category_id (FK)
* string name

SCORE_SUBCATEGORY
* int score_id (FK)
* int subcategory_id (FK)
* PRIMARY KEY: (score_id, subcategory_id)

CATEGORY
* int category_id (PK)
* string name
* string identifier

SHEET HEADERS
title | composerName | arranger | catalogNum | notes | categoryName | subcategories | status | link | changeTime

insert all composers
insert all categories - get identifier from string part of score catalogNum
swap composer names for composer id
swap category name for category id
insert scores
parse subcategories (split by comma) and group them with the categories
insert all subcategories
group subcategories by score
insert all score_subcategories

score originally has title, arranger, catalogNum, notes, status, link, changeTime
*/

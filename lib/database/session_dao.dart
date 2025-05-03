import 'package:drift/drift.dart';
import 'library_database.dart';

part 'session_dao.g.dart';

@DriftAccessor(tables: [Sessions])
class SessionDao extends DatabaseAccessor<LibraryDatabase>
    with _$SessionDaoMixin {
  SessionDao(super.db);

  Future<UserSessionData?> getCurrentSession() {
    return (select(sessions)
      ..where((s) => s.isActive.equals(true))).getSingleOrNull();
  }

  Future<void> saveAndActivateSession({
    required String userId,
    required String sheetId,
    String? driveFolderId,
    bool isAdmin = false,
  }) async {
    await transaction(() async {
      await (update(
        sessions,
      )).write(const SessionsCompanion(isActive: Value(false)));
      final entry = SessionsCompanion(
        userId: Value(userId),
        sheetId: Value(sheetId),
        driveFolderId: Value(driveFolderId),
        isAdmin: Value(isAdmin),
        isActive: Value(true),
      );
      await into(sessions).insertOnConflictUpdate(entry);
    });
  }

  Future<List<UserSessionData>> getAllSessions() {
    return select(sessions).get();
  }

  Future<void> activateSession(String userId) async {
    await transaction(() async {
      await (update(
        sessions,
      )).write(const SessionsCompanion(isActive: Value(false)));
      await (update(sessions)..where(
        (s) => s.userId.equals(userId),
      )).write(const SessionsCompanion(isActive: Value(true)));
    });
  }

  Future<void> removeSession(String userId) async {
    await (delete(sessions)..where((s) => s.userId.equals(userId))).go();
  }

  Future<void> clearAllSessions() async {
    await delete(sessions).go();
  }
}

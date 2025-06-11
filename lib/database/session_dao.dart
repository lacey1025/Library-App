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

  Future<UserSessionData?> getUserCurrentSession(String userId) {
    return (select(sessions)
      ..where((s) => s.isUserPrimary.equals(true))).getSingleOrNull();
  }

  Future<void> saveAndActivateSession(SessionsCompanion session) async {
    await transaction(() async {
      await (update(
        sessions,
      )).write(const SessionsCompanion(isActive: Value(false)));
      await (update(sessions)..where(
        (tbl) => tbl.userId.equals(session.userId.value),
      )).write(const SessionsCompanion(isUserPrimary: Value(false)));
      await into(sessions).insertOnConflictUpdate(session);
    });
  }

  Future<void> updateHasErrors(int sessionId, bool hasErrors) {
    return (update(sessions)..where(
      (tbl) => tbl.id.equals(sessionId),
    )).write(SessionsCompanion(hasSheetErrors: Value(hasErrors)));
  }

  Future<List<UserSessionData>> getAllSessionsByUser(String userId) {
    return (select(sessions)..where((tbl) => tbl.userId.equals(userId))).get();
  }

  Future<bool> activateSession(String libraryName, String userId) async {
    return transaction(() async {
      final existingSession =
          await (select(sessions)..where(
            (s) => s.libraryName.equals(libraryName) & s.userId.equals(userId),
          )).getSingleOrNull();
      if (existingSession == null) {
        return false;
      }

      await (update(sessions)..where(
        (tbl) => tbl.userId.equals(userId),
      )).write(const SessionsCompanion(isUserPrimary: Value(false)));
      await (update(
        sessions,
      )).write(const SessionsCompanion(isActive: Value(false)));
      await (update(sessions)..where(
        (s) => s.libraryName.equals(libraryName) & s.userId.equals(userId),
      )).write(
        const SessionsCompanion(
          isActive: Value(true),
          isUserPrimary: Value(true),
        ),
      );

      return true;
    });
  }

  Future<void> removeSession(int sessionId) async {
    await (delete(sessions)..where((s) => s.id.equals(sessionId))).go();
  }

  Future<void> clearAllSessions() async {
    await delete(sessions).go();
  }

  Future<void> activateUserPrimary(String userId) async {
    transaction(() async {
      await (update(
        sessions,
      )).write(const SessionsCompanion(isActive: Value(false)));
      await (update(sessions)..where(
        (tbl) => tbl.userId.equals(userId) & tbl.isUserPrimary.equals(true),
      )).write(const SessionsCompanion(isActive: Value(true)));
    });
  }

  Future<void> deactivateAllSessions() async {
    await (update(
      sessions,
    )).write(const SessionsCompanion(isActive: Value(false)));
  }
}

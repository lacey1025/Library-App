import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/database/library_database.dart';
import 'package:library_app/database/session_dao.dart';
import 'package:library_app/providers/database_provider.dart';

final sessionProvider =
    AsyncNotifierProvider<SessionNotifier, UserSessionData?>(
      SessionNotifier.new,
    );

class SessionNotifier extends AsyncNotifier<UserSessionData?> {
  late final SessionDao _sessionDao;

  @override
  Future<UserSessionData?> build() async {
    final db = ref.watch(databaseProvider);
    _sessionDao = SessionDao(db);
    return _sessionDao.getCurrentSession();
  }

  Future<void> setSession(SessionsCompanion session) async {
    await _sessionDao.saveAndActivateSession(session);
    final currentSession = await _sessionDao.getCurrentSession();
    state = AsyncData(currentSession);
  }

  Future<void> activateUserPrimary(String userId) async {
    await _sessionDao.activateUserPrimary(userId);
    final userCurrentSession = await _sessionDao.getUserCurrentSession(userId);
    final currentSession = await _sessionDao.getCurrentSession();
    if (userCurrentSession == currentSession) {
      state = AsyncData(currentSession);
    } else {
      state = AsyncData(null);
    }
  }

  Future<bool> switchSession(String libraryName, String userId) async {
    final success = await _sessionDao.activateSession(libraryName, userId);
    if (success == false) {
      return false;
    }
    final newSession = await _sessionDao.getCurrentSession();
    state = AsyncData(newSession);
    return true;
  }

  Future<UserSessionData?> getUserCurrentSession(String userId) async {
    return await _sessionDao.getUserCurrentSession(userId);
  }

  Future<void> logout() async {
    await _sessionDao.deactivateAllSessions();
    state = AsyncData(null);
  }

  Future<void> updateHasErrors(int sessionId, bool hasErrors) async {
    await _sessionDao.updateHasErrors(sessionId, hasErrors);
    final currentSession = await _sessionDao.getCurrentSession();
    state = AsyncData(currentSession);
  }
}

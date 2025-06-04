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
    final db = await ref.watch(databaseProvider.future);
    _sessionDao = SessionDao(db);
    return _sessionDao.getCurrentSession();
  }

  Future<void> setSession(UserSessionData session) async {
    await _sessionDao.saveAndActivateSession(
      userId: session.userId,
      sheetId: session.sheetId,
      driveFolderId: session.driveFolderId,
      isAdmin: session.isAdmin,
    );
    state = AsyncData(session);
  }

  Future<bool> switchSession(String userId) async {
    final success = await _sessionDao.activateSession(userId);
    if (success == false) {
      return false;
    }
    final newSession = await _sessionDao.getCurrentSession();
    state = AsyncData(newSession);
    return true;
  }

  Future<void> logout() async {
    await _sessionDao.clearAllSessions();
    state = AsyncData(null);
  }
}

import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class DriveHelper {
  static Future<File?> pickPdfFile() async {
    final typeGroup = XTypeGroup(label: 'PDF', extensions: ['pdf']);
    final XFile? file = await openFile(acceptedTypeGroups: [typeGroup]);

    if (file != null) {
      return File(file.path);
    }
    return null;
  }

  static Future<String?> uploadPdfToDrive(
    File file,
    GoogleSignIn account,
    String parentFolderId,
    String folderName,
  ) async {
    final driveApi = await createApiObject(account: account);
    if (driveApi == null) return null;

    String? subfolderId = await getSubfolderId(
      driveApi: driveApi,
      parentFolderId: parentFolderId,
      subfolderName: folderName,
    );

    subfolderId ??= await createNewFolder(
      driveApi: driveApi,
      name: folderName,
      parentFolderId: parentFolderId,
    );
    subfolderId ??= parentFolderId;

    final fileToUpload =
        drive.File()
          ..name = file.path.split('/').last
          ..mimeType = 'application/pdf'
          ..parents = [subfolderId];

    final uploadedFile = await driveApi.files.create(
      fileToUpload,
      uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
      $fields: 'id',
    );

    final updatedFile =
        await driveApi.files.get(uploadedFile.id!, $fields: 'webViewLink')
            as drive.File;

    return updatedFile.webViewLink;
  }

  static Future<String?> createNewFolder({
    required drive.DriveApi driveApi,
    required String name,
    required String parentFolderId,
  }) async {
    final newFolder =
        drive.File()
          ..name = name
          ..mimeType = 'application/vnd.google-apps.folder'
          ..parents = [parentFolderId];

    final createdFolder = await driveApi.files.create(newFolder);
    if (createdFolder.id == null) return null;

    return createdFolder.id!;
  }

  static Future<drive.DriveApi?> createApiObject({
    required GoogleSignIn account,
  }) async {
    final auth = await account.currentUser?.authentication;
    final token = auth?.accessToken;
    if (token == null) return null;

    final client = authenticatedClient(
      http.Client(),
      AccessCredentials(
        AccessToken(
          'Bearer',
          token,
          DateTime.now().toUtc().add(Duration(hours: 1)),
        ),
        null,
        ['https://www.googleapis.com/auth/drive.file'],
      ),
    );

    return drive.DriveApi(client);
  }

  static Future<String?> moveFile({
    required GoogleSignIn account,
    required String parentFolderId,
    required String oldFolderName,
    required String newFolderName,
    required String fileAddress,
  }) async {
    final driveApi = await createApiObject(account: account);
    if (driveApi == null) return null;

    String? oldFolderId = await getSubfolderId(
      driveApi: driveApi,
      parentFolderId: parentFolderId,
      subfolderName: oldFolderName,
    );
    if (oldFolderId == null) return null;

    String? newFolderId = await getSubfolderId(
      driveApi: driveApi,
      parentFolderId: parentFolderId,
      subfolderName: newFolderName,
    );

    newFolderId ??= await createNewFolder(
      driveApi: driveApi,
      name: newFolderName,
      parentFolderId: parentFolderId,
    );
    newFolderId ??= parentFolderId;

    final uri = Uri.parse(fileAddress);
    final match = RegExp(r'/d/([a-zA-Z0-9_-]+)').firstMatch(uri.path);
    final fileId = match?.group(1) ?? '';

    final updatedFile = await driveApi.files.update(
      drive.File(),
      fileId,
      addParents: newFolderId,
      removeParents: oldFolderId,
      $fields: 'id, parents, webViewLink',
    );

    return updatedFile.webViewLink;
  }

  static Future<String?> getSubfolderId({
    required drive.DriveApi driveApi,
    required String parentFolderId,
    required String subfolderName,
  }) async {
    final response = await driveApi.files.list(
      q: """
      '$parentFolderId' in parents and 
      name = '$subfolderName' and 
      mimeType = 'application/vnd.google-apps.folder' and 
      trashed = false
    """,
      spaces: 'drive',
      $fields: 'files(id, name)',
    );

    final folders = response.files;
    if (folders != null && folders.isNotEmpty) {
      return folders.first.id;
    }

    return null;
  }
}

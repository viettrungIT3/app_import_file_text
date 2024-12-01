import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/config.dart';

class FileService {
  Future<void> requestPermission() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      throw Exception('Cần cấp quyền truy cập để chọn file');
    }
  }

  bool isSupportedTextFile(String extension) {
    return UtilsConfig.supportedFileExtensions
        .contains(extension.toLowerCase());
  }

  Future<Map<String, String>> pickAndReadFile() async {
    await requestPermission();

    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result == null) throw Exception('Không có file nào được chọn');

    final file = File(result.files.single.path!);
    final extension = result.files.single.extension ?? '';

    if (!isSupportedTextFile(extension)) {
      throw Exception('File không phải định dạng văn bản được hỗ trợ');
    }

    final contents = await file.readAsString();
    return {'name': result.files.single.name, 'content': contents};
  }
}

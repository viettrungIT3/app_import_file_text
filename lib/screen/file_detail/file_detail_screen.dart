import 'package:flutter/material.dart';
import '../../services/database_service.dart';

class FileDetailScreen extends StatelessWidget {
  final Map<String, dynamic> file;

  const FileDetailScreen({super.key, required this.file});

  Future<void> _deleteFile(
    BuildContext context,
    int id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc muốn xóa file này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await DatabaseService().deleteFile(id);

      // Quay lại trang trước và báo hiệu load lại
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(file['file_name']),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteFile(context, file['id']),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(file['content'] ?? 'Không có nội dung'),
      ),
    );
  }
}

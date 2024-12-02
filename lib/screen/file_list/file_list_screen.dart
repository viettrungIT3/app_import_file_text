import 'package:flutter/material.dart';
import 'package:import_file_text/screen/file_detail/file_detail_screen.dart';
import '../../services/database_service.dart';

class FileListScreen extends StatefulWidget {
  const FileListScreen({super.key});

  @override
  State<FileListScreen> createState() => _FileListScreenState();
}

class _FileListScreenState extends State<FileListScreen> {
  List<Map<String, dynamic>> _files = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final files = await DatabaseService().getFiles();
    setState(() {
      _files = files;
    });
  }

  void _navigateToFileDetail(
      BuildContext context, Map<String, dynamic> file) async {
    final shouldReload = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => FileDetailScreen(file: file),
      ),
    );

    if (shouldReload == true) {
      _loadFiles();
    }
  }

  Future<void> _deleteFile(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc muốn xóa file này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await DatabaseService().deleteFile(id);
      _loadFiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách file'),
      ),
      body: _files.isEmpty
          ? const Center(
              child: Text(
                'Chưa có file nào được lưu.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _files.length,
              itemBuilder: (context, index) {
                final file = _files[index];
                return ListTile(
                  title: Text(file['file_name']),
                  subtitle: Text(
                    'Lưu lúc: ${file['saved_at']}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteFile(file['id']),
                  ),
                  onTap: () => _navigateToFileDetail(context, file),
                );
              },
            ),
    );
  }
}

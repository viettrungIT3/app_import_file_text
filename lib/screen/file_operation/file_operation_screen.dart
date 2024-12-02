import 'package:flutter/material.dart';
import '../../services/file_service.dart';
import '../../services/database_service.dart';
import '../widgets/content_widget.dart';

class FileOperationScreen extends StatefulWidget {
  const FileOperationScreen({super.key});

  @override
  State<FileOperationScreen> createState() => _FileOperationScreenState();
}

class _FileOperationScreenState extends State<FileOperationScreen> {
  final FileService _fileService = FileService();
  final DatabaseService _databaseService = DatabaseService();

  String _fileContent = '';
  String _fileName = '';
  bool _isFilePicked = false;

  Future<void> _pickFile() async {
    try {
      final fileData = await _fileService.pickAndReadFile();
      setState(() {
        _fileContent = fileData['content']!;
        _fileName = fileData['name']!;
        _isFilePicked = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}')),
      );
    }
  }

  Future<void> _saveFile() async {
    final date = DateTime.now();
    final today = '${date.year}-${date.month}-${date.day}';
    print(today);
    final count = await _databaseService.getFileCountForDate(today);
    final generatedFileName = 'Script-${count + 1}_$today';

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận lưu file'),
        content:
            Text('Bạn có muốn lưu file dưới tên: $generatedFileName không?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Lưu')),
        ],
      ),
    );

    if (confirm == true) {
      await _databaseService.insertFile(generatedFileName, _fileContent);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File đã được lưu thành công')),
      );
      setState(() {
        _isFilePicked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Operations'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: _pickFile, child: const Text('Chọn File')),
                ElevatedButton(
                  onPressed: _isFilePicked ? _saveFile : null,
                  child: const Text('Lưu File'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            // ElevatedButton(onPressed: _pickFile, child: const Text('Chọn File')),
            // ElevatedButton(
            //   onPressed: _isFilePicked ? _saveFile : null,
            //   child: const Text('Lưu File'),
            // ),
            if (_fileName.isNotEmpty) Text('Tên File: $_fileName'),
            const Divider(),
            Expanded(child: ContentWidget(content: _fileContent)),
          ],
        ),
      ),
    );
  }
}

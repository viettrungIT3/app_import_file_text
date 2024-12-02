import 'package:flutter/material.dart';
import '../services/file_service.dart';
import '../services/database_service.dart';
import 'widgets/content_widget.dart';

class TextFileScreen extends StatefulWidget {
  const TextFileScreen({super.key});

  @override
  TextFileScreenState createState() => TextFileScreenState();
}

class TextFileScreenState extends State<TextFileScreen> {
  final FileService _fileService = FileService();
  final DatabaseService _databaseService = DatabaseService();

  String _fileContent = '';
  String _fileName = '';
  bool _isLoading = false;

  Future<void> _pickAndSaveFile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final fileData = await _fileService.pickAndReadFile();
      setState(() {
        _fileContent = fileData['content']!;
        _fileName = fileData['name']!;
      });

      // Lưu vào cơ sở dữ liệu
      await _databaseService.insertFile(_fileName, _fileContent);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File đã được lưu vào cơ sở dữ liệu')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showSavedFiles() async {
    final files = await _databaseService.getFiles();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Files đã lưu'),
          content: files.isEmpty
              ? const Text('Chưa có file nào được lưu')
              : SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (_, index) {
                      final file = files[index];
                      return ListTile(
                        title: Text(file['file_name']),
                        subtitle: Text(file['file_content']),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _databaseService.deleteFile(file['id']);
                            Navigator.pop(context);
                            _showSavedFiles();
                          },
                        ),
                      );
                    },
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text File Viewer')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickAndSaveFile,
            child: const Text('Chọn và Lưu File Văn Bản'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _showSavedFiles,
            child: const Text('Hiển thị File đã lưu'),
          ),
          const SizedBox(height: 20),
          if (_fileName.isNotEmpty) Text('Tên File: $_fileName'),
          const Divider(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ContentWidget(content: _fileContent),
          ),
        ],
      ),
    );
  }
}

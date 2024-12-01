import 'package:flutter/material.dart';
import '../services/file_service.dart';
import 'widgets/content_widget.dart';

class TextFileScreen extends StatefulWidget {
  const TextFileScreen({super.key});

  @override
  TextFileScreenState createState() => TextFileScreenState();
}

class TextFileScreenState extends State<TextFileScreen> {
  final FileService _fileService = FileService();
  String _fileContent = '';
  String _fileName = '';
  bool _isLoading = false;

  Future<void> _pickAndReadFile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final fileData = await _fileService.pickAndReadFile();
      setState(() {
        _fileContent = fileData['content']!;
        _fileName = fileData['name']!;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text File Viewer')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickAndReadFile,
            child: const Text('Chọn File Văn Bản'),
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

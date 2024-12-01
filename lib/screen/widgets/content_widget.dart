import 'package:flutter/material.dart';

class ContentWidget extends StatelessWidget {
  final String content;

  const ContentWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Text(
        content.isEmpty ? 'Không có nội dung để hiển thị' : content,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

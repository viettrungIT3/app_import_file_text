import 'package:flutter/material.dart';
import 'package:import_file_text/screen/file_operation/file_operation_screen.dart';
import '../file_list/file_list_screen.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const FileOperationScreen(),
    const FileListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.file_open),
            label: 'File Operations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'File List',
          ),
        ],
      ),
    );
  }
}

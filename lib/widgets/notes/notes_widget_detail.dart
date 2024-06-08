import 'package:flutter/material.dart';
import 'package:todo_app/themes/theme_checker.dart';
import 'package:todo_app/ui_elements/cupertino_app_bar.dart';

class NoteDetailWidget extends StatelessWidget {
  final String noteText;
  const NoteDetailWidget({super.key, required this.noteText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoAppBar(
        padding: 0,
        previousPageTitle:
            noteText.length > 10 ? noteText.substring(0, 10) : noteText,
        largeTitle: '',
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: isDarkTheme(context) ? Colors.black : Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              noteText,
              style: TextStyle(
                  color: isDarkTheme(context) ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

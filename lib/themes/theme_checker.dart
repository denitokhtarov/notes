import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool isDarkTheme(BuildContext context) {
  return MediaQuery.of(context).platformBrightness == Brightness.dark;
}

Color groupListWidgetBackgroundColor(BuildContext context) {
  return isDarkTheme(context) ? CupertinoColors.systemFill : Colors.white;
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'theme_checker.dart';

void setSystemUIOverlayStyle(BuildContext context) {
  RendererBinding.instance.renderViews.toList()[0].automaticSystemUiAdjustment =
      false;
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        systemNavigationBarColor: isDarkTheme(context)
            ? Colors.black
            : CupertinoColors.secondarySystemBackground,
        statusBarColor: isDarkTheme(context)
            ? Colors.black
            : CupertinoColors.secondarySystemBackground,
        statusBarIconBrightness:
            isDarkTheme(context) ? Brightness.light : Brightness.dark),
  );
}

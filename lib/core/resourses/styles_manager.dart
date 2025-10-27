import 'package:enevtly/core/resourses/colors_manager.dart';
import 'package:flutter/cupertino.dart';

abstract final class StylesManager{
  static const TextStyle welcomeTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: ColorsManager.primaryColor,
  );
  static const TextStyle welcomeDesc = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: ColorsManager.blackColor,
  );
}

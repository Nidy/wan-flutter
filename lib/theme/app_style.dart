import 'package:flutter/material.dart';
import 'package:wanflutter/theme/app_color.dart';

const LargeTextSize = 26.0;
const MediumTextSize = 18.0;
const DefaultTextSize = 16.0;
const SmallTextSize = 14.0;
const MiniTextSize = 12.0;

class AppStyle {
  //* 中等文字样式，bold + 18
  static TextStyle mediumBoldTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: MediumTextSize,
    color: AppColor.black,
  );

  //* 默认文字样式，bold + 16
  static TextStyle defaultBoldTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: DefaultTextSize,
    color: AppColor.black,
  );

  //* 小字号文字样式，bold + 14 
  static TextStyle smallBoldTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: SmallTextSize,
    color: AppColor.black,
  );

  //* 小字号文字样式，regular + 14
  static TextStyle smallRegularTextStyle = TextStyle(
    fontSize: SmallTextSize,
    color: AppColor.black,
  );

  //* mini号文字样式，regular + 12
  static TextStyle miniRegularTextStyle = TextStyle(
    fontSize: MiniTextSize,
    color: AppColor.black,
  );
}

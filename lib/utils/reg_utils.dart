import 'package:flutter/services.dart';

class RegUtils {
  ///手机号验证
  static bool isChinaPhoneLegal(String str) {
    return RegExp(
            r"^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\d{8}$")
        .hasMatch(str);
  }

  ///邮箱验证
  static bool isEmail(String str) {
    return RegExp(r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$")
        .hasMatch(str);
  }

  ///验证URL
  static bool isUrl(String value) {
    return RegExp(r"^((https|http|ftp|rtsp|mms)?:\/\/)[^\s]+").hasMatch(value);
  }

  ///验证身份证
  static bool isIdCard(String value) {
    return RegExp(r"\d{17}[\d|x]|\d{15}").hasMatch(value);
  }

  ///验证中文
  static bool isChinese(String value) {
    return RegExp(r"[\u4e00-\u9fa5]").hasMatch(value);
  }

  static bool specialCharValid(String value) {
    return RegExp(r"^[Za-z0-9_]+$").hasMatch(value);
  }
}

//忽略特殊字符
class IgnoreOtherFormatter extends TextInputFormatter {
  static const _regExp = r"^[\u4E00-\u9FA5A-Za-z0-9_]+$";
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (RegExp(_regExp).firstMatch(newValue.text) != null) {
        return newValue;
      }
      return oldValue;
    }
    return newValue;
  }
}

class OnlyInputNumberAndLowWorkFormatter extends TextInputFormatter {
  static const _regExp = r"^[Za-z0-9_]+$";
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (RegExp(_regExp).firstMatch(newValue.text) != null) {
        return newValue;
      }
      return oldValue;
    }
    return newValue;
  }
}

class OnlyInputNumberAndWorkFormatter extends TextInputFormatter {
  static const _regExp = r"^[ZA-ZZa-z0-9_]+$";
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (RegExp(_regExp).firstMatch(newValue.text) != null) {
        return newValue;
      }
      return oldValue;
    }
    return newValue;
  }
}

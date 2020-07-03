import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanflutter/http/entity/base_entity.dart';
import 'package:wanflutter/http/entity/user_entity.dart';
import 'package:wanflutter/http/entity_factory.dart';
import 'package:wanflutter/http/http_error.dart';
import 'package:wanflutter/http/http_manager.dart';
import 'package:wanflutter/utils/constants.dart';

class LoginProvider with ChangeNotifier {
  static const TAG = "login";

  bool _needLogin = true;
  bool get needLogin => _needLogin;

  UserEntity _user;
  UserEntity get user => _user;

  LoginProvider() {
    _initData();
  }

  _initData() async {
    await SharedPreferences.getInstance().then((sp) {
      _needLogin = sp.getBool(Constants.NEED_LOGIN) ?? true;
      _user = EntityFactory.generateObj<UserEntity>(
          jsonDecode(sp.getString(Constants.USER_PROFILE)));
    });
  }

  Future doLogin({@required String username, @required String pwd}) async {
    var params = Map<String, dynamic>();
    params['username'] = username;
    params['password'] = pwd;
    await HttpManager()
        .postAsync(
      url: '/user/login',
      params: params,
      tag: TAG,
      jsonParse: (json) {
        Fluttertoast.showToast(msg: '登录成功');
        _user = EntityFactory.generateObj<UserEntity>(json);
        SharedPreferences.getInstance().then((sp) {
          sp.setBool(Constants.NEED_LOGIN, false);
          sp.setString(Constants.USER_PROFILE, jsonEncode(_user.toJson()));
          notifyListeners();
        });
      },
    )
        .catchError((error) {
      if (error is HttpError) {
        Fluttertoast.showToast(msg: error.message);
      }
    });
  }
}

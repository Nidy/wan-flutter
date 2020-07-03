import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanflutter/http/entity/article_entity.dart';
import 'package:wanflutter/http/entity/page_entity.dart';
import 'package:wanflutter/http/entity/user_entity.dart';
import 'package:wanflutter/http/entity_factory.dart';
import 'package:wanflutter/http/http_error.dart';
import 'package:wanflutter/http/http_manager.dart';
import 'package:wanflutter/utils/constants.dart';
import 'package:wanflutter/utils/log_utils.dart';

class LoginProvider with ChangeNotifier {
  static const TAG = "login";

  bool _needLogin = true;
  bool get needLogin => _needLogin;

  UserEntity _user;
  UserEntity get user => _user;

  var pageNum = 0;

  var _refreshController = RefreshController(initialRefresh: false);
  RefreshController get refreshController => _refreshController;
  var _articleList = List<ArticleEntity>();
  List<ArticleEntity> get articleList => _articleList;

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

  // 获取收藏的文章
  Future getFavArticalList({bool isRefresh = true}) async {
    if (isRefresh) {
      pageNum = 0;
    } else {
      pageNum++;
    }
    await HttpManager()
        .getAsync(
            url: _getActialListApi(),
            tag: TAG,
            jsonParse: (json) {
              if (json != null) {
                PageEntity<ArticleEntity> en =
                    PageEntity<ArticleEntity>.fromJson(json);
                if (isRefresh) {
                  _articleList.clear();
                }
                _articleList.addAll(en.datas);
                if (pageNum == en.pageCount) {
                  _refreshController.resetNoData();
                }
                notifyListeners();
              }
            })
        .catchError((e) {
      LogUtil.v(e.toString());
    }).whenComplete(() {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    });
  }

  Future deleteFavActical(int id) async {
    return await HttpManager()
        .postAsync(url: _deleteFavActicalApi(id), needSession: true, tag: TAG);
  }

  String _getActialListApi() {
    return "/article/list/$pageNum/json";
  }

  String _deleteFavActicalApi(int id) {
    return "/lg/uncollect_originId/$id/json";
  }
}

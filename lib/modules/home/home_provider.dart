import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanflutter/http/entity/article_entity.dart';
import 'package:wanflutter/http/entity/page_entity.dart';
import 'package:wanflutter/http/http_manager.dart';
import 'package:wanflutter/utils/log_utils.dart';

class HomeProvider with ChangeNotifier {
  static const TAG = "home";
  var pageNum = 0;

  var _refreshController = RefreshController(initialRefresh: true);
  RefreshController get refreshController => _refreshController;
  var _articleList = new List<ArticleEntity>();
  List<ArticleEntity> get articleList => _articleList;

  Future getArticalList({bool isRefresh = true}) async {
    if (isRefresh) {
      pageNum = 0;
    } else {
      pageNum++;
    }
    await HttpManager()
        .getAsync(
            url: _getApi(),
            tag: TAG,
            jsonParse: (json) {
              if (json != null) {
                PageEntity<ArticleEntity> en =
                    PageEntity<ArticleEntity>.fromJson(json);
                if (isRefresh) {
                  _articleList.clear();
                }
                _articleList.addAll(en.datas);
                if (pageNum == 3) {
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

  String _getApi() {
    return "article/list/$pageNum/json";
  }
}

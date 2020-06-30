import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanflutter/http/api.dart';
import 'package:wanflutter/http/entity/article_entity.dart';
import 'package:wanflutter/http/entity/category_entity.dart';
import 'package:wanflutter/http/entity/page_entity.dart';
import 'package:wanflutter/http/entity_factory.dart';
import 'package:wanflutter/http/http_manager.dart';
import 'package:wanflutter/modules/system/provider/system_model.dart';
import 'package:wanflutter/utils/log_utils.dart';

class KnowledgeStsytemProvider with ChangeNotifier {
  static const String TAG = "system";
  int pageNum = 1; //页码：拼接在链接中，从1开始。;

  var _refreshController = RefreshController(initialRefresh: false);
  RefreshController get refreshController => _refreshController;

  var _systemModel = SystemModel();
  SystemModel get systemModel => _systemModel;

  Future<List<CategoryEntity>> getCategory() async {
    return await HttpManager().getAsync(
        url: Api.TREE_CATEGORY,
        tag: TAG,
        jsonParse: (json) {
          List<CategoryEntity> list = List<CategoryEntity>();
          if (json != null) {
            list = EntityFactory.generateListObj<CategoryEntity>(json);
            list.forEach((element) {
              List<dynamic> level2Category = element.children;
              element.children = level2Category
                  .map(
                      (json) => EntityFactory.generateObj<CategoryEntity>(json))
                  .toList();
            });
            _systemModel =
                new SystemModel(categorys: list, datas: List<ArticleEntity>());
          }
          return list;
        });
  }

  ///*根据类别id获取项目列表
  Future<List<ArticleEntity>> loadArticleList(
      CategoryEntity category, bool isRefresh) async {
    if (isRefresh) {
      pageNum = 0;
    } else {
      pageNum++;
    }
    return await HttpManager()
        .getAsync<List<ArticleEntity>>(
            url: _getListApiUrl(category.id),
            tag: TAG,
            jsonParse: (json) {
              if (json != null) {
                if (isRefresh) {
                  category.children?.clear();
                }
                PageEntity<ArticleEntity> pe =
                    PageEntity<ArticleEntity>.fromJson(json);
                _systemModel.datas = pe.datas;
              }
              return _systemModel.datas;
            })
        .catchError((e) {
      LogUtil.v(e.toString());
    }).whenComplete(() {
      if (isRefresh) {
        _refreshController.refreshCompleted();
      } else {
        _refreshController.loadComplete();
      }
      notifyListeners();
    });
  }

  String _getListApiUrl(int cid) {
    return "/article/list/$pageNum/json?cid=$cid";
  }
}

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanflutter/http/api.dart';
import 'package:wanflutter/http/entity/article_entity.dart';
import 'package:wanflutter/http/entity/category_entity.dart';
import 'package:wanflutter/http/entity/page_entity.dart';
import 'package:wanflutter/http/entity_factory.dart';
import 'package:wanflutter/http/http_manager.dart';
import 'package:wanflutter/modules/wechat/provider/accounts_model.dart';
import 'package:wanflutter/utils/log_utils.dart';

class AccountsProvider with ChangeNotifier {
  static const String TAG = "wechat";
  int pageNum = 1; //页码：拼接在链接中，从1开始。;
  
  var _refreshController = RefreshController(initialRefresh: false);
  RefreshController get refreshController => _refreshController;

  var _accountsModelList = List<AccountsModel>();
  List<AccountsModel> get accountsModelList => _accountsModelList;

  ///*获取公众号
  Future<List<AccountsModel>> getCategory() async {
    return await HttpManager().getAsync<List<AccountsModel>>(
        url: Api.WECHAT_CATEGORY,
        tag: TAG,
        jsonParse: (json) {
          if (json != null) {
            List<CategoryEntity> _pcList =
            EntityFactory.generateListObj<CategoryEntity>(json);
            _pcList.forEach((element) {
              _accountsModelList.add(AccountsModel(category: element, datas: List<ArticleEntity>()));
            });
          }
          return _accountsModelList;
        });
  }

  ///*根据类别id获取项目列表
  Future<List<ArticleEntity>> loadArticleList(AccountsModel projectModel, bool isRefresh) async {
    if (isRefresh) {
      pageNum = 1;
    } else {
      pageNum++;
    }
    return await HttpManager()
        .getAsync<List<ArticleEntity>>(
            url: _getListApiUrl(projectModel.category.id),
            tag: TAG,
            jsonParse: (json) {
              if (json != null) {
                if (isRefresh) {
                  projectModel.datas?.clear();
                }
                PageEntity<ArticleEntity> pe =
                    PageEntity<ArticleEntity>.fromJson(json);
                projectModel.datas.addAll(pe.datas);
              }
              return projectModel.datas;
            })
        .catchError((e) {
      LogUtil.v(e.toString());
    }).whenComplete(() {
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
      notifyListeners();
    });
  }

  String _getListApiUrl(int cid) {
    return "/wxarticle/list/$cid/$pageNum/json";
  }
}
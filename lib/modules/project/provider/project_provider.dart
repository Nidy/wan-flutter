import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanflutter/http/api.dart';
import 'package:wanflutter/http/entity/page_entity.dart';
import 'package:wanflutter/http/entity/project_category_entity.dart';
import 'package:wanflutter/http/entity/project_entity.dart';
import 'package:wanflutter/http/entity_factory.dart';
import 'package:wanflutter/http/http_manager.dart';
import 'package:wanflutter/utils/log_utils.dart';

class ProjectProvider with ChangeNotifier {
  static const String TAG = "project";
  
  var _refreshController = RefreshController(initialRefresh: false);
  RefreshController get refreshController => _refreshController;

  int pageNum = 1; //页码：拼接在链接中，从1开始。
  var _pcList = List<ProjectCategoryEntity>();
  List<ProjectCategoryEntity> get pcList => _pcList;
  var _projectList = List<ProjectEntity>();
  List<ProjectEntity> get projectList => _projectList;

  ProjectProvider() {
    getCategory();
  }

  ///*获取项目类别
  Future getCategory() async {
    _pcList = await HttpManager()
        .getAsync<List<ProjectCategoryEntity>>(
            url: Api.PROJECT_CATEGORY,
            tag: TAG,
            jsonParse: (json) {
              if (json == null) {
                return _pcList;
              }
              return EntityFactory.generateListObj<ProjectCategoryEntity>(json);
            })
        .catchError((e) => LogUtil.v(e.toString()));
    notifyListeners();
  }

  ///*根据类别id获取项目列表
  Future loadProjectList(int cid, bool isRefresh) async {
    if (isRefresh) {
      pageNum = 1;
    } else {
      pageNum++;
    }
    await HttpManager()
        .getAsync(
            url: _getListApiUrl(cid),
            tag: TAG,
            jsonParse: (json) {
              if (json != null) {
                if (isRefresh) {
                  _projectList.clear();
                }
                PageEntity<ProjectEntity> pe =
                    PageEntity<ProjectEntity>.fromJson(json);
                _projectList.addAll(pe.datas);
              }
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
    return "/project/list/$pageNum/json?cid=$cid";
  }
}

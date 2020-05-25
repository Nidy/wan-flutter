import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanflutter/http/api.dart';
import 'package:wanflutter/http/entity/page_entity.dart';
import 'package:wanflutter/http/entity/project_category_entity.dart';
import 'package:wanflutter/http/entity/project_entity.dart';
import 'package:wanflutter/http/entity_factory.dart';
import 'package:wanflutter/http/http_manager.dart';
import 'package:wanflutter/modules/project/provider/project_model.dart';
import 'package:wanflutter/utils/log_utils.dart';

class ProjectProvider with ChangeNotifier {
  static const String TAG = "project";

  var _refreshController = RefreshController(initialRefresh: false);
  RefreshController get refreshController => _refreshController;

  int pageNum = 1; //页码：拼接在链接中，从1开始。
  // var _pcList = List<ProjectCategoryEntity>();
  // List<ProjectCategoryEntity> get pcList => _pcList;
  // var _projectList = List<ProjectEntity>();
  // List<ProjectEntity> get projectList => _projectList;

  var _projectModelList = List<ProjectModel>();
  List<ProjectModel> get projectModelList => _projectModelList;

  ///*获取项目类别
  Future<List<ProjectModel>> getCategory() async {
    return await HttpManager().getAsync<List<ProjectModel>>(
        url: Api.PROJECT_CATEGORY,
        tag: TAG,
        jsonParse: (json) {
          if (json != null) {
            List<ProjectCategoryEntity> _pcList =
                EntityFactory.generateListObj<ProjectCategoryEntity>(json);
            _pcList.forEach((element) {
              _projectModelList.add(ProjectModel(categoryEntity: element, datas: List<ProjectEntity>()));
            });
          }
          return _projectModelList;
        });
  }

  ///*根据类别id获取项目列表
  Future<List<ProjectEntity>> loadProjectList(ProjectModel projectModel, bool isRefresh) async {
    if (isRefresh) {
      pageNum = 1;
    } else {
      pageNum++;
    }
    return await HttpManager()
        .getAsync<List<ProjectEntity>>(
            url: _getListApiUrl(projectModel.categoryEntity.id),
            tag: TAG,
            jsonParse: (json) {
              if (json != null) {
                if (isRefresh) {
                  projectModel.datas?.clear();
                }
                PageEntity<ProjectEntity> pe =
                    PageEntity<ProjectEntity>.fromJson(json);
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
    return "/project/list/$pageNum/json?cid=$cid";
  }
}

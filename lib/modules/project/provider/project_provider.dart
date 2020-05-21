import 'package:flutter/material.dart';
import 'package:wanflutter/http/api.dart';
import 'package:wanflutter/http/entity/project_category_entity.dart';
import 'package:wanflutter/http/entity_factory.dart';
import 'package:wanflutter/http/http_manager.dart';
import 'package:wanflutter/utils/log_utils.dart';

class ProjectProvider with ChangeNotifier {
  static const String TAG = "project";
  TabController _tabController;
  TabController get tabController => _tabController;

  var _pcList = List<ProjectCategoryEntity>();
  List<ProjectCategoryEntity> get pcList => _pcList;

  Future getCategory() async {
    _pcList = await HttpManager().getAsync<List<ProjectCategoryEntity>>(
        url: Api.PROJECT_CATEGORY,
        tag: TAG,
        jsonParse: (json) {
          if (json == null) {
            return _pcList;
          }
          return EntityFactory.generateListObj<ProjectCategoryEntity>(json);
        }).catchError((e) => LogUtil.v(e.toString()));
    notifyListeners();
  }
}

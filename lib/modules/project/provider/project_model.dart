import 'package:wanflutter/http/entity/project_category_entity.dart';
import 'package:wanflutter/http/entity/project_entity.dart';

class ProjectModel {
  ProjectCategoryEntity categoryEntity;
  List<ProjectEntity> datas;

  ProjectModel({this.categoryEntity, this.datas});
}
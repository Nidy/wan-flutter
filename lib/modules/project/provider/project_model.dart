import 'package:wanflutter/http/entity/category_entity.dart';
import 'package:wanflutter/http/entity/project_entity.dart';

class ProjectModel {
  CategoryEntity categoryEntity;
  List<ProjectEntity> datas;

  ProjectModel({this.categoryEntity, this.datas});
}
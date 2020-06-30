import 'package:wanflutter/http/entity/article_entity.dart';
import 'package:wanflutter/http/entity/category_entity.dart';

class SystemModel {
  List<CategoryEntity> categorys;
  List<ArticleEntity> datas;

  SystemModel({this.categorys, this.datas});
}
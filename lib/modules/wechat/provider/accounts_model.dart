import 'package:wanflutter/http/entity/article_entity.dart';
import 'package:wanflutter/http/entity/category_entity.dart';

class AccountsModel {
  CategoryEntity category;
  List<ArticleEntity> datas;

  AccountsModel({this.category, this.datas});
}
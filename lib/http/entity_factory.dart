import 'package:wanflutter/generated/json/base/json_convert_content.dart';
import 'package:wanflutter/http/entity/article_entity.dart';
import 'package:wanflutter/http/entity/banner_entity.dart';
import 'package:wanflutter/http/entity/category_entity.dart';
import 'package:wanflutter/http/entity/project_entity.dart';

class EntityFactory {
  static T generateObj<T>(json) {
    if (json == null) {
      return null;
    } else if (T.toString() == 'ArticleEntity') {
      return JsonConvert.fromJsonAsT<ArticleEntity>(json) as T;
    } else if (T.toString() == 'BannerEntity') {
      return JsonConvert.fromJsonAsT<BannerEntity>(json) as T;
    } else if (T.toString() == 'CategoryEntity') {
      return JsonConvert.fromJsonAsT<CategoryEntity>(json) as T;
    } else if (T.toString() == 'ProjectEntity') {
      return JsonConvert.fromJsonAsT<ProjectEntity>(json) as T;
    } 
    else {
      return json as T;
    }
  }

  static List<T> generateListObj<T>(json) {
    if (json == null) {
      return null;
    }
    return (json as List).map((e) => generateObj<T>(e)).toList();
  }
}

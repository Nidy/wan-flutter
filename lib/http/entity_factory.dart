import 'package:wanflutter/generated/json/base/json_convert_content.dart';
import 'package:wanflutter/http/entity/article_entity.dart';

class EntityFactory {
  static T generateObj<T>(json) {
    if (json == null) {
      return null;
    } else if (T.toString() == 'ArticleEntity') {
      return JsonConvert.fromJsonAsT<ArticleEntity>(json) as T;
    }  else {
      return json as T;
    }
  }
}

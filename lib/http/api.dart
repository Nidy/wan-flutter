import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wanflutter/utils/log_utils.dart';

class Api {
  static const String BASE_URL = "https://www.wanandroid.com";

  ///*首页文章
  static const String ARTICLE = "/article/list/0/json";

  ///*首页banner
  static const String BANNER = "/banner/json";

  ///*项目类别
  static const String PROJECT_CATEGORY = "/project/tree/json";

  ///*公众号
  static const String WECHAT_CATEGORY = "/wxarticle/chapters/json";

  ///*知识体系分类
  static const String TREE_CATEGORY = "/tree/json";

  static PersistCookieJar _cookieJar;
  static Future<PersistCookieJar> get cookieJar async {
    if (_cookieJar == null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      LogUtil.v('获取的文件系统目录 appDocPath： ' + appDocPath);
      _cookieJar = new PersistCookieJar(dir: appDocPath);
    }
    return _cookieJar;
  }
}

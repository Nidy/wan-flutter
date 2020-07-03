import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MineProvider with ChangeNotifier {
  static const String TAG = "mine";

  var _refreshController = RefreshController(initialRefresh: false);
  RefreshController get refreshController => _refreshController;

  int pageNum = 0;

  String _getListApiUrl() {
    return "/lg/collect/list/$pageNum/json";
  }

}
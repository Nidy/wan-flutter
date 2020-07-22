import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanflutter/http/entity/article_entity.dart';
import 'package:wanflutter/http/entity/page_entity.dart';
import 'package:wanflutter/http/http_manager.dart';
import 'package:wanflutter/router/bootom2top_router.dart';
import 'package:wanflutter/theme/app_style.dart';
import 'package:wanflutter/widget/webview/common_webview.dart';

class SearchArticalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchArticalPageState();
}

class _SearchArticalPageState extends State<SearchArticalPage> {
  FocusNode _focusNode = FocusNode();
  var _searchController = TextEditingController();
  var _refreshController = RefreshController();

  var _articleList = List<ArticleEntity>();
  int _currPageNum = -1;

  Future loadArticalList(String keyWord) async {
    if (StringUtils.isNullOrEmpty(keyWord)) {
      Fluttertoast.showToast(msg: '请输入要查询的关键字');
      return null;
    }
    _currPageNum++;
    var params = Map<String, dynamic>();
    params['k'] = _searchController.text;
    String api = "/article/query/$_currPageNum/json";
    await HttpManager().postAsync(url: api, params: params, tag: 'search').then((json) {
      var en = PageEntity<ArticleEntity>.fromJson(json);
      if (_currPageNum == en.pageCount - 1) {
        _refreshController.resetNoData();
      }
      setState(() {
        _articleList.addAll(en.datas);
      });
    }).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchFiled(),
      ),
      body: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: () async {},
        onLoading: () async {
          await loadArticalList(_searchController.text);
        },
        child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, i) => _itemArticle(context, _articleList[i]),
            itemCount: _articleList.length),
      ),
    );
  }

  Widget _buildSearchFiled() {
    return Container(
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              maxLines: 1,
              textAlign: TextAlign.left,
              autofocus: false,
              style: TextStyle(
                  textBaseline: TextBaseline.alphabetic,
                  fontSize: 14,
                  color: Colors.black),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.search)),
                hintText: '输入文章或作者名称',
                counterText: '',
                contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                isDense: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          SizedBox(
            width: 72,
            child: FlatButton(
              color: Colors.white,
              child: Text(
                "确定",
                style: TextStyle(fontSize: 14),
              ),
              textColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              onPressed: () async {
                _focusNode.unfocus();
                loadArticalList(_searchController.text);
              },
            ),
          ),
        ],
      ),
    );
  }
}

_itemArticle(BuildContext ctx, ArticleEntity ae) {
  return GestureDetector(
    onTap: () => Navigator.push(
        ctx,
        Bottom2TopRouter(
            child: CommonWebview(
          title: ae.title,
          url: ae.link,
          id: ae.id,
          collect: ae.collect,
        ))),
    child: SizedBox(
      child: Card(
        margin: EdgeInsets.all(8),
        elevation: 15.0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                ae.title,
                textDirection: TextDirection.ltr,
                style: AppStyle.defaultBoldTextStyle,
              ),
              SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                      StringUtils.isNotNullOrEmpty(ae.author)
                          ? "@${ae.author}"
                          : "@${ae.shareUser}",
                      style:
                          TextStyle(color: (Colors.blueGrey), fontSize: 14.0)),
                  SizedBox(width: 8),
                  Icon(Icons.access_time, color: Colors.blueGrey, size: 14),
                  SizedBox(width: 4),
                  Text(
                    ae.niceShareDate,
                    style: TextStyle(color: (Colors.blueGrey), fontSize: 14.0),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.turned_in, color: Colors.lightGreen, size: 14),
                  SizedBox(width: 4),
                  Text("${ae.superChapterName}/${ae.chapterName}",
                      style:
                          TextStyle(color: (Colors.blueGrey), fontSize: 14.0)),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

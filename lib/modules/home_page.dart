import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanflutter/http/entity/article_entity.dart';
import 'package:wanflutter/modules/home/home_provider.dart';
import 'package:wanflutter/router/bootom2top_router.dart';
import 'package:wanflutter/widget/common_webview.dart';

class HomePage extends StatelessWidget {
  final _hp = HomeProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeProvider>(
      create: (_) => _hp,
      child: Consumer(
        builder: (context, HomeProvider hp, _) => Scaffold(
          appBar: AppBar(
            title: Text('文章'),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () => EasyLoading.show(status: 'loading')),
            ],
          ),
          body: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            controller: hp.refreshController,
            onRefresh: () async {
              await hp.getArticalList();
            },
            onLoading: () async {
              await hp.getArticalList(isRefresh: false);
            },
            child: ListView.builder(
              itemBuilder: (c, i) =>
                  _itemArticle(context, hp.articleList[i]),
              itemCount: hp.articleList.length,
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemArticle(BuildContext ctx, ArticleEntity ae) {
    return GestureDetector(
      onTap: () => Navigator.push(
          ctx,
          Bottom2TopRouter(
              child: CommonWebview(
                title: ae.title,
                url: ae.link,
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
              // mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  ae.title,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      color: (Colors.black),
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            color: (Colors.blueGrey), fontSize: 14.0)),
                    SizedBox(width: 8),
                    Icon(Icons.access_time, color: Colors.blueGrey, size: 14),
                    SizedBox(width: 4),
                    Text(
                      ae.niceShareDate,
                      style:
                          TextStyle(color: (Colors.blueGrey), fontSize: 14.0),
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
                        style: TextStyle(
                            color: (Colors.blueGrey), fontSize: 14.0)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

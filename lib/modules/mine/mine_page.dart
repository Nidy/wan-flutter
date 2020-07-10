import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanflutter/http/entity/article_entity.dart';
import 'package:wanflutter/modules/login/login_page.dart';
import 'package:wanflutter/modules/login/provider/login_provider.dart';
import 'package:wanflutter/router/bootom2top_router.dart';
import 'package:wanflutter/theme/app_style.dart';
import 'package:wanflutter/widget/empty_holder.dart';
import 'package:wanflutter/widget/webview/common_webview.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  LoginProvider _lp;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<LoginProvider>(builder: (context, LoginProvider lp, _) {
      if (_lp == null) {
        _lp = lp;
      }
      if (!lp.needLogin && lp.canLoadFav) {
        lp.getFavArticalList(isRefresh: true);
      }
      return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 300,
                floating: false,
                pinned: true,
                snap: false,
                flexibleSpace: FlexibleSpaceBar(
                  title: GestureDetector(
                    child: Text(
                      lp.needLogin ?? true ? '去登录' : lp.user?.nickname,
                      style: AppStyle.mediumRegularTextStyleWhite,
                    ),
                    onTap: () => lp.needLogin ?? true
                        ? Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                            return LoginPage();
                          }))
                        : showLoginOutDialog(context),
                  ),
                  centerTitle: true,
                  background: Image.asset(
                    'assets/images/bg_mine_title.png',
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ];
          },
          body: lp.needLogin ?? true
              ? Center(
                  child: EmptyHolder(
                  msg: '登录后可查看收藏的文章',
                ))
              : SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  controller: lp.refreshController,
                  onRefresh: () async {
                    await lp.getFavArticalList();
                  },
                  onLoading: () async {
                    await lp.getFavArticalList(isRefresh: false);
                  },
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, i) =>
                          _itemArticle(context, lp.articleList[i]),
                      itemCount: lp.articleList.length),
                ),
        ),
      );
    });
  }

  Widget _itemArticle(BuildContext ctx, ArticleEntity ae) {
    return Dismissible(
      key: Key('key${ae.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        child: ListTile(
          trailing: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          var isDismiss = await _confirmDelete(context);
          if (isDismiss) {
            _lp.removeMarkActical(id: ae.originId).then(
                  (value) => setState(() {
                    _lp.articleList.remove(ae);
                  }),
                );
          }
          return isDismiss;
        }
        return false;
      },
      child: GestureDetector(
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
                      Icon(Icons.access_time, color: Colors.blueGrey, size: 14),
                      SizedBox(width: 4),
                      Text(
                        ae.niceDate,
                        style:
                            TextStyle(color: (Colors.blueGrey), fontSize: 14.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('确认删除？', style: AppStyle.defaultBoldTextStyle),
            actions: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: () => Navigator.of(context).pop(false), //关闭对话框
              ),
              FlatButton(
                child: Text("删除"),
                onPressed: () {
                  Navigator.of(context).pop(true); //关闭对话框
                },
              ),
            ],
          );
        });
  }

  Future<bool> showLoginOutDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text("确定退出登录吗?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("取消"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  child: Text("退出"),
                  onPressed: () {
                    // 执行删除操作
                    _lp.doLoginout();
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ));
  }

  @override
  bool get wantKeepAlive => true;
}

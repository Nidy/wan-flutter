import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanflutter/generated/l10n.dart';
import 'package:wanflutter/http/entity/article_entity.dart';
import 'package:wanflutter/modules/home/provider/home_provider.dart';
import 'package:wanflutter/router/bootom2top_router.dart';
import 'package:wanflutter/theme/app_style.dart';
import 'package:wanflutter/widget/banner_widget.dart';
import 'package:wanflutter/widget/webview/common_webview.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  var _hp = HomeProvider();

  @override
  initState() {
    super.initState();
    _hp.loadBanner();
    _hp.getArticalList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<HomeProvider>(
      create: (_) => _hp,
      child: Consumer(
        builder: (context, HomeProvider hp, _) => Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).tabHome),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: null)
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
            child: CustomScrollView(slivers: <Widget>[
              _appBar(context, hp),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (c, i) => _itemArticle(context, hp.articleList[i]),
                  childCount: hp.articleList.length,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context, HomeProvider hp) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      pinned: false,
      floating: false,
      forceElevated: true,
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin, //视差效果,
        background: hp.bannerCached
            ? CustomBanner(
                hp.bannerImages,
                height: 200,
                onTap: (i) => Navigator.push(
                    context,
                    Bottom2TopRouter(
                        child: CommonWebview(
                      title: hp.banners[i].title,
                      url: hp.banners[i].url,
                      id: hp.banners[i].id,
                    ))),
              )
            : Image.asset(
                "assets/images/home_banner.png",
                fit: BoxFit.cover,
                height: 200,
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
            id: ae.id,
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

  @override
  bool get wantKeepAlive => true;
}

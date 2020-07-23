import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanflutter/http/entity/category_entity.dart';
import 'package:wanflutter/modules/system/knowledge_article_page.dart';
import 'package:wanflutter/modules/system/provider/system_provider.dart';
import 'package:wanflutter/theme/app_style.dart';

class KnowledgeListWidget extends StatefulWidget {
  final CategoryEntity categorys;
  final KnowledgeStsytemProvider provider;

  KnowledgeListWidget({@required this.categorys, @required this.provider});

  @override
  State<StatefulWidget> createState() => _KnowledgeListWidget();
}

class _KnowledgeListWidget extends State<KnowledgeListWidget>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.categorys.children.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer(builder: (context, KnowledgeStsytemProvider provider, _) {
      return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverToBoxAdapter(
              child: Container(
                color: Theme.of(context).primaryColor,
                width: double.infinity,
                child: TabBar(
                  tabs: _buildTabBar(widget.categorys.children),
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  indicatorPadding: EdgeInsets.only(bottom: 2),
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: AppStyle.smallRegularTextWhite,
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: _buildBodyPage(widget.categorys.children),
        ),
      );
    });
  }

  List<Widget> _buildTabBar(List<CategoryEntity> categorys) {
    var _tabs = List<Widget>();
    if (categorys == null || categorys.isEmpty) {
      return _tabs;
    }
    categorys.forEach((element) {
      _tabs.add(Tab(
          child: Text(
        element.name,
        style: AppStyle.smallRegularTextWhite,
      )));
    });
    return _tabs;
  }

  List<Widget> _buildBodyPage(List<CategoryEntity> categorys) {
    var _pages = List<Widget>();
    if (categorys.isNotEmpty) {
      categorys.forEach((element) {
        _pages.add(KnowledgeArticlePage(element, widget.provider));
      });
    }
    return _pages;
  }

  @override
  bool get wantKeepAlive => true;
}

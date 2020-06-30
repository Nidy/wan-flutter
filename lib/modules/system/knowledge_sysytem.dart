import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanflutter/generated/l10n.dart';
import 'package:wanflutter/http/entity/category_entity.dart';
import 'package:wanflutter/modules/system/knowledge_lsit_widget.dart';
import 'package:wanflutter/modules/system/provider/system_provider.dart';
import 'package:wanflutter/theme/app_style.dart';
import 'package:wanflutter/widget/empty_holder.dart';

class KnowledgeSystemPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KnowledgeSystemPage();
}

class _KnowledgeSystemPage extends State<KnowledgeSystemPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  var _provider = KnowledgeStsytemProvider();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _provider.getCategory().then((value) {
      setState(() {
        _tabController = TabController(length: value.length, vsync: this);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<KnowledgeStsytemProvider>(
      create: (_) => _provider,
      child: Consumer(builder: (context, KnowledgeStsytemProvider provider, _) {
        if (provider.systemModel.categorys == null || provider.systemModel.categorys.isEmpty) {
          return Scaffold(
              appBar: AppBar(
                title: Text(S.of(context).tabProject),
                centerTitle: true,
              ),
              body: EmptyHolder(msg: 'Loading...'));
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              S.of(context).tabProject,
            ),
            centerTitle: true,
            bottom: TabBar(
              tabs: _buildTabBar(provider.systemModel.categorys),
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
          body: TabBarView(
            controller: _tabController,
            children: _buildBodyPage(provider.systemModel.categorys),
          ),
        );
      }),
    );
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
    if (categorys == null || categorys.isEmpty) {
      return _pages;
    }
    categorys.forEach((element) {
      _pages.add(KnowledgeListWidget(categorys: element, provider: _provider,));
    });
    return _pages;
  }

  @override
  bool get wantKeepAlive => true;
}

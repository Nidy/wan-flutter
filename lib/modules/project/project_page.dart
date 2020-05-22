import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanflutter/generated/l10n.dart';
import 'package:wanflutter/modules/project/project_category_widget.dart';
import 'package:wanflutter/modules/project/provider/project_provider.dart';
import 'package:wanflutter/theme/app_style.dart';

class ProjectPage extends StatefulWidget {
  factory ProjectPage() => _getInstance();
  static ProjectPage _instance;
  ProjectPage._init();

  static ProjectPage get instance => _getInstance();
  static ProjectPage _getInstance() {
    if (_instance == null) {
      _instance = new ProjectPage._init();
    }
    return _instance;
  }

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with TickerProviderStateMixin {
  TabController tabController;

  List<Widget> _buildTabs(ProjectProvider pp) {
    var _tabs = List<Widget>();
    if (pp.pcList.isEmpty) {
      return _tabs;
    }
    pp.pcList.forEach((element) {
      _tabs.add(Tab(
          child: Text(
        element.name,
        style: AppStyle.smallRegularTextStyle,
      )));
    });
    return _tabs;
  }

  List<Widget> _buildBodyPage(ProjectProvider pp) {
    var _pages = List<Widget>();
    if (pp.pcList.isEmpty) {
      return _pages;
    }
    pp.pcList.forEach((element) {
      _pages.add(ProjectCategoryWidget(element));
    });
    return _pages;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ProjectProvider pp, _) {
      if (tabController == null) {
        tabController = TabController(length: pp.pcList.length, vsync: this);
        pp.loadProjectList(pp.pcList[0].id, true);
        tabController.addListener(() {
          pp.loadProjectList(pp.pcList[tabController.index].id, true);
        });
      }
      return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text(S.of(context).tabProject),
                centerTitle: true,
                floating: false,
                pinned: true,
                forceElevated: true,
                bottom: TabBar(
                  tabs: _buildTabs(pp),
                  controller: tabController,
                  isScrollable: true,
                  indicatorPadding: EdgeInsets.only(bottom: 2),
                  indicatorSize: TabBarIndicatorSize.label,
                ),
              )
            ];
          },
          body: TabBarView(
            controller: tabController,
            children: _buildBodyPage(pp),
          ),
        ),
      );
    });
  }
}

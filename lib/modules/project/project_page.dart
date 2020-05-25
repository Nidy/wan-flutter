import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanflutter/generated/l10n.dart';
import 'package:wanflutter/modules/project/project_category_widget.dart';
import 'package:wanflutter/modules/project/provider/project_provider.dart';
import 'package:wanflutter/theme/app_style.dart';
import 'package:wanflutter/widget/empty_holder.dart';

class ProjectPage extends StatefulWidget {
  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController tabController;
  var _pp = ProjectProvider();
  int _currIndexStack = 0;

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
      _pages.add(ProjectCategoryWidget(element, pp));
    });
    return _pages;
  }

  @override
  void initState() {
    super.initState();
    _pp.getCategory().then((value) {
      setState(() {
        tabController = TabController(length: value.length, vsync: this);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<ProjectProvider>(
      create: (_) => _pp,
      child: Consumer(builder: (context, ProjectProvider pp, _) {
        if (pp.pcList.length < 1) {
          return Scaffold(
              appBar: AppBar(
                title: Text(S.of(context).tabProject),
                centerTitle: true,
              ),
              body: EmptyHolder());
        }
        
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
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
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    isScrollable: true,
                    indicatorColor: Colors.white,
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
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }
}

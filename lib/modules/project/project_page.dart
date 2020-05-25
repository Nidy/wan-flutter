import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanflutter/generated/l10n.dart';
import 'package:wanflutter/http/entity/project_category_entity.dart';
import 'package:wanflutter/modules/project/project_category_widget.dart';
import 'package:wanflutter/modules/project/provider/project_model.dart';
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

  List<Widget> _buildTabs(List<ProjectModel> list) {
    var _tabs = List<Widget>();
    if (list.isEmpty) {
      return _tabs;
    }
    list.forEach((element) {
      _tabs.add(Tab(
          child: Text(
        element.categoryEntity.name,
        style: AppStyle.smallRegularTextStyle,
      )));
    });
    return _tabs;
  }

  List<Widget> _buildBodyPage(List<ProjectModel> list) {
    var _pages = List<Widget>();
    if (list.isEmpty) {
      return _pages;
    }
    list.forEach((element) {
      _pages.add(ProjectCategoryWidget(element, _pp));
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
        if (pp.projectModelList.length < 1) {
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
                    tabs: _buildTabs(pp.projectModelList),
                    controller: tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    isScrollable: true,
                    indicatorColor: Colors.white,
                    indicatorPadding: EdgeInsets.only(bottom: 2),
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: AppStyle.smallRegularTextWhite,
                    unselectedLabelStyle: AppStyle.smallRegularTextWhite,
                  ),
                )
              ];
            },
            body: TabBarView(
              controller: tabController,
              children: _buildBodyPage(pp.projectModelList),
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
    _pp?.refreshController?.dispose();
    super.dispose();
  }
}

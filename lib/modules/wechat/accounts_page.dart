import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanflutter/generated/l10n.dart';
import 'package:wanflutter/modules/wechat/accounts_article_widget.dart';
import 'package:wanflutter/modules/wechat/provider/accounts_model.dart';
import 'package:wanflutter/modules/wechat/provider/accounts_provider.dart';
import 'package:wanflutter/theme/app_style.dart';
import 'package:wanflutter/widget/empty_holder.dart';

class AccountsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccountsPageState();
  }
}

class _AccountsPageState extends State<AccountsPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  var _provider = AccountsProvider();

  List<Widget> _buildTabs(List<AccountsModel> list) {
    var _tabs = List<Widget>();
    if (list.isEmpty) {
      return _tabs;
    }
    list.forEach((element) {
      _tabs.add(Tab(
          child: Text(
        element.category.name,
        style: AppStyle.smallRegularTextWhite,
      )));
    });
    return _tabs;
  }

  List<Widget> _buildBodyPage(List<AccountsModel> list) {
    var _pages = List<Widget>();
    if (list.isEmpty) {
      return _pages;
    }
    list.forEach((element) {
      _pages.add(AccountsAritcleWidget(element, _provider));
    });
    return _pages;
  }

  @override
  void initState() {
    super.initState();
    _provider.getCategory().then((value) => setState(() {
          _tabController = TabController(length: value.length, vsync: this);
        }));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChangeNotifierProvider<AccountsProvider>(
        create: (_) => _provider,
        child: Consumer(builder: (context, AccountsProvider provider, _) {
          if (provider.accountsModelList.length < 1) {
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
                    title: Text(S.of(context).tabProject,),
                    centerTitle: true,
                    floating: false,
                    pinned: true,
                    forceElevated: true,
                    bottom: TabBar(
                      tabs: _buildTabs(provider.accountsModelList),
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      isScrollable: true,
                      indicatorColor: Colors.white,
                      indicatorPadding: EdgeInsets.only(bottom: 2),
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: AppStyle.smallRegularTextWhite,
                    ),
                  )
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: _buildBodyPage(provider.accountsModelList),
              ),
            ),
          );
        }));
  }

  @override
  bool get wantKeepAlive => true;
}

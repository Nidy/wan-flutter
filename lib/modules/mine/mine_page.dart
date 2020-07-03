import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanflutter/modules/login/login_page.dart';
import 'package:wanflutter/modules/login/provider/login_provider.dart';
import 'package:wanflutter/theme/app_style.dart';
import 'package:wanflutter/utils/constants.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<LoginProvider>(builder: (context, LoginProvider lp, _) {
      return Scaffold(
        body:
            // ? Center(
            //     child: RaisedButton(
            //       color: Colors.blue,
            //       child: Text('去登录', style: AppStyle.defaultRegularTextWhite),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(20.0),
            //       ),
            //       onPressed: () => Navigator.push(context,
            //           MaterialPageRoute(builder: (context) {
            //         return LoginPage();
            //       })),
            //     ),
            //   )
            // :
            NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 300,
                floating: true,
                pinned: true,
                snap: false,
                flexibleSpace: FlexibleSpaceBar(
                  title: GestureDetector(
                    child: Text(
                      lp.needLogin ?? true ? '去登录' : lp.user?.nickname,
                      style: AppStyle.defaultBoldTextStyle,
                    ),
                    onTap: () => lp.needLogin ?? true
                        ? Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                            return LoginPage();
                          }))
                        : null,
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
          body: Container(),
        ),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}

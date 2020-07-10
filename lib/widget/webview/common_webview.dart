import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wanflutter/modules/login/login_page.dart';
import 'package:wanflutter/modules/login/provider/login_provider.dart';
import 'package:wanflutter/widget/webview/web_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonWebview extends StatelessWidget {
  final String title;
  final String url;
  final int id;
  final bool collect;
  final bool showCollect;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final _webModel = WebProvider();

  CommonWebview({
    Key key,
    @required this.title,
    @required this.url,
    @required this.id,
    this.collect,
    this.showCollect = true,
  }) : super(key: key) {
    _webModel.setCollect(collect);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => _webModel,
        child: Consumer2(
          builder: (context, LoginProvider lp, WebProvider wm, _) => Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop()),
              actions: <Widget>[
                if (showCollect)
                  IconButton(
                      icon: Icon(
                        _webModel.isCollect
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (lp.needLogin) {
                          Fluttertoast.showToast(msg: '登录后才能使用收藏功能');
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return LoginPage();
                          }));
                        } else {
                          if (collect) {
                            lp.removeMarkActical(id: id).then((value) {
                              _webModel.setCollect(false);
                            });
                          } else {
                            lp
                                .markArtical(id)
                                .then((value) => _webModel.setCollect(true));
                          }
                        }
                      }),
              ],
              title: Text(title,
                  style: TextStyle(color: (Colors.white), fontSize: 16.0)),
              centerTitle: true,
            ),
            body: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                WebView(
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (controller) {
                    _controller.complete(controller);
                  },
                  onPageStarted: (url) {
                    // EasyLoading.show(status: 'loading');
                  },
                  onPageFinished: (url) {
                    wm.setLoading(true);
                  },
                  gestureNavigationEnabled: true,
                ),
                Offstage(
                  offstage: wm.isLoading,
                  child: Container(
                    color: Colors.black54,
                    width: 80.0,
                    height: 80.0,
                    alignment: FractionalOffset.center,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

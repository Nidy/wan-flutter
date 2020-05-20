import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanflutter/widget/webview/web_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonWebview extends StatelessWidget {
  final String title;
  final String url;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final _webModel = WebProvider();

  CommonWebview({Key key, @required this.title, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => _webModel,
        child: Consumer(
          builder: (context, WebProvider wm, _) => Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop()),
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

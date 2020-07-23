import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanflutter/generated/l10n.dart';
import 'package:wanflutter/http/api.dart';
import 'package:wanflutter/http/http_manager.dart';
import 'package:wanflutter/modules/login/provider/login_provider.dart';
import 'package:wanflutter/modules/system/knowledge_sysytem.dart';
import 'package:wanflutter/modules/wechat/accounts_page.dart';
import 'package:wanflutter/modules/home/home_page.dart';
import 'package:wanflutter/modules/mine/mine_page.dart';
import 'package:wanflutter/modules/project/project_page.dart';
import 'package:wanflutter/setting/app_config.dart';
import 'package:wanflutter/utils/log_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpManager().init(baseUrl: Api.BASE_URL);
  LogUtil.init(isDebug: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final _appConfig = AppConfig();
  final _loginProvider = LoginProvider();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppConfig>(
          create: (_) => _appConfig,
        ),
        ChangeNotifierProvider<LoginProvider>(
          create: (_) => _loginProvider,
        ),
      ],
      child: Consumer<AppConfig>(
        builder: (context, AppConfig appConfig, _) => MaterialApp(
          title: 'Flutter Demo',
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          supportedLocales: S.delegate.supportedLocales,
          theme: _appConfig.themeData,
          locale: appConfig.currLocale,
          home: RefreshConfiguration(
              headerBuilder: () =>
                  WaterDropHeader(), // 配置默认头部指示器,假如你每个页面的头部指示器都一样的话,你需要设置这个
              footerBuilder: () => ClassicFooter(), // 配置默认底部指示器
              headerTriggerDistance: 80.0, // 头部触发刷新的越界距离
              springDescription: SpringDescription(
                  stiffness: 170,
                  damping: 16,
                  mass: 1.9), // 自定义回弹动画,三个属性值意义请查询flutter api
              maxOverScrollExtent: 80, //头部最大可以拖动的范围,如果发生冲出视图范围区域,请设置这个属性
              maxUnderScrollExtent: 0, // 底部最大可以拖动的范围
              enableScrollWhenRefreshCompleted:
                  true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
              enableLoadingWhenFailed: true, //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
              hideFooterWhenNotFull: false, // Viewport不满一屏时,禁用上拉加载更多功能
              enableBallisticLoad: true, // 可以通过惯性滑动触发加载更多
              child: FlutterEasyLoading(
                child: MyHomePage(appConfig: appConfig),
              )),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final homePage = HomePage();
  final projectPage = ProjectPage();
  final accountPage = AccountsPage();
  final systemPage = KnowledgeSystemPage();
  final minePage = MinePage();

  MyHomePage({Key key, this.appConfig}) : super(key: key);

  final AppConfig appConfig;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController;
  int _currentIndex = 0;
  List<Widget> _pages = List<Widget>();
  DateTime _lastPressedAt; //上次点击时间

  @override
  void initState() {
    super.initState();
    _pages
      ..add(widget.homePage)
      ..add(widget.projectPage)
      ..add(widget.accountPage)
      ..add(widget.systemPage)
      ..add(widget.minePage);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_lastPressedAt == null ||
              DateTime.now().difference(_lastPressedAt) >
                  Duration(seconds: 1)) {
            _lastPressedAt = DateTime.now();
            Fluttertoast.showToast(msg: '再次点击退出app');
            return false;
          }
          return true;
        },
        child: Scaffold(
          bottomNavigationBar: _getBoottomNavBar(context),
          body: PageView.builder(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _pages[index];
              }),
        ));
  }

  Widget _getBoottomNavBar(BuildContext context) {
    final _bottomNavigationColor = Colors.blueGrey;
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          title: Text(
            S.of(context).tabHome,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.library_books,
          ),
          title: Text(
            S.of(context).tabProject,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.camera,
          ),
          title: Text(
            S.of(context).tabAccounts,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.android,
          ),
          title: Text(
            S.of(context).tabSystem,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
          ),
          title: Text(
            S.of(context).tabMine,
          ),
        ),
      ],
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 14.0,
      unselectedFontSize: 14.0,
      currentIndex: _currentIndex,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
          if (_pageController.hasClients) {
            _pageController.jumpToPage(_currentIndex);
          }
        });
      },
    );
  }
}

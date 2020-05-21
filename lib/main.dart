import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wanflutter/generated/l10n.dart';
import 'package:wanflutter/http/api.dart';
import 'package:wanflutter/http/http_manager.dart';
import 'package:wanflutter/modules/accounts_page.dart';
import 'package:wanflutter/modules/home/home_page.dart';
import 'package:wanflutter/modules/home/provider/home_provider.dart';
import 'package:wanflutter/modules/mine_page.dart';
import 'package:wanflutter/modules/project/project_page.dart';
import 'package:wanflutter/modules/project/provider/project_provider.dart';
import 'package:wanflutter/setting/app_config.dart';
import 'package:wanflutter/utils/log_utils.dart';

void main() {
  HttpManager().init(baseUrl: Api.BASE_URL);
  LogUtil.init(isDebug: true);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final _appConfig = AppConfig();
  final _homeProvider = HomeProvider();
  final _projectProvider = ProjectProvider();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppConfig>(
          create: (_) => _appConfig,
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (_) => _homeProvider,
        ),
        ChangeNotifierProvider<ProjectProvider>(
          create: (_) => _projectProvider,
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
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            locale: appConfig.currLocale,
            home: FlutterEasyLoading(
              child: MyHomePage(appConfig: appConfig),
            )),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final homePage = HomePage();
  final projectPage = ProjectPage();
  final accountPage = AccountsPage();
  final minePage = MinePage();
  MyHomePage({Key key, this.appConfig}) : super(key: key);

  final AppConfig appConfig;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List<Widget> _pages = List<Widget>();
  DateTime _lastPressedAt; //上次点击时间

  @override
  void initState() {
    _pages
      ..add(widget.homePage)
      ..add(widget.projectPage)
      ..add(widget.accountPage)
      ..add(widget.minePage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_lastPressedAt == null ||
              DateTime.now().difference(_lastPressedAt) >
                  Duration(seconds: 1)) {
            _lastPressedAt = DateTime.now();
            EasyLoading.showToast('再次点击退出app');
            return false;
          }
          return true;
        },
        child: Scaffold(
          bottomNavigationBar: _getBoottomNavBar(context),
          body: _pages[_currentIndex],
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
            Icons.person,
          ),
          title: Text(
            S.of(context).tabMine,
          ),
        ),
      ],
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: _bottomNavigationColor,
      selectedIconTheme: IconThemeData(color: Colors.blueAccent),
      unselectedIconTheme: IconThemeData(color: _bottomNavigationColor),
      selectedFontSize: 14.0,
      unselectedFontSize: 14.0,
      currentIndex: _currentIndex,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}

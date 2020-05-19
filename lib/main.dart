import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wanflutter/constant/constants.dart';
import 'package:wanflutter/generated/l10n.dart';
import 'package:wanflutter/http/api.dart';
import 'package:wanflutter/http/http_manager.dart';
import 'package:wanflutter/modules/accounts_page.dart';
import 'package:wanflutter/modules/home_page.dart';
import 'package:wanflutter/modules/mine_page.dart';
import 'package:wanflutter/modules/project_page.dart';
import 'package:wanflutter/setting/app_config.dart';
import 'package:wanflutter/utils/log_utils.dart';

void main() {
  HttpManager().init(baseUrl: Api.BASE_URL);
  LogUtil.init(isDebug: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final _appConfig = AppConfig();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppConfig>(
          create: (_) => _appConfig,
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
          home: MyHomePage(appConfig: appConfig),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.appConfig}) : super(key: key);

  final AppConfig appConfig;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List<Widget> _pages = List<Widget>();

  @override
  void initState() {
    _pages
      ..add(HomePage())
      ..add(ProjectPage())
      ..add(AccountsPage())
      ..add(MinePage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _getBoottomNavBar(context),
      body: _pages[_currentIndex],
    );
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

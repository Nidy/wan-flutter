import 'package:path/path.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DBManager {
  static DBManager _instance;

  static const _VERSION = 1;

  static const _NAME = "flutter.db";

  static Database _database;

  // 单例公开访问点
  factory DBManager() => _getInstance();

  String password = "1234";
  // 私有构造函数
  DBManager._() {
    // 具体初始化代码
  }

  static DBManager _getInstance() {
    if (_instance == null) {
      _instance = DBManager._();
    }
    return _instance;
  }

  ///初始化
  init() async {
    var databasesPath = await getDatabasesPath();

    String path = join(databasesPath, _NAME);

    _database = await openDatabase(path,
        password: password,
        version: _VERSION,
        onCreate: (Database db, int version) async {});
  }

  ///判断表是否存在
  isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res = await _database.rawQuery(
        "select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res != null && res.length > 0;
  }

  ///获取当前数据库对象
  Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database;
  }

  ///关闭
  static close() {
    _database?.close();
    _database = null;
  }
}

import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:wanflutter/db/base_db_provider.dart';
import 'package:wanflutter/db/user_model.dart';


class PersonDbProvider extends BaseDbProvider{
  ///表名
  final String name = 'PresonInfo';

  final String columnId="id";
  final String columnMobile="mobile";
  final String columnHeadImage="headImage";


  PersonDbProvider();

  @override
  tableName() {
    return name;
  }

  @override
  createTableString() {
   return '''
        create table $name (
        $columnId integer primary key,$columnHeadImage text not null,
        $columnMobile text not null)
      ''';
  }

  ///查询数据库
  Future _getPersonProvider(Database db, int id) async {
    List<Map<String, dynamic>> maps =
    await db.rawQuery("select * from $name where $columnId = $id");
    return maps;
  }

  ///插入到数据库
  Future insert(UserModel model) async {
    Database db = await getDataBase();
    var userProvider = await _getPersonProvider(db, model.id);
    if (userProvider != null) {
      ///删除数据
      await db.delete(name, where: "$columnId = ?", whereArgs: [model.id]);
    }
    return await db.rawInsert("insert into $name ($columnId,$columnMobile,$columnHeadImage) values (?,?,?)",[model.id,model.mobile,model.headImage]);
  }

  ///更新数据库
  Future<void> update(UserModel model) async {
    Database database = await getDataBase();
    await database.rawUpdate(
        "update $name set $columnMobile = ?,$columnHeadImage = ? where $columnId= ?",[model.mobile,model.headImage,model.id]);

  }


  ///获取事件数据
  Future<UserModel> getPersonInfo(int id) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps  = await _getPersonProvider(db, id);
    if (maps.length > 0) {
      return UserModel.fromJson(maps[0]);
    }
    return null;
  }
}
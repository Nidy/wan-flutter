import 'package:flutter/material.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:wanflutter/db/db_manager.dart';

abstract class BaseDbProvider {
  bool isTableExits = false;

  createTableString();

  tableName();

  ///创建表sql语句
  tableBaseString(String sql) {
    return sql;
  }

  Future<Database> getDataBase() async {
    return await open();
  }

  ///super 函数对父类进行初始化
  @mustCallSuper
  prepare(name, String createSql) async {
    isTableExits = await DBManager().isTableExits(name);
    if (!isTableExits) {
      Database db = await DBManager().getCurrentDatabase();
      return await db.execute(createSql);
    }
  }

  @mustCallSuper
  open() async {
    if (!isTableExits) {
      await prepare(tableName(), createTableString());
    }
    return await DBManager().getCurrentDatabase();
  }

}
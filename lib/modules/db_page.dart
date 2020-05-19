import 'package:flutter/material.dart';
import 'package:wanflutter/db/person_db_provider.dart';
import 'package:wanflutter/db/user_model.dart';

class DBPage extends StatefulWidget {
  @override
  _DBPageState createState() {
    return _DBPageState();
  }
}

class _DBPageState extends State<DBPage> {
  PersonDbProvider _provider = new PersonDbProvider();
  UserModel _userModel = UserModel(id: 111, mobile: "0", headImage: "0");

  void insert() async {
    _userModel =
        UserModel(id: 111, mobile: "15801071158", headImage: "http://www.img");
    _provider.insert(_userModel);
    showData();
  }

  void update() async {
    _userModel = await _provider.getPersonInfo(111);
    _userModel.id = 111;
    _userModel.mobile = "15844445555";
    _userModel.headImage = "http://www.img1.com";
    _provider.update(_userModel);
    showData();
  }

  void showData() async {
    _userModel = await _provider.getPersonInfo(111);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DB测试'),
      ),
      body: new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('插入数据'),
              color: Colors.blueAccent,
              onPressed: () => insert(),
            ),
            RaisedButton(
              child: Text('更新数据'),
              color: Colors.blueAccent,
              onPressed: () => update(),
            ),
            Text('id: ${_userModel.id}'),
            SizedBox(height: 10.0),
            Text('mobile: ${_userModel.mobile}'),
            SizedBox(height: 10.0),
            Text('headImage: ${_userModel.headImage}'),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wanflutter/modules/login/provider/login_provider.dart';
import 'package:wanflutter/modules/login/register_page.dart';
import 'package:wanflutter/utils/reg_utils.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var _nameTextController = TextEditingController();
  var _pwdTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (BuildContext context, LoginProvider provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('登录'),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 40),
                  TextFormField(
                    controller: _nameTextController,
                    autofocus: false,
                    inputFormatters: [
                      BlacklistingTextInputFormatter.singleLineFormatter
                    ],
                    decoration: InputDecoration(
                      hintText: '用户名',
                      prefixIcon: Icon(
                        Icons.perm_identity,
                        color: Colors.grey,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '请输入用户名';
                      }
                      if (!RegUtils.specialCharValid(value)) {
                        return '用户名输入有误';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    autofocus: false,
                    controller: _pwdTextController,
                    inputFormatters: [
                      BlacklistingTextInputFormatter.singleLineFormatter
                    ],
                    decoration: InputDecoration(
                      hintText: '密码',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.grey,
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '请输入密码';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: RaisedButton(
                      color: Colors.blue,
                      highlightColor: Colors.blue[700],
                      colorBrightness: Brightness.dark,
                      splashColor: Colors.blue[100],
                      child: Text("登录"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await provider
                              .doLogin(
                                  username: _nameTextController.text,
                                  pwd: _pwdTextController.text)
                              .then((value) {
                            Navigator.pop(context);
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      child: Text(
                        '注册新账号',
                        style: TextStyle(fontSize: 14, color: Colors.lightBlue),
                        textAlign: TextAlign.right,
                      ),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return RegisterPage();
                      })),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanflutter/http/http_error.dart';
import 'package:wanflutter/http/http_manager.dart';
import 'package:wanflutter/utils/reg_utils.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  TextEditingController _reController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 40),
                TextFormField(
                  autofocus: false,
                  controller: _nameController,
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
                      return '用户名不能为空';
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
                  controller: _pwdController,
                  decoration: InputDecoration(
                    hintText: '请输入密码',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.grey,
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  validator: (value) {
                    if (value.length < 6) {
                      return '密码至少包含6个字符';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  autofocus: false,
                  controller: _reController,
                  decoration: InputDecoration(
                    hintText: '请再次输入密码',
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.grey,
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  validator: (value) {
                    if (value != _pwdController.text) {
                      return '两次密码输入不一致';
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
                    child: Text("注册"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        Map<String, dynamic> params = Map<String, dynamic>();
                        params['username'] = _nameController.text;
                        params['password'] = _pwdController.text;
                        params['repassword'] = _reController.text;
                        await HttpManager()
                            .postAsync(
                          url: '/user/register',
                          params: params,
                          tag: 'register',
                        )
                            .then((value) {
                          Fluttertoast.showToast(msg: "注册成功");
                          Navigator.pop(context);
                        }).catchError((error) {
                          if (error is HttpError) {
                            Fluttertoast.showToast(msg: error.message);
                          }
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

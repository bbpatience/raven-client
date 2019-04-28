import 'package:flutter/material.dart';
import 'package:myapp/database/db_api.dart';
import 'package:myapp/page/login_page.dart';
import 'package:myapp/page/main_page.dart';
import 'package:myapp/utils/sp_util.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SPUtil.getInstance();
    DataBaseApi.get().getAllContactsEntities();
    bool isLogin = false; //TODO load from sp.
    return MaterialApp(
      home: !isLogin ? new LoginPage() : new MainPage(),
      routes: {
        '/MainPage': (ctx) => MainPage(),
      });
  }
}
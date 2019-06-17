import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/page/more_widgets.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/dialog_util.dart';
import 'package:myapp/utils/file_util.dart';
import 'package:myapp/utils/popupwindow_widget.dart';
import 'package:myapp/utils/sp_util.dart';

/*
*  我的
*/
class MinePage extends StatefulWidget {
  MinePage({Key key, this.rootContext})
      : super(key: key);
  final BuildContext rootContext;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MineState();
  }
}

class _MineState extends State<MinePage> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MoreWidgets.buildAppBar(context, '',
            elevation: 0.0, actions: _actions(context)),
        body: ListView(
          children: <Widget>[
            MoreWidgets.mineListViewItem1(
                SPUtil.getString(Constants.KEY_LOGIN_ACCOUNT),
                content: SPUtil.getString(Constants.KEY_LOGIN_ACCOUNT_MOBILE),
                imageChild: _getHeadPortrait(), onImageClick: (res) {
              PopupWindowUtil.showPhotoChosen(context, onCallBack: (image) {
                setState(() {
                  // imageChild = image;
                });
              });
            }),
            MoreWidgets.buildDivider(),
            MoreWidgets.defaultListViewItem(Icons.settings, 'Settings',
                textColor: Colors.black, isDivider: false, onItemClick: (res) {
              // Navigator.push(
              //     context,
              //     new CupertinoPageRoute<void>(
              //         builder: (ctx) => SettingPage())
              //         );
            }),
            MoreWidgets.buildDivider(),
            MoreWidgets.defaultListViewItem(Icons.exit_to_app, 'Logout',
                textColor: Colors.black, isDivider: false, onItemClick: (res) {
              DialogUtil.showBaseDialog(context, 'Sure to logout？', rightClick: (res) {
                _logOut();
              });
            }),
            MoreWidgets.buildDivider(),
          ],
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  List<Widget> _actions(BuildContext context) {
    List<Widget> actions = new List();
    Widget widget = InkWell(
        child: Container(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: Icon(
              Icons.add_a_photo,
              size: 22,
            )),
        onTap: () {
          PopupWindowUtil.showPhotoChosen(context);
        });
    actions.add(widget);
    return actions;
  }

  Widget _getHeadPortrait() {
    String url = Constants.DEFAULT_PORTRAIT;
    String portraitUrl = SPUtil.getString(Constants.KEY_LOGIN_ACCOUNT_PORTRAIT);
    if (portraitUrl != null && portraitUrl.length > 0) {
      url = portraitUrl;
    }
    return Image.network(
        url,
        width: 62,
        height: 62,
        fit: BoxFit.fill,
      );
  }

  _logOut() {
    // InteractNative.goNativeWithValue(InteractNative.methodNames['logout'])
    //     .then((success) {
    //   if (success == true) {
    //     DialogUtil.buildToast('Success');
    //     ObjectUtil.doExit(widget.rootContext);
    //   } else if (success is String) {
    //     DialogUtil.buildToast(success);
    //   } else {
    //     DialogUtil.buildToast('Failed');
    //   }
    // });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

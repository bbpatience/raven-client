import 'package:flutter/material.dart';
import 'package:myapp/database/db_api.dart';
import 'package:myapp/manager/contacts_manager.dart';
import 'package:myapp/manager/conversation_manager.dart';
import 'package:myapp/manager/sender_manager.dart';
import 'package:myapp/manager/socket_manager.dart';
import 'package:myapp/page/contacts_page.dart';
import 'package:myapp/page/conversation_page.dart';
import 'package:myapp/pb/message.pb.dart';
import 'package:myapp/utils/constants.dart';
import 'package:myapp/utils/interact_vative.dart';
import 'package:myapp/utils/object_util.dart';
import 'package:myapp/utils/sp_util.dart';


/*
*  主页
*/
class MainPage extends StatelessWidget {


  MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _pageController = new PageController(initialPage: 0);
  int _tabIndex = 0;
  var appBarTitles = ['Messages', 'Contacts'];
  List _pageList;
  String myUid;

  /*
   * 获取bottomTab的颜色和文字
   */
  Text getTabTitle(int curIndex) {
    if (curIndex == _tabIndex) {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 12.0, color: Colors.indigo));
    } else {
      return new Text(appBarTitles[curIndex],
          style: new TextStyle(fontSize: 12.0, color: Colors.grey));
    }
  }
  
  void initData() {
    /*
     * 2个子界面
     */
    _pageList = [
      new ConversationPage(rootContext: context),
      new ContactsPage(rootContext: context),
    ];
    myUid = SPUtil.getString(Constants.KEY_LOGIN_UID);
    SenderMngr.init(_callback);

    // request Contacts.
    ContactManager.get().getContactsEntity(myUid).then((entities) {
      entities.forEach((entity) {
        DataBaseApi.get().updateContactsEntity(entity);
      });
    });
  }

  void _callback(Object incomingData, List<int> oriData) {
    RavenMessage message = RavenMessage.fromBuffer(incomingData);
    switch (message.type) {
      case RavenMessage_Type.LoginAck:
        print("IM Login success");
        ConversationManager.get().requestConverEntities();
        break;
      case RavenMessage_Type.ConverAck:
        if (message.converAck.converList != null) {
          DataBaseApi.get()
              .updateConversationEntities(
                ObjectUtil.getConvEntities(myUid, message.converAck.converList));
        } else if (message.converAck.converInfo != null) {
          DataBaseApi.get()
              .updateConversationEntities(
                ObjectUtil.getConvEntity(myUid, message.converAck.converInfo));
        }
        break;
      case RavenMessage_Type.HisMessagesAck:
        //DB insert
        DataBaseApi.get().updateMessageEntities(message.hisMessagesAck.converId, 
            ObjectUtil.getMsgEntities(myUid, message.hisMessagesAck.messageList));
        break;
      case RavenMessage_Type.UpDownMessage:
        //DB insert
        DataBaseApi.get().updateMessageEntity(message.upDownMessage.converId, 
            ObjectUtil.getMsgEntity(myUid, message.upDownMessage), true);
        break;
      case RavenMessage_Type.MessageAck:
        RavenMessage originalMsg = RavenMessage.fromBuffer(oriData);
        DataBaseApi.get().updateMessageEntity(message.messageAck.converId, 
            ObjectUtil.getMsgEntity(myUid, originalMsg.upDownMessage), false);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    SocketMngr.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            // primaryColor: primaryColor,
            // primarySwatch: primarySwatch,
            platform: TargetPlatform.android),
        
        home: new Scaffold(
                body: new PageView.builder(
                  onPageChanged: _pageChange,
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int index) {
                    return _pageList[index];
                  },
                  itemCount: 2,
                ),
                bottomNavigationBar: new BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    new BottomNavigationBarItem(
                        icon: new Icon(
                          Icons.message,
                          color: _tabIndex == 0 ? Colors.blueGrey : null,
                        ),
                        title: getTabTitle(0)),
                    new BottomNavigationBarItem(
                        icon: new Icon(
                          Icons.contacts,
                          color: _tabIndex == 1 ? Colors.blueGrey : null,
                        ),
                        title: getTabTitle(1)),
                  ],
                  type: BottomNavigationBarType.fixed,
                  //默认选中首页
                  currentIndex: _tabIndex,
                  iconSize: 22.0,
                  //点击事件
                  onTap: (index) {
                    _pageController.jumpToPage(index);
                  },
                )
              ),
          );
  }

  void _pageChange(int index) {
    Constants.currentPage = index;
    setState(() {
      if (_tabIndex != index) {
        _tabIndex = index;
      }
    });
  }

  _backPress() {
    // TODO
  }
}

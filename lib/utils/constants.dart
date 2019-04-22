class Constants {
  static const String KEY_LOGIN = 'key_login'; //false: show login page;
  static const String KEY_LOGIN_ACCOUNT = 'key_login_account';
  static const String KEY_LOGIN_TOKEN = 'key_login_token';
  static const String KEY_ACCESS_NODE = 'key_access_node';
  static const String INPUTFORMATTERS = '[a-zA-Z0-9!.?,~@#%^&*()]';
  static const String CONTENT_TYPE_SYSTEM = "text"; //消息内容类型：文本
  static int currentPage = 0;

  static const String MESSAGE_TYPE_CHAT = 'chat';

  static const int CONVERSATION_SINGLE = 1;
  static const int CONVERSATION_GROUP = 2;

  /* response code from */
  static const int RSP_COMMON_SUCCESS = 10000;
}

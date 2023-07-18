import 'package:chat_app/View/Screens/chat_screen.dart';
import 'package:chat_app/View/Screens/join_screen.dart';
import 'package:get/get.dart';

class Routes {
  static final List<GetPage> pages = [
    GetPage(
      name: '/join',
      page: () =>  JoinScreen(),
    ),
    GetPage(
      name: '/chat',
      page: () => const ChatScreen(),
    ),
  ];
}

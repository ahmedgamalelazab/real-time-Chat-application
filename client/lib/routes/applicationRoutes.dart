import 'package:client/presentation/screens/ChatRoom.dart';
import 'package:client/presentation/screens/homePage.dart';

class ApplicationRoutes {
  static routes() {
    return {
      HomeScreen.PAGE_ROUTE: (context) => HomeScreen(),
      ChatRoom.PAGE_ROUTE: (context) => ChatRoom(),
    };
  }

  static initialRoute() {
    return HomeScreen.PAGE_ROUTE;
  }
}

import 'package:jenga_planner/main.dart';
import 'package:jenga_planner/screens/home_screen.dart';
import 'package:jenga_planner/screens/login_screen.dart';

class AppRoutes {
  static final String root = '/';
  static final String login = 'login';
  static final String authChecker = 'auth-checker';

  static final routes = {
    root: (context) => HomeScreen(),
    login: (context) => LoginScreen(),
    authChecker: (context) => AuthChecker(),
  };
}

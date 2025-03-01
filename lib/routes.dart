import 'package:jenga_planner/screens/home.dart';
import 'package:jenga_planner/screens/login.dart';

class AppRoutes {
  static final String root = '/';
  static final String login = 'login';

  static final routes = {
  root: (context) =>  HomeScreen(),
  login: (context) => LoginScreen(),
};
}
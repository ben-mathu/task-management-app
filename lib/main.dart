import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jenga_planner/blocs/task/task_bloc.dart';
import 'package:jenga_planner/blocs/user/user_bloc.dart';
import 'package:jenga_planner/firebase_options.dart';
import 'package:jenga_planner/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jenga_planner/screens/home_screen.dart';
import 'package:jenga_planner/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) {
            return UserBloc();
          },
        ),
        BlocProvider(
          create: (BuildContext context) {
            return TaskBloc();
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: AppRoutes.authChecker,
      routes: AppRoutes.routes,
    );
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}

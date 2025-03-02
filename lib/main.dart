import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jenga_planner/blocs/user_bloc.dart';
import 'package:jenga_planner/blocs/user_state.dart';
import 'package:jenga_planner/firebase_options.dart';
import 'package:jenga_planner/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: UserBloc(),
      builder: (BuildContext context, UserState userState) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          initialRoute:
              userState.type == UserStateType.signedIn ||
                      userState.type == UserStateType.skipped
                  ? AppRoutes.root
                  : AppRoutes.login,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}

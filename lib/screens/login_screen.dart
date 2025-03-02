import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jenga_planner/blocs/user_bloc.dart';
import 'package:jenga_planner/blocs/user_event.dart';
import 'package:jenga_planner/blocs/user_state.dart';
import 'package:jenga_planner/data/services/user_service.dart';
import 'package:jenga_planner/widgets/login_form_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserBloc? _userBloc;
  final UserService _userService = UserService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    _userBloc = BlocProvider.of(context);

    return Scaffold(
      body: BlocListener<UserBloc, UserState>(
        listener: (BuildContext blocContext, UserState state) {
          if (state.type == UserStateType.requireSignUp) {
            _showDialog(blocContext);
          } else if (state.type == UserStateType.loginError) {
            String? message;
            if (state.code == 'wrong-password') {
              message = 'You have entered a wrong password';
            } else if (state.code == 'network-request-failed') {
              message = 'Please check your connection, then try again';
            } else {
              throw UnimplementedError('handle error ${state.code}');
            }

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          } else if (state.type == UserStateType.signUpError) {
            String? message;
            if (state.code == 'weak-password') {
              message = 'Please use a stronger password';
            } else if (state.code == 'email-already-in-use') {
              message = 'The email you provided already exists.';
            } else {
              throw UnimplementedError('handle error ${state.code}');
            }

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              spacing: 30.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/login.gif'),
                LoginForm(
                  onPressed: (email, password) {
                    _userService
                        .loginUser(email: email, password: password)
                        .then((value) {})
                        .onError((FirebaseAuthException e, stacktrace) {
                          if (e.code == 'user-not-found') {
                            _userBloc!.add(
                              UserEvent(type: UserEventType.openSignUpWindow),
                            );
                          } else {
                            _userBloc!.add(
                              UserEvent(
                                type: UserEventType.loginFailed,
                                code: e.code,
                              ),
                            );
                          }
                        });

                    setState(() {
                      _isLoading = false;
                    });
                  },
                  metaCallback: () {},
                  googlCallback: () {},
                  twitterCallback: () {},
                  isLoading: _isLoading,
                ),
                TextButton(
                  onPressed: () {
                    _showDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  child: Text('Don\'t have an account? Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Up'),
          content: LoginForm(
            onPressed: (email, password) {
              _userService
                  .signupUser(email: email, password: password)
                  .then((credentials) {
                    print('Logged in successfully');
                  })
                  .onError((FirebaseAuthException error, stackTrace) {
                    _userBloc!.add(UserEvent(type: UserEventType.signUpFailed));
                  });
              setState(() {
                _isLoading = false;
              });
            },
            metaCallback: () {},
            googlCallback: () {},
            twitterCallback: () {},
            isLoading: _isLoading,
          ),
        );
      },
    );
  }
}

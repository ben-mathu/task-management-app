import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jenga_planner/blocs/user_bloc.dart';
import 'package:jenga_planner/blocs/user_event.dart';
import 'package:jenga_planner/blocs/user_state.dart';
import 'package:jenga_planner/data/services/user_service.dart';
import 'package:jenga_planner/widgets/custom_button_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserBloc? _userBloc;
  final UserService _userService = UserService();
  GlobalKey _formKey = GlobalKey();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    _userBloc = BlocProvider.of(context);

    return Scaffold(
      body: BlocListener<UserBloc, UserState>(
        listener: (BuildContext blocContext, UserState state) {
          if (state.type == UserStateType.requireSignUp) {
            _showDialog(blocContext);
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/login.gif',
                  width: 45.0,
                  height: 45.0,
                ),
                _loginForm(context, (email, password) async {
                  try {
                    await _userService.loginUser(
                      email: email,
                      password: password,
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      _userBloc!.add(
                        UserEvent(type: UserEventType.openSignUpWindow),
                      );
                    } else if (e.code == 'wrong-password') {}
                  } finally {
                    setState(() {
                      _isLoading = true;
                    });
                  }
                }),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                  child: Divider(indent: 30.0, endIndent: 30.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text('Google')),
                    ElevatedButton(onPressed: () {}, child: Text('Meta')),
                    ElevatedButton(onPressed: () {}, child: Text('Twitter')),
                  ],
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
          content: _loginForm(context, (email, password) {
            _userService
                .signupUser(email: email, password: password)
                .then((credentials) {
                  print('Logged in successfully');
                })
                .catchError((error) {
                  _userBloc!.add(
                    UserEvent(type: UserEventType.openSignUpWindow),
                  );
                  setState(() {
                    _isLoading = false;
                  });
                });
            setState(() {
              _isLoading = true;
            });
          }),
        );
      },
    );
  }

  Widget _loginForm(
    BuildContext context,
    Function(String email, String password) onPressed,
  ) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _userFormTextField(usernameController),
          _passwordFormTextField(passwordController),
          CustomButton(
            onPressed:
                () =>
                    onPressed(usernameController.text, passwordController.text),
            text: 'Submit',
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  Widget _passwordFormTextField(TextEditingController passwordController) =>
      TextFormField(
        controller: passwordController,
        decoration: InputDecoration(
          label: Text('Password'),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
            child:
                _obscurePassword
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
          ),
        ),
        keyboardType: TextInputType.text,
        obscureText: _obscurePassword,
      );

  Widget _userFormTextField(TextEditingController usernameController) =>
      TextFormField(
        controller: usernameController,
        decoration: InputDecoration(
          label: Text('Email'),
          hintText: 'example@benatt.com',
        ),
        keyboardType: TextInputType.emailAddress,
      );
}

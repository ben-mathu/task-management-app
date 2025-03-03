import 'package:flutter/material.dart';
import 'package:jenga_planner/widgets/custom_button_widget.dart';

class LoginForm extends StatefulWidget {
  final bool isLoading;
  final Function(String username, String password) onPressed;
  final VoidCallback? facebookCallback;
  final VoidCallback? twitterCallback;
  final VoidCallback googlCallback;

  LoginForm({
    required this.onPressed,
    required this.googlCallback,
    this.facebookCallback,
    this.twitterCallback,
    this.isLoading = false,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 15.0,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _userFormTextField(_usernameController),
          _passwordFormTextField(_passwordController),
          CustomButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onPressed(
                  _usernameController.text,
                  _passwordController.text,
                );
              }
            },
            text: 'Submit',
            isLoading: widget.isLoading,
          ),
          Text('Or continue with'),
          Divider(indent: 90.0, endIndent: 90.0),
          Row(
            spacing: 10.0,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logoButton('assets/images/google_logo.png', () {
                widget.googlCallback();
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget logoButton(String imagePath, VoidCallback onPressed) => ElevatedButton(
    onPressed: onPressed,
    child: Image.asset(imagePath, width: 20.0, height: 20.0),
  );

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
                    ? Icon(Icons.visibility)
                    : Icon(Icons.visibility_off),
          ),
        ),
        keyboardType: TextInputType.text,
        obscureText: _obscurePassword,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password is required';
          }
          return null;
        },
      );

  Widget _userFormTextField(TextEditingController usernameController) =>
      TextFormField(
        controller: usernameController,
        decoration: InputDecoration(
          label: Text('Email'),
          hintText: 'example@benatt.com',
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email is required';
          }
          return null;
        },
      );
}

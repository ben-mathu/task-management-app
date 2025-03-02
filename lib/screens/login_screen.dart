import 'package:flutter/material.dart';
import 'package:jenga_planner/widgets/custom_button_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              _loginForm,
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
    );
  }

  Widget get _loginForm => Form(
    child: Column(
      children: [
        Image.asset('assets/images/login.gif'),
        TextFormField(
          decoration: InputDecoration(
            label: Text('Username/email'),
            hintText: 'example@benatt.com',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        TextFormField(
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
        ),
        CustomButton(onPressed: () {
          setState(() {
            _isLoading = true;
          });
        }, text: 'Submit', isLoading: _isLoading,),
      ],
    ),
  );
}

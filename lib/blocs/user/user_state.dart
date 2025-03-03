import 'package:firebase_auth/firebase_auth.dart';

enum UserStateType {
  initial,
  signedIn,
  signedOut,
  skipped,
  requireSignUp,
  loginError,
  signUpError,
}

class UserState {
  final User? user;
  final UserStateType type;
  final String? code;
  UserState({this.user, required this.type, this.code});
}

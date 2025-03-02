import 'package:firebase_auth/firebase_auth.dart';

enum UserStateType {
  initial, signedIn, signedOut, skipped, requireSignUp
}

class UserState {
  final User? user;
  final UserStateType type;
  UserState({this.user, required this.type});
}
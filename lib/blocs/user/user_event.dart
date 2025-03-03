enum UserEventType {
  appOpened,
  login,
  openSignUpWindow,
  loginFailed,
  signUpFailed,
  skipSignIn,
  successfulSignIn,
}

class UserEvent {
  final String? username;
  final String? password;
  final UserEventType type;
  final String? code;
  UserEvent({this.username, this.password, required this.type, this.code});
}

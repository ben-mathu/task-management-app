enum UserEventType {
  appOpened, login
}

class UserEvent {
  final String? username;
  final String? password;
  final UserEventType type;
  UserEvent({this.username, this.password, required this.type});
}
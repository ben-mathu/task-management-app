import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jenga_planner/blocs/user_event.dart';
import 'package:jenga_planner/blocs/user_state.dart';
import 'package:jenga_planner/data/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService userService = UserService();
  User? _user;

  UserBloc() : super(UserState(type: UserStateType.initial)) {
    on<UserEvent>((event, emit) {
      if (event.type == UserEventType.appOpened) {
        userService.listenForAuth(
          onAuthChanged: (User? user) {
            if (user != null) {
              emit(UserState(type: UserStateType.signedIn));
            } else {
              emit(UserState(type: UserStateType.signedOut));
            }
          },
        );
      } else if (event.type == UserEventType.openSignUpWindow) {
        emit(UserState(type: UserStateType.requireSignUp));
      }
    });
  }

  isSignedin() {
    return _user != null;
  }
}

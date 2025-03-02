import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  listenForAuth({required void Function(User? user) onAuthChanged}) async {
    return await FirebaseAuth.instance
      .authStateChanges().listen(onAuthChanged);
  }

  void loginUser() {}
}
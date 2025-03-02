import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  listenForAuth({required void Function(User? user) onAuthChanged}) async {
    return FirebaseAuth.instance.authStateChanges().listen(onAuthChanged);
  }

  Future<UserCredential> loginUser({
    required String email,
    required String password,
  }) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  signupUser({required String email, required String password}) {}
}

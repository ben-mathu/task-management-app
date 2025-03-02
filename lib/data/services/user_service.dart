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

  Future<UserCredential> signupUser({
    required String email,
    required String password,
  }) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}

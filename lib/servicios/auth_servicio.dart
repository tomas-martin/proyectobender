import 'package:firebase_auth/firebase_auth.dart';

class AuthServicio {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Registrar usuario
  Future<User?> registrar(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      print("Error registro: $e");
      return null;
    }
  }

  // Login usuario
  Future<User?> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      print("Error login: $e");
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Usuario actual
  User? get usuarioActual => _auth.currentUser;
}

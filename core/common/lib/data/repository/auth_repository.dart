import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  var auth = FirebaseAuth.instance;
  var googleSignIn = GoogleSignIn();

 Future<User?> signInWithEmail(String email, String password) async {
    final result = await auth.signInWithEmailAndPassword(email: email, password: password);
    return result.user;
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    final result = await auth.createUserWithEmailAndPassword(email: email, password: password);
    return result.user;
  }

  Future<User?> signInWithGoogle() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final result = await auth.signInWithCredential(credential);
    return result.user;
  }

  

 Future<void> signOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
  }

  User? get currentUser => auth.currentUser;
}
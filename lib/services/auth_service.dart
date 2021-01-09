import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  /// Handles authentication using
  /// email and password and Facebook
  final FirebaseAuth _firebaseAuth;
  String googleAccessToken, googleIdToken;
  AuthService(this._firebaseAuth);

  /// Notifies about the sign in state
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<String> signOut() async {
    /// Handles sign out
    try {
      await _firebaseAuth.signOut();
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  GoogleAuthCredential getGoolgeCredential({accessToken, idToken}) {
    return GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );
  }

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      googleAccessToken = googleAuth.accessToken;
      googleIdToken = googleAuth.idToken;

      await FirebaseAuth.instance.signInWithCredential(getGoolgeCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken));
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class Auth {
  User get currentUser => FirebaseAuth.instance.currentUser;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Stream<User> authStateChanges() => firebaseAuth.authStateChanges();

  static Future<User> signInWithGoogle() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      try {
        if (googleAuth.idToken != null) {
          final userCredential = await firebaseAuth
              .signInWithCredential(GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ));
          return userCredential.user;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'ERROR_ABORTED_BY_USER') {
          print('aborted by user');
        } else {
          print(e.toString());
        }
      }
    }
  }

  static Future<User> signInWithFacebook() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.email,
      FacebookPermission.publicProfile,
    ]);
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        final userCredential = await firebaseAuth.signInWithCredential(
            FacebookAuthProvider.credential(accessToken.token));
        return userCredential.user;
      case FacebookLoginStatus.cancel:
        print("Aborted by user");
        break;
      case FacebookLoginStatus.error:
        print("Facebook Login Error");
        break;
      default:
        throw UnimplementedError();
    }
  }

  static Future<bool> signOut() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facbookLogin = FacebookLogin();
    await facbookLogin.logOut();
    await firebaseAuth.signOut();
    if (firebaseAuth.currentUser == null) {
      return true;
    }
  }
}

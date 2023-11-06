import 'package:babystory/error/error.dart';
import 'package:babystory/models/user.dart' as my_user;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late my_user.User? _user;

  my_user.User? get user => _user;

  my_user.User _getMyUserFromFirebaseUser(
      {required User user,
      String? nickname,
      my_user.SignInMethod? signInMethod}) {
    return my_user.User(
      uid: user.uid,
      email: user.email!,
      nickname: user.displayName ?? nickname ?? '',
      signInMethod: signInMethod ?? my_user.SignInMethod.email,
      photoURL: user.photoURL,
      emailVerified: user.emailVerified,
    );
  }

  Future<AuthError?> signupWithEmailAndPassword({
    required String email,
    required String nickname,
    required String password,
  }) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        _user = _getMyUserFromFirebaseUser(
            user: credential.user!,
            nickname: nickname,
            signInMethod: my_user.SignInMethod.email);
        return null;
      }
      return AuthError(
          message: 'Server Error', type: ErrorType.auth, code: 'server-error');
    } on FirebaseAuthException catch (error) {
      AuthError authError = AuthError(
        message:
            AuthError.getFirebaseAuthError(error.code) ?? 'firebase auth error',
        type: ErrorType.auth,
        code: error.code,
      );
      return authError;
    }
  }

  Future<AuthError?> signinWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account != null) {
      GoogleSignInAuthentication authentication = await account.authentication;
      OAuthCredential googleCredential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken,
      );
      UserCredential credential =
          await _firebaseAuth.signInWithCredential(googleCredential);
      if (credential.user != null) {
        _user = _getMyUserFromFirebaseUser(
            user: credential.user!, signInMethod: my_user.SignInMethod.google);
        return null;
      }
      return AuthError(
          code: 'google-user-not-found',
          type: ErrorType.auth,
          message: 'User not found');
    }
    return AuthError(
        message: 'Account not found',
        type: ErrorType.auth,
        code: 'account-not-found');
  }

  Future<AuthError?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        _user = _getMyUserFromFirebaseUser(
            user: credential.user!, signInMethod: my_user.SignInMethod.email);
        return null;
      }
      return AuthError(
          message: 'Server Error', type: ErrorType.auth, code: 'server-error');
    } on FirebaseException catch (error) {
      AuthError authError = AuthError(
        message:
            AuthError.getFirebaseAuthError(error.code) ?? 'firebase auth error',
        type: ErrorType.auth,
        code: error.code,
      );
      return authError;
    }
  }

  Future<AuthError?> loginWithGoogle() async {
    return await signinWithGoogle();
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      return;
    }
  }
}

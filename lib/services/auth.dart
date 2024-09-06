import 'package:babystory/apis/parent_api.dart';
import 'package:babystory/error/error.dart';
import 'package:babystory/models/parent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ParentApi _parentApi = ParentApi();
  late Parent? _user;

  Parent? get user => _user;

  Future<Parent?> getUser() async {
    // await signOut();
    // return null;
    User? user = _firebaseAuth.currentUser;
    print("User: $user");
    await Future.delayed(const Duration(milliseconds: 100));
    return Parent(
      uid: 'uid1',
      email: 'email1',
      nickname: 'nickname1',
      signInMethod: SignInMethod.email,
      photoId: "photoId1",
      emailVerified: true,
      description:
          "안녕하세요 저는 아크하드입니다. 새봄과 다운, 두 명의 아이를 키우고 있어요. 사랑과 기쁨과 행복을 주는 아이들 덕분에 행복하게 살고 있담니다.",
    );
    // if (user == null) {
    //   await signOut();
    //   return null;
    // }

    // var token = await _parentApi.getJwtToken(uid: user.uid);
    // if (token == null) {
    //   return null;
    // }

    // var prefs = await SharedPreferences.getInstance();
    // await prefs.setString('x-jwt', token);

    // return Parent(
    //   uid: user.uid,
    //   email: user.email!,
    //   nickname: user.displayName ?? 'User',
    //   signInMethod: SignInMethod.email,
    //   photoId: user.photoURL,
    //   emailVerified: user.emailVerified,
    // );
  }

  Parent _getMyUserFromFirebaseUser(
      {required User user, String? nickname, SignInMethod? signInMethod}) {
    return Parent(
      uid: user.uid,
      email: user.email!,
      nickname: user.displayName ?? nickname ?? '',
      signInMethod: signInMethod ?? SignInMethod.email,
      photoId: user.photoURL,
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
            signInMethod: SignInMethod.email);
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
            user: credential.user!, signInMethod: SignInMethod.google);
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
            user: credential.user!, signInMethod: SignInMethod.email);
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

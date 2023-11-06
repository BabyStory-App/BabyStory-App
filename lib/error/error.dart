enum ErrorType {
  auth,
  unknown,
}

class Error {
  final String? code;
  String message;
  final ErrorType type;

  Error({
    this.message = '',
    this.code,
    this.type = ErrorType.unknown,
  });

  void setMessage(String message) {
    this.message = message;
  }
}

class AuthError extends Error {
  AuthError({
    String message = '',
    String? code,
    ErrorType type = ErrorType.unknown,
  }) : super(
          code: code,
          message: message,
          type: type,
        );

  static String? getFirebaseAuthError(String? code) {
    switch (code) {
      case "invalid-email":
        return "이메일 형식이 올바르지 않습니다.";
      case "user-disabled":
        return "사용이 중지된 계정입니다.";
      case "user-not-found":
        return "사용자를 찾을 수 없습니다.";
      case "wrong-password":
        return "비밀번호가 올바르지 않습니다.";
      case "email-already-in-use":
        return "이미 사용중인 이메일입니다.";
      case "weak-password":
        return "비밀번호는 6자리 이상이어야 합니다.";
      case "operation-not-allowed":
        return "이메일/비밀번호 로그인이 비활성화 되어 있습니다.";
      default:
        return null;
    }
  }
}

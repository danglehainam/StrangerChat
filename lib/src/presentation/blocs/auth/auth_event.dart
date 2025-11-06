abstract class AuthEvent{}

class RegisterEvent extends AuthEvent{
  final String email;
  final String username;
  final String password;
  final String confirmPassword;

  RegisterEvent(this.email, this.username, this.password, this.confirmPassword);
}

class VerifyUserEvent extends AuthEvent{
  final String email;
  final String code;

  VerifyUserEvent(this.email, this.code);
}

class LoginEvent extends AuthEvent{
  final String loginId;
  final String password;

  LoginEvent(this.loginId, this.password);
}


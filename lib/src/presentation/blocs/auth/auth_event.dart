abstract class AuthEvent{}

class RegisterEvent extends AuthEvent{
  final String email;
  final String username;
  final String password;

  RegisterEvent(this.email, this.username, this.password);
}

class VerifyUserEvent extends AuthEvent{
  final String email;
  final String code;

  VerifyUserEvent(this.email, this.code);
}


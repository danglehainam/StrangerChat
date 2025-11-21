abstract class AuthState{}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess(this.message);
}
class AuthError extends AuthState {
  final String error;
  AuthError(this.error);
}
class AuthVerifySuccess extends AuthState{
  final String message;
  AuthVerifySuccess(this.message);
}
class AuthSuccessToChat extends AuthState{
  final String roomId;
  AuthSuccessToChat(this.roomId);
}
class AuthSuccessToFind extends AuthState{
  final String uid;
  AuthSuccessToFind(this.uid);
}
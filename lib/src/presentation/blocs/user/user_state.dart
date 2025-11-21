abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final String name;
  final int age;
  final String gender;

  UserLoaded({
    required this.name,
    required this.age,
    required this.gender,
  });
}

class UserSuccess extends UserState {
  final String message;
  UserSuccess(this.message);
}

class UserFailure extends UserState {
  final String error;
  UserFailure(this.error);
}

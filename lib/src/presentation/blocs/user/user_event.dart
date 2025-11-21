abstract class UserEvent {}

class LoadUserEvent extends UserEvent {
  final String uid;
  LoadUserEvent(this.uid);
}

class UpdateUserEvent extends UserEvent {
  final String uid;
  final String name;
  final int age;
  final String gender;

  UpdateUserEvent({
    required this.uid,
    required this.name,
    required this.age,
    required this.gender,
  });
}

class DeleteUserEvent extends UserEvent {
  final String uid;
  DeleteUserEvent(this.uid);
}

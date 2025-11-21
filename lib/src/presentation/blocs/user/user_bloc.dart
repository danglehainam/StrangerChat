import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories_impl/user_repository_impl.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepositoryImpl repo;

  UserBloc(this.repo) : super(UserInitial()) {
    on<LoadUserEvent>(_onLoadUser);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
  }

  Future<void> _onLoadUser(
      LoadUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final data = await repo.getUser(event.uid);

      emit(UserLoaded(
        name: data?["name"] ?? "",
        age: data?["age"] ?? 0,
        gender: data?["gender"] ?? "Nam",
      ));
    } catch (e) {
      emit(UserFailure("Lỗi khi tải dữ liệu: $e"));
    }
  }

  Future<void> _onUpdateUser(
      UpdateUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await repo.updateUser(event.uid, {
        "name": event.name,
        "age": event.age,
        "gender": event.gender,
      });

      emit(UserSuccess("Cập nhật thành công"));
    } catch (e) {
      emit(UserFailure("Lỗi khi cập nhật: $e"));
    }
  }

  Future<void> _onDeleteUser(
      DeleteUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await repo.deleteUser(event.uid);
      emit(UserSuccess("Tài khoản đã bị xóa"));
    } catch (e) {
      emit(UserFailure("Không thể xóa tài khoản: $e"));
    }
  }
}

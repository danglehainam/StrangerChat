import 'package:chat/src/data/repositories_impl/auth_repository_impl.dart';
import 'package:chat/src/presentation/blocs/auth/auth_event.dart';
import 'package:chat/src/presentation/blocs/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final AuthRepositoryImpl repo;

  AuthBloc(this.repo) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<VerifyUserEvent>(_onVerify);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await repo.register(event.email, event.username, event.password);
      if (res['ok'] == true) {
        emit(AuthSuccess(res['message'] ?? "Đăng ký thành công, kiểm tra email"));
      } else {
        emit(AuthError(res['error'] ?? "Lỗi không xác định"));
      }
    } catch (e) {
      emit(AuthError("Lỗi kết nối server: $e"));
    }
  }

  Future<void> _onVerify(VerifyUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await repo.verifyUser(event.email, event.code);
      if (res['ok'] == true) {
        emit(AuthSuccess(res['message'] ?? "Xác thực thành công"));
      } else {
        emit(AuthError(res['error'] ?? "OTP không hợp lệ"));
      }
    } catch (e) {
      emit(AuthError("Lỗi xác thực: $e"));
    }
  }
}
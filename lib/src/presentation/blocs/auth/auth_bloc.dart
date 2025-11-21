import 'package:chat/src/core/services/firebase_auth_service.dart';
import 'package:chat/src/data/datasources/remote/chat_message_remote.dart';
import 'package:chat/src/data/repositories_impl/auth_repository_impl.dart';
import 'package:chat/src/presentation/blocs/auth/auth_event.dart';
import 'package:chat/src/presentation/blocs/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/validator_utils.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final AuthRepositoryImpl repo;

  AuthBloc(this.repo) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<VerifyUserEvent>(_onVerify);
    on<LoginEvent>(_onLogin);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    if (!Validator.isValidEmail(event.email)) {
      emit(AuthError("Email không hợp lệ"));
      return;
    }

    if (!Validator.isValidUsername(event.username)) {
      emit(AuthError("Username phải từ 6-20 ký tự, chỉ chứa chữ và số"));
      return;
    }

    if (!Validator.isValidPassword(event.password)) {
      emit(AuthError("Password phải từ 6-20 ký tự"));
      return;
    }

    if(!Validator.isPasswordMatch(event.password, event.confirmPassword)){
      emit(AuthError("Mật khẩu và xác nhận mật khẩu không khớp"));
      return;
    }

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
        emit(AuthVerifySuccess(res['message'] ?? "Xác thực thành công"));
      } else {
        emit(AuthError(res['error'] ?? "OTP không hợp lệ"));
      }
    } catch (e) {
      emit(AuthError("Lỗi xác thực: $e"));
    }
  }

  Future<void>_onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    ChatMessageRemote chatRemote = ChatMessageRemote();
    if(!Validator.isValidEmail(event.loginId)){
      if(!Validator.isValidUsername(event.loginId)){
        emit(AuthError("Email hoặc username không hợp lệ"));
        return;
      }else{
        if(!Validator.isValidPassword(event.password)) {
          emit(AuthError("Password phải từ 6-20 ký tự"));
          return;
        }else{
          emit(AuthLoading());
          try{
            final res = await repo.loginWithCustomToken(event.loginId, event.password);
            if(res['ok'] == true){
              try{
                final user = await FirebaseAuthService().signInWithCustomToken(res['customToken']);
                final roomId = await chatRemote.getCurrentRoom(user!.uid);
                if(roomId != null){
                  emit(AuthSuccessToChat(roomId));
                }else{
                  emit(AuthSuccessToFind(user.uid));
                }
                print("===== Thông tin người dùng =====");
                print("UID: ${user.uid}");
                print("Email: ${user.email}");
                print("Display Name: ${user.displayName}");
                print("Photo URL: ${user.photoURL}");
                print("Email Verified: ${user.emailVerified}");
                print("Is Anonymous: ${user.isAnonymous}");
                print("Phone Number: ${user.phoneNumber}");
                print("Metadata (Creation Time): ${user.metadata.creationTime}");
                print("Metadata (Last Sign-In Time): ${user.metadata.lastSignInTime}");
                print("Provider Data: ${user.providerData.map((provider) => provider.providerId).toList()}");
                print("================================");
              }catch(e){
                emit(AuthError("Đăng nhập thất bại: $e"));
                print("Đăng nhập thất bại: $e");
                return;
              }
            }else{
              emit(AuthError(res['error'] ?? "Lỗi không xác định"));
            }
          }catch(e){
            emit(AuthError("Lỗi kết nối server: $e"));
          }
        }
      }
      return;
    }else{
      try{
        final user = await FirebaseAuthService().signInWithEmailAndPassword(email: event.loginId, password: event.password);
        final roomId = await chatRemote.getCurrentRoom(user!.uid);
        if(roomId != null){
          emit(AuthSuccessToChat(roomId));
        }else{
          emit(AuthSuccessToFind(user.uid));
        }
        print("===== Thông tin người dùng =====");
        print("UID: ${user.uid}");
        print("Email: ${user.email}");
        print("Display Name: ${user.displayName}");
        print("Photo URL: ${user.photoURL}");
        print("Email Verified: ${user.emailVerified}");
        print("Is Anonymous: ${user.isAnonymous}");
        print("Phone Number: ${user.phoneNumber}");
        print("Metadata (Creation Time): ${user.metadata.creationTime}");
        print("Metadata (Last Sign-In Time): ${user.metadata.lastSignInTime}");
        print("Provider Data: ${user.providerData.map((provider) => provider.providerId).toList()}");
        print("================================");
      }catch(e){
        emit(AuthError("Đăng nhập thất bại: $e"));
        print("Đăng nhập thất bại: $e");
      }
    };
  }
}
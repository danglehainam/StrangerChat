import 'package:chat/src/data/repositories_impl/auth_repository_impl.dart';

class RegisterUsecase{
  final AuthRepositoryImpl repo;
  RegisterUsecase(this.repo);
  Future<void> call(String email, String username, String password){
    return repo.register(email, username, password);
  }
}
import 'package:whatbytes_assignment/features/auth/domain/entities/user_entity.dart';
import 'package:whatbytes_assignment/features/auth/domain/repository/base_auth_repository.dart';

class SignInUseCase {
  final BaseAuthRepository repository;

  SignInUseCase({required this.repository});

  Future<UserEntity> call(String email, String password) {
    return repository.signIn(email, password);
  }
}

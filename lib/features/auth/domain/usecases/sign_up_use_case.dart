import 'package:whatbytes_assignment/features/auth/domain/entities/user_entity.dart';
import 'package:whatbytes_assignment/features/auth/domain/repository/base_auth_repository.dart';

class SignUpUseCase {
  final BaseAuthRepository repository;

  SignUpUseCase({required this.repository});

  Future<UserEntity> call(String name, String email, String password) {
    return repository.signUp(name, email, password);
  }
}

import 'package:whatbytes_assignment/features/auth/data/repository/auth_repository.dart';
import 'package:whatbytes_assignment/features/auth/domain/entities/user_entity.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase({required this.repository});

  Future<UserEntity> call(String name, String email, String password) {
    return repository.signUp(name, email, password);
  }
}

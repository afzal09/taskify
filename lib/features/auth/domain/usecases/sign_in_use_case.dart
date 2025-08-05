import 'package:whatbytes_assignment/features/auth/data/repository/auth_repository.dart';
import 'package:whatbytes_assignment/features/auth/domain/entities/user_entity.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase({required this.repository});

  Future<UserEntity> call(String email, String password) {
    return repository.signIn(email, password);
  }
}

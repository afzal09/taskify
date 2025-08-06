import 'package:whatbytes_assignment/features/auth/domain/entities/user_entity.dart';
import 'package:whatbytes_assignment/features/auth/domain/repository/base_auth_repository.dart';

class GetCurrentUserUseCase {
  final BaseAuthRepository repository;

  GetCurrentUserUseCase({required this.repository});

  Future<UserEntity?> call() async {
    return await repository.getCurrentUser();
  }
}

import 'package:whatbytes_assignment/features/auth/data/repository/auth_repository.dart';
import 'package:whatbytes_assignment/features/auth/domain/entities/user_entity.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase({required this.repository});

  Future<UserEntity?> call() async {
    return await repository.getCurrentUser();
  }
}

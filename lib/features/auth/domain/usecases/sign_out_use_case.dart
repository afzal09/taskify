import 'package:whatbytes_assignment/features/auth/domain/repository/base_auth_repository.dart';

class SignOutUseCase {
  final BaseAuthRepository repository;

  SignOutUseCase({required this.repository});

  Future<void> call() async {
    await repository.signOut(); // Call a method on your repository
  }
}

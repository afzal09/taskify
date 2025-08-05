import 'package:whatbytes_assignment/features/auth/data/repository/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase({required this.repository});

  Future<void> call() async {
    await repository.signOut(); // Call a method on your repository
  }
}

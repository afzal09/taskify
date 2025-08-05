import 'package:whatbytes_assignment/features/auth/data/models/user_model.dart';

abstract class FirebaseAuthDatasource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password, String name);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}
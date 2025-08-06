import 'package:whatbytes_assignment/core/errors/exceptions.dart';
import 'package:whatbytes_assignment/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:whatbytes_assignment/features/auth/domain/entities/user_entity.dart';
import 'package:whatbytes_assignment/features/auth/domain/repository/base_auth_repository.dart';

class AuthRepository implements BaseAuthRepository {
  final FirebaseAuthDatasource remoteDataSource;

  AuthRepository({required this.remoteDataSource});

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      return userModel;
    } on ServerException {
      rethrow; // Re-throw our specific ServerException
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserEntity> signIn(String email, String password) async {
    try {
      final userModel = await remoteDataSource.signIn(email, password);
      return userModel;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await remoteDataSource.signOut();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserEntity> signUp(String email, String password, String name) async {
    try {
      final userModel = await remoteDataSource.signUp(email, password, name);
      return userModel;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return remoteDataSource.authStateChanges;
  }
}

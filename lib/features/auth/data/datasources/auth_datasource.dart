import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatbytes_assignment/core/errors/exceptions.dart';
import 'package:whatbytes_assignment/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:whatbytes_assignment/features/auth/data/models/user_model.dart';

class AuthDatasource implements FirebaseAuthDatasource{
final FirebaseAuth firebaseAuth;

  AuthDatasource(this.firebaseAuth);

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw const ServerException(message: 'Sign-in failed: User is null.');
      }
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUp(String email, String password, String name) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw const ServerException(message: 'Sign-up failed: User is null.');
      }
      // Update user display name after creation
      await userCredential.user!.updateDisplayName(name);
      // Reload user to get updated displayName. Important!
      await userCredential.user!.reload();
      final updatedUser = firebaseAuth.currentUser;
      if (updatedUser == null) {
        throw const ServerException(
          message:
              'Sign-up failed: Could not retrieve updated user after name update.',
        );
      }
      return UserModel.fromFirebaseUser(updatedUser);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Stream<UserModel?> get authStateChanges {
        return firebaseAuth.authStateChanges().map(
      (user) => user != null ? UserModel.fromFirebaseUser(user) : null,
    );
  }
  
  _mapFirebaseAuthException(FirebaseAuthException e) {
        switch (e.code) {
      case 'user-not-found':
        return const UserNotFoundException();
      case 'wrong-password':
        return const WrongPasswordException();
      case 'invalid-email':
      case 'user-disabled':
      case 'invalid-credential':
        return const InvalidCredentialsException();
      case 'email-already-in-use':
        return const EmailAlreadyInUseException();
      case 'weak-password':
        return const WeakPasswordException();
      default:
        return ServerException(
          message: e.message ?? 'An unknown Firebase Auth error occurred.',
        );
    }
  } 
}
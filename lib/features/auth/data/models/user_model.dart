import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatbytes_assignment/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity{
    const UserModel({required super.uid, required super.name, required super.email});
    
    factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? 'no-email@example.com',
      name: user.displayName ?? user.email?.split('@').first ?? 'New User',
    );
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'name': name};
  }
}
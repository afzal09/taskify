import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
    final String uid;
    final String name;
    final String email;
    const UserEntity({required this.uid,required this.name,required this.email});
    @override
    List<Object?> get props => throw UnimplementedError();  
}
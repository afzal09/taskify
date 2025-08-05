
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

// Event to check the current auth status when the app starts or resumes
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

// Event triggered by the authStateChanges stream
class AuthUserChanged extends AuthEvent {
  final String?
  uid; // Only need UID to indicate a change; bloc can then fetch full user if needed
  const AuthUserChanged({this.uid});

  @override
  List<Object?> get props => [uid];
}

// --- NEW EVENT ---
final class AuthErrorEvent extends AuthEvent {
  final String message;
  const AuthErrorEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

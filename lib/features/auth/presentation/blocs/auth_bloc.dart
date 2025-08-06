import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:whatbytes_assignment/core/errors/exceptions.dart';
import 'package:whatbytes_assignment/features/auth/domain/entities/user_entity.dart';
import 'package:whatbytes_assignment/features/auth/domain/repository/base_auth_repository.dart';
import 'package:whatbytes_assignment/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:whatbytes_assignment/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:whatbytes_assignment/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:whatbytes_assignment/features/auth/domain/usecases/sign_up_use_case.dart';


part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final BaseAuthRepository authRepository; // To listen to auth state changes

  late StreamSubscription<UserEntity?> _userSubscription;

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.authRepository, // Pass repository here
  }) : super(const AuthInitial()) {
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthUserChanged>(_onAuthUserChanged);
    on<AuthErrorEvent>(_onAuthErrorEvent); // --- NEW HANDLER ---

    // Listen to Firebase auth state changes via our repository
    _userSubscription = authRepository.authStateChanges.listen(
      (user) {
        add(
          AuthUserChanged(uid: user?.uid),
        ); // Dispatch a new event when Firebase auth state changes
      },
      onError: (error) {
        add(
          AuthErrorEvent(
            message: 'Authentication stream error: ${error.toString()}.',
          ),
        );
      },
    );
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await signInUseCase(event.email, event.password);
      emit(AuthAuthenticated(user: user));
    } on ServerException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      emit(
        AuthError(
          message:
              'An unexpected error occurred during sign-in: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await signUpUseCase(event.email, event.password, event.name);
      emit(AuthAuthenticated(user: user));
    } on ServerException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      emit(
        AuthError(
          message:
              'An unexpected error occurred during sign-up: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await signOutUseCase(); // No params
      emit(const AuthUnauthenticated());
    } on ServerException catch (e) {
      emit(AuthError(message: e.message));
    } catch (e) {
      emit(
        AuthError(
          message:
              'An unexpected error occurred during sign-out: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await getCurrentUserUseCase(); // No params
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } on ServerException catch (e) {
      // If there's an error checking, assume unauthenticated or show specific error
      emit(AuthError(message: e.message));
    } catch (e) {
      emit(
        AuthError(
          message:
              'An unexpected error occurred during auth check: ${e.toString()}',
        ),
      );
    }
  }

  // Handle changes from the Firebase auth state stream
  Future<void> _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.uid != null) {
      // User signed in or re-authenticated, refresh user data if needed
      try {
        final user = await getCurrentUserUseCase(); // No params
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(const AuthUnauthenticated());
        }
      } on ServerException catch (e) {
        // If there's an error getting user details, consider them unauthenticated or handle appropriately
        emit(AuthError(message: e.message));
      } catch (e) {
        emit(
          AuthError(
            message:
                'An unexpected error occurred during user change check: ${e.toString()}',
          ),
        );
      }
    } else {
      // User signed out
      emit(const AuthUnauthenticated());
    }
  }

  void _onAuthErrorEvent(AuthErrorEvent event, Emitter<AuthState> emit) {
    emit(AuthError(message: event.message));
  }

  @override
  Future<void> close() {
    _userSubscription
        .cancel(); // Cancel the subscription when the Bloc is closed
    return super.close();
  }
}

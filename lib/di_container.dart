import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:whatbytes_assignment/features/auth/data/datasources/auth_datasource.dart';
import 'package:whatbytes_assignment/features/auth/data/repository/auth_repository.dart';
import 'package:whatbytes_assignment/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:whatbytes_assignment/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:whatbytes_assignment/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:whatbytes_assignment/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:whatbytes_assignment/features/auth/presentation/blocs/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init()async {
  // Auth Feature
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      signOutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      authRepository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(repository: sl()));
  sl.registerLazySingleton(() => SignUpUseCase(repository: sl()));
  sl.registerLazySingleton(() => SignOutUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(remoteDataSource: sl()),
  );

  // Data source
  sl.registerLazySingleton<AuthDatasource>(
    () => AuthDatasource(sl()),
  );
}

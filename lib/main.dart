import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatbytes_assignment/di_container.dart' as di;
import 'package:whatbytes_assignment/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:whatbytes_assignment/features/auth/presentation/screens/welcome.dart';
import 'package:whatbytes_assignment/features/tasks/presentation/blocs/task_bloc.dart';
import 'package:whatbytes_assignment/features/tasks/presentation/screens/task_screen.dart';
import 'package:whatbytes_assignment/firebase_options.dart';
import 'package:whatbytes_assignment/src/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider<TaskBloc>(create: (context) => di.sl<TaskBloc>()),
      ],
      child: MaterialApp(
        title: 'Task Planner UI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return TaskScreen(userId: state.user.uid);
            } else if (state is AuthUnauthenticated) {
              return const WelcomeScreen();
              // return TaskScreen(userId: "I6VQffvZHIb8ZRxtwm2stBOOdjL2");
            } else if (state is AuthLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}

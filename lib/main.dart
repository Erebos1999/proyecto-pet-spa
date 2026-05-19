import 'package:cerberus_pet_spa/modules/admin/presentation/screens/create_employee_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:go_router/go_router.dart';

import 'firebase_options.dart';

import 'modules/auth/data/datasource/auth_firestore_datasource.dart';
import 'modules/auth/data/datasource/auth_remote_datasource.dart';
import 'modules/auth/data/repositories/auth_repository_impl.dart';
import 'modules/auth/presentation/bloc/auth_bloc.dart';

import 'modules/auth/presentation/screens/login_screen.dart';
import 'modules/auth/presentation/screens/register_screen.dart';

import 'modules/home/presentation/screens/admin_home_screen.dart';
import 'modules/home/presentation/screens/client_home_screen.dart';
import 'modules/home/presentation/screens/groomer_home_screen.dart';
import 'modules/home/presentation/screens/reception_home_screen.dart';

import 'modules/admin/presentation/screens/admin_totp_setup_screen.dart';
import 'modules/admin/presentation/screens/admin_totp_verify_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authRepository = AuthRepositoryImpl(
    AuthRemoteDataSource(),
    AuthFirestoreDatasource(),
  );

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/login',

      routes: [
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),

        GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),

        GoRoute(path: '/admin', builder: (_, __) => const AdminHomeScreen()),

        GoRoute(path: '/client', builder: (_, __) => const ClientHomeScreen()),

        GoRoute(
          path: '/groomer',
          builder: (_, __) => const GroomerHomeScreen(),
        ),

        GoRoute(
          path: '/recepcion',
          builder: (_, __) => const ReceptionHomeScreen(),
        ),

        GoRoute(
          path: '/totp-setup',
          builder: (_, __) => const AdminTotpSetupScreen(),
        ),

        GoRoute(
          path: '/totp-verify/:secret',
          builder: (context, state) {
            final secret = state.pathParameters['secret']!;

            return AdminTotpVerifyScreen(secret: secret);
          },
        ),
        GoRoute(
          path: '/create-employee',
          builder: (_, __) => const CreateEmployeeScreen(),
        ),
      ],
    );

    return BlocProvider(
      create: (_) => AuthBloc(authRepository),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/router/app_router.dart';

import '../modules/auth/data/datasource/auth_firestore_datasource.dart';
import '../modules/auth/data/datasource/auth_remote_datasource.dart';
import '../modules/auth/data/repositories/auth_repository_impl.dart';

import '../modules/auth/presentation/bloc/auth_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepositoryImpl(
      AuthRemoteDataSource(),
      AuthFirestoreDatasource(),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(authRepository),
        ),
      ],

      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}
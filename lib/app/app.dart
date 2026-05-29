import 'package:cerberus_pet_spa/modules/inventory/data/datasource/product_firestore_datasource.dart';
import 'package:cerberus_pet_spa/modules/inventory/data/repositories/product_repository_impl.dart';
import 'package:cerberus_pet_spa/modules/inventory/presentation/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/router/app_router.dart';

import '../modules/auth/data/datasource/auth_firestore_datasource.dart';
import '../modules/auth/data/datasource/auth_remote_datasource.dart';
import '../modules/auth/data/repositories/auth_repository_impl.dart';

import '../modules/auth/presentation/bloc/auth_bloc.dart';

import '../modules/pets/data/datasource/pet_firestore_datasource.dart';
import '../modules/pets/data/repositories/pet_repository_impl.dart';
import '../modules/pets/presentation/bloc/pet_bloc.dart';

import '../modules/appointments/data/datasource/appointment_firestore_datasource.dart';
import '../modules/appointments/data/repositories/appointment_repository_impl.dart';
import '../modules/appointments/presentation/bloc/appointment_bloc.dart';

import '../modules/services/data/datasource/service_firestore_datasource.dart';
import '../modules/services/data/repositories/service_repository_impl.dart';
import '../modules/services/presentation/bloc/service_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepositoryImpl(
      AuthRemoteDataSource(),
      AuthFirestoreDatasource(),
    );

    final petRepository = PetRepositoryImpl(PetFirestoreDatasource());

    final appointmentRepository = AppointmentRepositoryImpl(
      AppointmentFirestoreDatasource(),
    );

    final serviceRepository = ServiceRepositoryImpl(
      ServiceFirestoreDatasource(),
    );
    final productRepository = ProductRepositoryImpl(
      ProductFirestoreDatasource(),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository)),

        BlocProvider(create: (_) => PetBloc(petRepository)),

        BlocProvider(create: (_) => AppointmentBloc(appointmentRepository)),
        BlocProvider(create: (_) => ProductBloc()..add(LoadProductsEvent())),

        BlocProvider(
          create: (_) =>
              ServiceBloc(serviceRepository)..add(LoadServicesEvent()),
        ),
      ],

      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}

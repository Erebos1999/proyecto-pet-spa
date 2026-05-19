import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/logout_listener.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LogoutListener(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Administrador'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                print('CLICK LOGOUT ADMIN');

                context.read<AuthBloc>().add(
                  LogoutEvent(),
                );

                context.go('/login');
              },
            ),
          ],
        ),

        body: Center(
          child: ElevatedButton(
            onPressed: () {
              context.push('/create-employee');
            },
            child: const Text(
              'Crear Empleado',
            ),
          ),
        ),
      ),
    );
  }
}
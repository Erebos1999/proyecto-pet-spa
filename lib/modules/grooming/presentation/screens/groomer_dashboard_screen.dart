import 'package:cerberus_pet_spa/modules/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/logout_listener.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class GroomerDashboardScreen extends StatelessWidget {
  const GroomerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LogoutListener(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Groomer'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                context.read<AuthBloc>().add(LogoutEvent());

                context.go('/login');
              },
            ),
          ],
        ),

        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.content_cut,
                    size: 90,
                    color: Color(0xff66c7d8),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Panel Groomer',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Gestiona baños, cortes y servicios asignados.',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: const [
                          Icon(
                            Icons.list_alt,
                            size: 60,
                            color: Color(0xff66c7d8),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Próximamente: Lista de Servicios',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

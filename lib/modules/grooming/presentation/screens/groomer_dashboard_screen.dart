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
        backgroundColor: const Color(0xfff5f7fa),

        appBar: AppBar(
          title: const Text('Mi Agenda Groomer'),

          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutEvent());

                context.go('/login');
              },
            ),
          ],
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  'Servicios de Hoy',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Gestiona tus servicios y checklist',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff66c7d8),
                        Color(0xff4ea9bb),
                      ],
                    ),

                    borderRadius: BorderRadius.circular(25),
                  ),

                  child: Row(
                    children: [
                      const Icon(
                        Icons.pets,
                        color: Colors.white,
                        size: 60,
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '8 citas programadas',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              '2 pendientes de finalizar',
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                const Text(
                  'Agenda',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                _appointmentCard(
                  pet: 'Max',
                  owner: 'Juan Pérez',
                  service: 'Baño + Corte',
                  hour: '10:00',
                  status: 'En proceso',
                ),

                _appointmentCard(
                  pet: 'Luna',
                  owner: 'Carla Flores',
                  service: 'Baño Premium',
                  hour: '11:30',
                  status: 'Pendiente',
                ),

                _appointmentCard(
                  pet: 'Rocky',
                  owner: 'Luis Vargas',
                  service: 'Corte Higiénico',
                  hour: '14:00',
                  status: 'Finalizado',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _appointmentCard({
    required String pet,
    required String owner,
    required String service,
    required String hour,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xff66c7d8),
                child: Icon(
                  Icons.pets,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),

                    Text(owner),
                  ],
                ),
              ),

              Text(
                hour,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            service,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Chip(
                label: Text(status),
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: () {},
                child: const Text('Abrir ficha'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
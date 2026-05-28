import 'package:cerberus_pet_spa/modules/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/logout_listener.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class ReceptionDashboardScreen extends StatelessWidget {
  const ReceptionDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LogoutListener(
      child: Scaffold(
        backgroundColor: const Color(0xfff5f7fa),

        appBar: AppBar(
          title: const Text('Recepción'),

          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(
                      LogoutEvent(),
                    );

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
                  'Centro de Recepción',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Gestiona clientes, agenda y pagos',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: _smallCard(
                        title: 'Pendientes',
                        value: '12',
                        icon: Icons.schedule,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: _smallCard(
                        title: 'Pagos',
                        value: '7',
                        icon: Icons.payments,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                const Text(
                  'Acciones rápidas',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,

                  children: [
                    _actionCard(
                      icon: Icons.calendar_month,
                      title: 'Agenda',
                    ),

                    _actionCard(
                      icon: Icons.people,
                      title: 'Clientes',
                    ),

                    _actionCard(
                      icon: Icons.payments,
                      title: 'Caja',
                    ),

                    _actionCard(
                      icon: Icons.pets,
                      title: 'Mascotas',
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                const Text(
                  'Citas recientes',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                _appointmentTile(
                  pet: 'Max',
                  owner: 'Juan Pérez',
                  status: 'Confirmada',
                ),

                _appointmentTile(
                  pet: 'Luna',
                  owner: 'Carla Flores',
                  status: 'Pendiente',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _smallCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        children: [
          Icon(
            icon,
            size: 35,
            color: const Color(0xff66c7d8),
          ),

          const SizedBox(height: 15),

          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(title),
        ],
      ),
    );
  }

  static Widget _actionCard({
    required IconData icon,
    required String title,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 45,
            color: const Color(0xff66c7d8),
          ),

          const SizedBox(height: 15),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _appointmentTile({
    required String pet,
    required String owner,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xff66c7d8),
          child: Icon(
            Icons.pets,
            color: Colors.white,
          ),
        ),
        title: Text(pet),
        subtitle: Text(owner),
        trailing: Chip(
          label: Text(status),
        ),
      ),
    );
  }
}
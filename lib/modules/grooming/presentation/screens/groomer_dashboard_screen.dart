import 'package:cerberus_pet_spa/modules/auth/presentation/bloc/auth_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/logout_listener.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class GroomerDashboardScreen extends StatelessWidget {
  const GroomerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final userName =
        user?.displayName ?? user?.email?.split('@').first ?? 'Groomer';

    return LogoutListener(
      child: Scaffold(
        backgroundColor: const Color(0xfff5f7fa),

        appBar: AppBar(
          title: const Text('Panel Groomer'),

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
                Text(
                  'Bienvenido $userName',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Gestiona tus servicios, checklist y estado de grooming.',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),

                const SizedBox(height: 30),

                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),

                    gradient: const LinearGradient(
                      colors: [Color(0xff66c7d8), Color(0xff4ea9bb)],
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: const [
                      Icon(Icons.content_cut, size: 60, color: Colors.white),

                      SizedBox(height: 20),

                      Text(
                        'Agenda Grooming',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      Text(
                        'Visualiza tus citas del día y completa las fichas técnicas.',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                const Text(
                  'Módulos',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                _menuCard(
                  title: 'Mi Agenda',
                  subtitle: 'Visualiza únicamente tus servicios asignados',
                  icon: Icons.calendar_month,
                  buttonText: 'Abrir Agenda',
                  onTap: () {
                    context.push('/groomer-schedule');
                  },
                ),

                const SizedBox(height: 18),

                _menuCard(
                  title: 'Control de Insumos',
                  subtitle:
                      'Registra shampoos, perfumes y materiales utilizados',
                  icon: Icons.inventory_2_outlined,
                  buttonText: 'Gestionar Insumos',
                  onTap: () {},
                ),

                const SizedBox(height: 18),

                _menuCard(
                  title: 'Pagos',
                  subtitle: 'Consulta pagos registrados y estado de cobros',
                  icon: Icons.payments_outlined,
                  buttonText: 'Ver Pagos',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _menuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: const Color(0xff66c7d8).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Icon(icon, color: const Color(0xff66c7d8), size: 34),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton.icon(
              onPressed: onTap,

              icon: const Icon(Icons.arrow_forward),

              label: Text(buttonText),

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff66c7d8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

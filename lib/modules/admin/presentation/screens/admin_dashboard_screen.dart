import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/logout_listener.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LogoutListener(
      child: Scaffold(
        backgroundColor: const Color(0xfff5f7fa),

        appBar: AppBar(
          elevation: 0,
          title: const Text('Cerberus Admin'),

          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {},
            ),

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
                  'Dashboard Administrativo',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Control general del Pet Spa',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        title: 'Ventas',
                        value: 'Bs 4.250',
                        icon: Icons.attach_money,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: _statCard(
                        title: 'Citas',
                        value: '28',
                        icon: Icons.calendar_month,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        title: 'Clientes',
                        value: '154',
                        icon: Icons.people,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: _statCard(
                        title: 'Alertas',
                        value: '3',
                        icon: Icons.warning_amber,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                const Text(
                  'Gestión',
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
                  childAspectRatio: 1.05,

                  children: [
                    _menuCard(
                      context,
                      title: 'Empleados',
                      icon: Icons.badge,
                      route: '/create-employee',
                    ),

                    _menuCard(
                      context,
                      title: 'Servicios',
                      icon: Icons.spa,
                      route: '/services',
                    ),

                    _menuCard(
                      context,
                      title: 'Agenda',
                      icon: Icons.calendar_month,
                      route: '/appointments',
                    ),

                    _menuCard(
                      context,
                      title: 'Inventario',
                      icon: Icons.inventory_2,
                    ),

                    _menuCard(
                      context,
                      title: 'Reportes',
                      icon: Icons.bar_chart,
                    ),

                    _menuCard(
                      context,
                      title: 'Configuración',
                      icon: Icons.settings,
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                Container(
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Alertas del sistema',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 20),

                      ListTile(
                        leading: Icon(
                          Icons.warning,
                          color: Colors.orange,
                        ),
                        title: Text('Stock bajo en shampoo premium'),
                        subtitle: Text('Quedan 2 unidades'),
                      ),

                      Divider(),

                      ListTile(
                        leading: Icon(
                          Icons.notifications_active,
                          color: Colors.red,
                        ),
                        title: Text('5 citas pendientes de aprobación'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _statCard({
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xff66c7d8),
            size: 35,
          ),

          const SizedBox(height: 20),

          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _menuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    String? route,
  }) {
    return GestureDetector(
      onTap: () {
        if (route != null) {
          context.push(route);
        }
      },

      child: Container(
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

            const SizedBox(height: 20),

            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
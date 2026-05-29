import 'package:cerberus_pet_spa/modules/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/logout_listener.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class CustomerDashboardScreen extends StatelessWidget {
  const CustomerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LogoutListener(
      child: Scaffold(
        backgroundColor: const Color(0xfff5f7fa),

        appBar: AppBar(
          title: const Text('Cerberus Pet Spa'),

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

            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 900,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Container(
                      padding:
                          const EdgeInsets.all(
                        28,
                      ),

                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                          30,
                        ),

                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(0xff66c7d8),
                            Color(0xff4ea9bb),
                          ],
                        ),
                      ),

                      child: Row(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.all(
                              18,
                            ),

                            decoration:
                                BoxDecoration(
                              color: Colors.white
                                  .withOpacity(
                                0.2,
                              ),

                              shape:
                                  BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.pets,
                              color:
                                  Colors.white,
                              size: 50,
                            ),
                          ),

                          const SizedBox(
                            width: 20,
                          ),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [
                                Text(
                                  'Bienvenido a Cerberus Pet Spa',
                                  style:
                                      TextStyle(
                                    color: Colors
                                        .white,
                                    fontSize:
                                        26,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                SizedBox(
                                  height: 10,
                                ),

                                Text(
                                  'Gestiona tus mascotas, citas y servicios premium desde un solo lugar.',
                                  style:
                                      TextStyle(
                                    color: Colors
                                        .white70,
                                    fontSize:
                                        15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 35,
                    ),

                    const Text(
                      'Resumen',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            title:
                                'Mascotas',
                            value: '3',
                            icon:
                                Icons.pets,
                          ),
                        ),

                        const SizedBox(
                          width: 15,
                        ),

                        Expanded(
                          child: _statCard(
                            title:
                                'Citas',
                            value: '2',
                            icon: Icons
                                .calendar_month,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 35,
                    ),

                    const Text(
                      'Acciones rápidas',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    GridView.count(
                      crossAxisCount: 2,

                      shrinkWrap: true,

                      physics:
                          const NeverScrollableScrollPhysics(),

                      crossAxisSpacing:
                          16,

                      mainAxisSpacing:
                          16,

                      childAspectRatio:
                          1.1,

                      children: [
                        _menuCard(
                          context,
                          title:
                              'Mis Mascotas',
                          subtitle:
                              'Gestiona perfiles de tus mascotas',
                          icon:
                              Icons.pets,
                          route:
                              '/my-pets',
                        ),

                        _menuCard(
                          context,
                          title:
                              'Agendar Cita',
                          subtitle:
                              'Reserva grooming y baño',
                          icon: Icons
                              .calendar_month,
                          route:
                              '/appointments',
                        ),

                        _menuCard(
                          context,
                          title:
                              'Historial',
                          subtitle:
                              'Servicios anteriores',
                          icon:
                              Icons.history,
                        ),

                        _menuCard(
                          context,
                          title:
                              'Pagos',
                          subtitle:
                              'QR, efectivo y transferencias',
                          icon:
                              Icons.payments,
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 35,
                    ),

                    Container(
                      padding:
                          const EdgeInsets.all(
                        24,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                          25,
                        ),
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          const Text(
                            'Próxima cita',
                            style:
                                TextStyle(
                              fontSize:
                                  22,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets
                                        .all(
                                  15,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color: const Color(
                                    0xff66c7d8,
                                  ).withOpacity(
                                    0.15,
                                  ),

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    18,
                                  ),
                                ),

                                child:
                                    const Icon(
                                  Icons
                                      .content_cut,
                                  color: Color(
                                    0xff66c7d8,
                                  ),
                                  size: 40,
                                ),
                              ),

                              const SizedBox(
                                width: 18,
                              ),

                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [
                                    Text(
                                      'Baño Premium + Corte',
                                      style:
                                          TextStyle(
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                        fontSize:
                                            18,
                                      ),
                                    ),

                                    SizedBox(
                                      height:
                                          6,
                                    ),

                                    Text(
                                      'Viernes 14:00',
                                    ),

                                    SizedBox(
                                      height:
                                          4,
                                    ),

                                    Text(
                                      'Mascota: Max',
                                      style:
                                          TextStyle(
                                        color: Colors
                                            .grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Chip(
                                label:
                                    const Text(
                                  'Confirmada',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
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
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          24,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Icon(
            icon,
            size: 36,
            color:
                const Color(0xff66c7d8),
          ),

          const SizedBox(
            height: 18,
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 5,
          ),

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
    required String subtitle,
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
        padding:
            const EdgeInsets.all(22),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(
            26,
          ),
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Container(
              padding:
                  const EdgeInsets.all(
                14,
              ),

              decoration:
                  BoxDecoration(
                color: const Color(
                  0xff66c7d8,
                ).withOpacity(0.12),

                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),

              child: Icon(
                icon,
                color: const Color(
                  0xff66c7d8,
                ),
                size: 34,
              ),
            ),

            const Spacer(),

            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
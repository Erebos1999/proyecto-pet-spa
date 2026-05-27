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
        appBar: AppBar(
          title: const Text('Cliente'),
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
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 700,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.pets,
                      size: 90,
                      color: Color(0xff66c7d8),
                    ),
          
                    const SizedBox(height: 20),
          
                    const Text(
                      'Bienvenido a Pet Spa',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
          
                    const SizedBox(height: 10),
          
                    const Text(
                      'Agenda baños, peluquería y cuidado premium para tu mascota.',
                      textAlign:
                          TextAlign.center,
                    ),
          
                    const SizedBox(height: 40),
          
                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(
                          30,
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.pets,
                              size: 60,
                              color: Color(
                                0xff66c7d8,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'Gestiona tus mascotas',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width:
                                  double.infinity,
                              child:
                                  ElevatedButton.icon(
                                onPressed: () {
                                  context.push(
                                    '/my-pets',
                                  );
                                },
                                icon:
                                    const Icon(
                                  Icons.pets,
                                ),
                                label:
                                    const Text(
                                  'Mis Mascotas',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
          
                    const SizedBox(height: 25),
          
                    Card(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(
                          30,
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons
                                  .calendar_month,
                              size: 60,
                              color: Color(
                                0xff66c7d8,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'Reservas Online',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width:
                                  double.infinity,
                              child:
                                  ElevatedButton.icon(
                                onPressed: () {
                                  context.push(
                                    '/appointments',
                                  );
                                },
                                icon:
                                    const Icon(
                                  Icons.add,
                                ),
                                label:
                                    const Text(
                                  'Agendar Cita',
                                ),
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
      ),
    );
  }
}
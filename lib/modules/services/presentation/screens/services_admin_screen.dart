import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/service_bloc.dart';

class ServicesAdminScreen
    extends StatefulWidget {
  const ServicesAdminScreen({
    super.key,
  });

  @override
  State<ServicesAdminScreen>
      createState() =>
          _ServicesAdminScreenState();
}

class _ServicesAdminScreenState
    extends State<ServicesAdminScreen> {
  @override
  void initState() {
    super.initState();

    context.read<ServiceBloc>().add(
          LoadServicesEvent(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Servicios'),
      ),

      floatingActionButton:
          FloatingActionButton(
        backgroundColor:
            const Color(0xff66c7d8),

        onPressed: () {
          context.push(
            '/create-service',
          );
        },

        child: const Icon(
          Icons.add,
        ),
      ),

      body: BlocBuilder<
          ServiceBloc,
          ServiceState>(
        builder: (context, state) {
          if (state is ServiceLoading) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (state is ServiceLoaded) {
            if (state.services.isEmpty) {
              return const Center(
                child: Text(
                  'No hay servicios registrados',
                ),
              );
            }

            return ListView.builder(
              padding:
                  const EdgeInsets.all(16),

              itemCount:
                  state.services.length,

              itemBuilder: (_, index) {
                final service =
                    state.services[index];

                return Card(
                  margin:
                      const EdgeInsets.only(
                    bottom: 16,
                  ),

                  child: Padding(
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [
                        Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets
                                      .all(10),

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
                                  12,
                                ),
                              ),

                              child:
                                  const Icon(
                                Icons.spa,
                                color: Color(
                                  0xff66c7d8,
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 15,
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [
                                  Text(
                                    service.name,

                                    style:
                                        const TextStyle(
                                      fontSize:
                                          18,

                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 4,
                                  ),

                                  Text(
                                    service
                                        .description,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets
                                        .all(14),

                                decoration:
                                    BoxDecoration(
                                  color:
                                      Colors.grey
                                          .shade100,

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    14,
                                  ),
                                ),

                                child: Column(
                                  children: [
                                    const Text(
                                      'Precio',
                                    ),

                                    const SizedBox(
                                      height: 5,
                                    ),

                                    Text(
                                      'Bs ${service.price}',

                                      style:
                                          const TextStyle(
                                        fontSize:
                                            18,

                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 15,
                            ),

                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets
                                        .all(14),

                                decoration:
                                    BoxDecoration(
                                  color:
                                      Colors.grey
                                          .shade100,

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    14,
                                  ),
                                ),

                                child: Column(
                                  children: [
                                    const Text(
                                      'Duración',
                                    ),

                                    const SizedBox(
                                      height: 5,
                                    ),

                                    Text(
                                      '${service.duration} min',

                                      style:
                                          const TextStyle(
                                        fontSize:
                                            18,

                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (state is ServiceError) {
            return Center(
              child:
                  Text(state.message),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
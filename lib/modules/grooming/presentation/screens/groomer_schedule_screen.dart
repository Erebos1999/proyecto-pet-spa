import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../appointments/data/datasource/appointment_firestore_datasource.dart';
import '../../../appointments/domain/entities/appointment_entity.dart';

class GroomerScheduleScreen extends StatefulWidget {
  const GroomerScheduleScreen({super.key});

  @override
  State<GroomerScheduleScreen> createState() =>
      _GroomerScheduleScreenState();
}

class _GroomerScheduleScreenState
    extends State<GroomerScheduleScreen> {
  final datasource =
      AppointmentFirestoreDatasource();

  List<AppointmentEntity> appointments = [];

  bool loading = true;

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    loadAppointments();
  }

  Future<void> loadAppointments() async {
    try {
      setState(() {
        loading = true;
      });

      final userId =
          FirebaseAuth.instance.currentUser!.uid;

      final data =
          await datasource.getAppointmentsByDate(
        selectedDate,
      );

      appointments = data
          .where(
            (e) => e.groomerId == userId,
          )
          .toList();

      appointments.sort(
        (a, b) =>
            a.startTime.compareTo(
          b.startTime,
        ),
      );

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });

      debugPrint(e.toString());
    }
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate:
          DateTime.now().subtract(
        const Duration(days: 30),
      ),
      lastDate:
          DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (date == null) return;

    setState(() {
      selectedDate = date;
    });

    loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xfff5f7fa),

      appBar: AppBar(
        title: const Text(
          'Mi Agenda',
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.all(20),

            child: InkWell(
              onTap: pickDate,

              borderRadius:
                  BorderRadius.circular(20),

              child: Container(
                padding:
                    const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),

                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color:
                          Color(0xff66c7d8),
                    ),

                    const SizedBox(
                      width: 15,
                    ),

                    Expanded(
                      child: Text(
                        DateFormat(
                          'dd/MM/yyyy',
                        ).format(
                          selectedDate,
                        ),

                        style:
                            const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    const Icon(
                      Icons.arrow_drop_down,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: loading
                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )
                : appointments.isEmpty
                    ? const Center(
                        child: Text(
                          'No tienes citas',
                        ),
                      )
                    : ListView.builder(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),

                        itemCount:
                            appointments.length,

                        itemBuilder:
                            (_, i) {
                          final a =
                              appointments[i];

                          return Container(
                            margin:
                                const EdgeInsets.only(
                              bottom: 18,
                            ),

                            child: Material(
                              color:
                                  Colors.white,

                              borderRadius:
                                  BorderRadius.circular(
                                24,
                              ),

                              child: InkWell(
                                borderRadius:
                                    BorderRadius.circular(
                                  24,
                                ),

                                onTap: () {
                                  context.push(
                                    '/appointment-details',
                                    extra: a,
                                  );
                                },

                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(
                                    22,
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
                                                const EdgeInsets.all(
                                              14,
                                            ),

                                            decoration:
                                                BoxDecoration(
                                              color:
                                                  const Color(
                                                0xff66c7d8,
                                              ).withOpacity(
                                                0.12,
                                              ),

                                              borderRadius:
                                                  BorderRadius.circular(
                                                18,
                                              ),
                                            ),

                                            child:
                                                const Icon(
                                              Icons.pets,
                                              color: Color(
                                                0xff66c7d8,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(
                                            width: 15,
                                          ),

                                          Expanded(
                                            child:
                                                Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,

                                              children: [
                                                Text(
                                                  a.petName,

                                                  style:
                                                      const TextStyle(
                                                    fontSize:
                                                        20,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),

                                                const SizedBox(
                                                  height:
                                                      5,
                                                ),

                                                Text(
                                                  a.ownerName,
                                                ),
                                              ],
                                            ),
                                          ),

                                          Text(
                                            DateFormat(
                                              'HH:mm',
                                            ).format(
                                              a.startTime,
                                            ),

                                            style:
                                                const TextStyle(
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 20,
                                      ),

                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,

                                        children:
                                            a.services.map(
                                          (e) {
                                            return Chip(
                                              label:
                                                  Text(
                                                e['name'],
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      ),

                                      const SizedBox(
                                        height: 20,
                                      ),

                                      Row(
                                        children: [
                                          Chip(
                                            label:
                                                Text(
                                              a.status,
                                            ),
                                          ),

                                          const Spacer(),

                                          ElevatedButton(
                                            onPressed:
                                                () {
                                              context.push(
                                                '/appointment-details',
                                                extra:
                                                    a,
                                              );
                                            },

                                            child:
                                                const Text(
                                              'Ver detalle',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../bloc/appointment_bloc.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    context.read<AppointmentBloc>().add(
      LoadAppointmentsByDateEvent(selectedDate),
    );
  }

  Future<void> changeDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    setState(() {
      selectedDate = date;
    });

    context.read<AppointmentBloc>().add(LoadAppointmentsByDateEvent(date));
  }

  Color statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;

      case 'in_progress':
        return Colors.blue;

      case 'completed':
        return Colors.green;

      case 'cancelled':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f7fb),

      appBar: AppBar(
        title: const Text('Agenda Grooming'),

        actions: [
          IconButton(
            onPressed: changeDate,
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff66c7d8),

        onPressed: () {
          context.push('/create-appointment');
        },

        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,

            margin: const EdgeInsets.all(20),

            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),

            child: Column(
              children: [
                const Text(
                  'Fecha seleccionada',
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 8),

                Text(
                  DateFormat('dd/MM/yyyy').format(selectedDate),

                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: BlocBuilder<AppointmentBloc, AppointmentState>(
              builder: (context, state) {
                if (state is AppointmentLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AppointmentLoaded) {
                  if (state.appointments.isEmpty) {
                    return const Center(
                      child: Text('No hay citas para este día'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    itemCount: state.appointments.length,

                    itemBuilder: (_, i) {
                      final a = state.appointments[i];

                      return GestureDetector(
                        onTap: () {
                          context.push('/appointment-details', extra: a);
                        },

                        child: Container(
                          margin: const EdgeInsets.only(bottom: 18),

                          padding: const EdgeInsets.all(18),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),

                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 90,

                                decoration: BoxDecoration(
                                  color: statusColor(a.status),

                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      a.petName,

                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(a.groomerName),

                                    const SizedBox(height: 8),

                                    Text(
                                      '${DateFormat('HH:mm').format(a.startTime)} - ${DateFormat('HH:mm').format(a.endTime)}',
                                    ),

                                    const SizedBox(height: 8),

                                    Wrap(
                                      spacing: 8,

                                      children: a.services.map((s) {
                                        return Chip(label: Text(s['name']));
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 14,
                                    color: statusColor(a.status),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(a.status),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                if (state is AppointmentError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

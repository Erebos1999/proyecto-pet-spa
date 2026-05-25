import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/appointment_bloc.dart';

class CalendarScreen
    extends StatefulWidget {
  const CalendarScreen(
      {super.key});

  @override
  State<CalendarScreen>
      createState() =>
          _CalendarScreenState();
}

class _CalendarScreenState
    extends State<CalendarScreen> {
  DateTime selectedDate =
      DateTime.now();

  @override
  void initState() {
    super.initState();

    context
        .read<AppointmentBloc>()
        .add(
          LoadAppointmentsByDateEvent(
            selectedDate,
          ),
        );
  }

  Future<void> changeDate() async {
    final date =
        await showDatePicker(
      context: context,
      initialDate:
          selectedDate,
      firstDate:
          DateTime.now(),
      lastDate:
          DateTime.now().add(
        const Duration(
            days: 365),
      ),
    );

    if (date == null) return;

    setState(() {
      selectedDate = date;
    });

    context
        .read<AppointmentBloc>()
        .add(
          LoadAppointmentsByDateEvent(
            date,
          ),
        );
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text(
          'Calendario',
        ),
      ),
      floatingActionButton:
          FloatingActionButton(
        backgroundColor:
            const Color(
                0xff66c7d8),
        child:
            const Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/create-appointment',
          );
        },
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              selectedDate
                  .toString()
                  .split(' ')
                  .first,
            ),
            trailing:
                const Icon(
              Icons.calendar_today,
            ),
            onTap:
                changeDate,
          ),
          Expanded(
            child:
                BlocBuilder<
                    AppointmentBloc,
                    AppointmentState>(
              builder:
                  (context,
                      state) {
                if (state
                    is AppointmentLoading) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                if (state
                    is AppointmentLoaded) {
                  if (state
                      .appointments
                      .isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay citas',
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: state
                        .appointments
                        .length,
                    itemBuilder:
                        (_, i) {
                      final a =
                          state.appointments[
                              i];

                      return Card(
                        margin:
                            const EdgeInsets.all(
                                12),
                        child:
                            ListTile(
                          leading:
                              const Icon(
                            Icons.pets,
                            color: Color(
                                0xff66c7d8),
                          ),
                          title:
                              Text(
                            a.serviceName,
                          ),
                          subtitle:
                              Text(
                            a.startTime
                                .toString(),
                          ),
                          trailing:
                              Text(
                            a.status,
                          ),
                        ),
                      );
                    },
                  );
                }

                if (state
                    is AppointmentError) {
                  return Center(
                    child:
                        Text(
                      state.message,
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          )
        ],
      ),
    );
  }
}
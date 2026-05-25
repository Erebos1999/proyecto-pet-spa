import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/appointment_entity.dart';
import '../bloc/appointment_bloc.dart';

class CreateAppointmentScreen extends StatefulWidget {
  const CreateAppointmentScreen({super.key});

  @override
  State<CreateAppointmentScreen> createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState
    extends State<CreateAppointmentScreen> {
  final petIdController = TextEditingController();
  final ownerIdController = TextEditingController();
  final groomerIdController = TextEditingController();

  String selectedService = 'Baño';
  int duration = 60;

  DateTime selectedDate =
      DateTime.now().add(
    const Duration(hours: 1),
  );

  @override
  void dispose() {
    petIdController.dispose();
    ownerIdController.dispose();
    groomerIdController.dispose();
    super.dispose();
  }

  void createAppointment() {
    final appointment = AppointmentEntity(
      id: '',
      petId: petIdController.text.trim(),
      ownerId: ownerIdController.text.trim(),
      groomerId:
          groomerIdController.text.trim(),
      serviceName: selectedService,
      durationMinutes: duration,
      startTime: selectedDate,
      endTime: selectedDate.add(
        Duration(minutes: duration),
      ),
      status: 'pending',
      createdAt: DateTime.now(),
    );

    context.read<AppointmentBloc>().add(
          CreateAppointmentEvent(
            appointment,
          ),
        );
  }

  Future<void> pickDate() async {
    final date =
        await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate:
          DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (date == null) return;

    final time =
        await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(
        selectedDate,
      ),
    );

    if (time == null) return;

    setState(() {
      selectedDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Widget field(
    TextEditingController c,
    String label,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 20,
      ),
      child: TextField(
        controller: c,
        decoration:
            InputDecoration(
          labelText: label,
          border:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
              12,
            ),
          ),
        ),
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
          'Nueva Cita',
        ),
      ),
      body:
          BlocListener<
              AppointmentBloc,
              AppointmentState>(
        listener:
            (context, state) {
          if (state
              is AppointmentCreated) {
            ScaffoldMessenger.of(
                    context)
                .showSnackBar(
              const SnackBar(
                content: Text(
                  'Cita creada correctamente',
                ),
              ),
            );

            Navigator.pop(
                context);
          }

          if (state
              is AppointmentError) {
            ScaffoldMessenger.of(
                    context)
                .showSnackBar(
              SnackBar(
                content:
                    Text(
                  state.message,
                ),
              ),
            );
          }
        },
        child: Center(
          child:
              ConstrainedBox(
            constraints:
                const BoxConstraints(
              maxWidth:
                  550,
            ),
            child:
                Card(
              margin:
                  const EdgeInsets.all(
                24,
              ),
              child:
                  Padding(
                padding:
                    const EdgeInsets.all(
                  30,
                ),
                child:
                    SingleChildScrollView(
                  child:
                      Column(
                    children: [
                      const Icon(
                        Icons
                            .calendar_month,
                        size:
                            70,
                        color: Color(
                            0xff66c7d8),
                      ),
                      const SizedBox(
                          height:
                              20),
                      const Text(
                        'Agendar Servicio',
                        style:
                            TextStyle(
                          fontSize:
                              28,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                          height:
                              30),
                      field(
                        petIdController,
                        'ID Mascota',
                      ),
                      field(
                        ownerIdController,
                        'ID Cliente',
                      ),
                      field(
                        groomerIdController,
                        'ID Groomer',
                      ),
                      DropdownButtonFormField(
                        value:
                            selectedService,
                        items: const [
                          DropdownMenuItem(
                            value:
                                'Baño',
                            child: Text(
                                'Baño'),
                          ),
                          DropdownMenuItem(
                            value:
                                'Corte',
                            child: Text(
                                'Corte'),
                          ),
                          DropdownMenuItem(
                            value:
                                'Spa Premium',
                            child: Text(
                                'Spa Premium'),
                          ),
                        ],
                        onChanged:
                            (v) {
                          setState(
                              () {
                            selectedService =
                                v!;
                          });
                        },
                      ),
                      const SizedBox(
                          height:
                              20),
                      DropdownButtonFormField(
                        value:
                            duration,
                        items: const [
                          DropdownMenuItem(
                            value:
                                30,
                            child: Text(
                                '30 min'),
                          ),
                          DropdownMenuItem(
                            value:
                                60,
                            child: Text(
                                '60 min'),
                          ),
                          DropdownMenuItem(
                            value:
                                90,
                            child: Text(
                                '90 min'),
                          ),
                        ],
                        onChanged:
                            (v) {
                          setState(
                              () {
                            duration =
                                v!;
                          });
                        },
                      ),
                      const SizedBox(
                          height:
                              30),
                      ListTile(
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  12),
                          side:
                              const BorderSide(),
                        ),
                        title:
                            Text(
                          selectedDate
                              .toString(),
                        ),
                        trailing:
                            const Icon(
                          Icons
                              .access_time,
                        ),
                        onTap:
                            pickDate,
                      ),
                      const SizedBox(
                          height:
                              30),
                      BlocBuilder<
                          AppointmentBloc,
                          AppointmentState>(
                        builder:
                            (context,
                                state) {
                          if (state
                              is AppointmentLoading) {
                            return const CircularProgressIndicator();
                          }

                          return SizedBox(
                            width:
                                double.infinity,
                            child:
                                ElevatedButton(
                              onPressed:
                                  createAppointment,
                              child:
                                  const Text(
                                'Crear Cita',
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:cerberus_pet_spa/modules/appointments/data/datasource/user_firestore_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../pets/data/datasource/pet_firestore_datasource.dart';
import '../../domain/entities/appointment_entity.dart';
import '../bloc/appointment_bloc.dart';

class CreateAppointmentScreen extends StatefulWidget {
  const CreateAppointmentScreen({super.key});

  @override
  State<CreateAppointmentScreen> createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  final petDatasource = PetFirestoreDatasource();

  final groomerDatasource = UserFirestoreDatasource();

  List<dynamic> pets = [];
  List<dynamic> groomers = [];

  String? selectedPetId;
  String? selectedGroomerId;

  String selectedService = 'Baño';
  int duration = 60;

  late String ownerId;

  DateTime selectedDate = DateTime.now().add(const Duration(hours: 1));

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    ownerId = FirebaseAuth.instance.currentUser!.uid;

    final userPets = await petDatasource.getPetsByOwner(ownerId);

    final groomersList = await groomerDatasource.getGroomers();

    setState(() {
      pets = userPets;
      groomers = groomersList;

      if (pets.isNotEmpty) {
        selectedPetId = pets.first.id;
      }

      if (groomers.isNotEmpty) {
        selectedGroomerId = groomers.first['id'];
      }
    });
  }

  void createAppointment() {
    if (selectedPetId == null || selectedGroomerId == null) {
      return;
    }

    final appointment = AppointmentEntity(
      id: '',
      petId: selectedPetId!,
      ownerId: ownerId,
      groomerId: selectedGroomerId!,
      serviceName: selectedService,
      durationMinutes: duration,
      startTime: selectedDate,
      endTime: selectedDate.add(Duration(minutes: duration)),
      status: 'pending',
      createdAt: DateTime.now(),
    );

    context.read<AppointmentBloc>().add(CreateAppointmentEvent(appointment));
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Cita')),
      body: BlocListener<AppointmentBloc, AppointmentState>(
        listener: (context, state) {
          if (state is AppointmentCreated) {
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: [
              DropdownButtonFormField(
                value: selectedPetId,
                decoration: const InputDecoration(labelText: 'Mascota'),
                items: pets
                    .map<DropdownMenuItem<String>>(
                      (p) => DropdownMenuItem(value: p.id, child: Text(p.name)),
                    )
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    selectedPetId = v;
                  });
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                initialValue: ownerId,
                enabled: false,
                decoration: const InputDecoration(labelText: 'Cliente'),
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField(
                value: selectedGroomerId,
                decoration: const InputDecoration(labelText: 'Groomer'),
                items: groomers
                    .map<DropdownMenuItem<String>>(
                      (g) => DropdownMenuItem(
                        value: g['id'],
                        child: Text(g['nombre'] ?? 'Sin nombre'),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    selectedGroomerId = v;
                  });
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: pickDate,
                icon: const Icon(Icons.calendar_month),
                label: const Text('Escoger día'),
              ),

              const SizedBox(height: 15),

              TextFormField(
                enabled: false,
                initialValue: DateFormat(
                  'dd/MM/yyyy - HH:mm',
                ).format(selectedDate),
                decoration: const InputDecoration(
                  labelText: 'Fecha y hora seleccionada',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: createAppointment,
                child: const Text('Crear Cita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

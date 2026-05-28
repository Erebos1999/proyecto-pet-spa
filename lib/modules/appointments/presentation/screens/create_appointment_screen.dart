import 'package:cerberus_pet_spa/modules/appointments/data/datasource/user_firestore_datasource.dart';
import 'package:cerberus_pet_spa/modules/services/data/datasource/service_firestore_datasource.dart';
import 'package:cerberus_pet_spa/modules/services/domain/entities/service_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  final serviceDatasource = ServiceFirestoreDatasource();

  List<dynamic> pets = [];

  List<dynamic> groomers = [];

  List<ServiceEntity> services = [];

  List<ServiceEntity> selectedServices = [];

  List<String> availableSlots = [];

  double total = 0;

  String? selectedPetId;

  String? selectedGroomerId;

  String? selectedHour;

  late String ownerId;

  late String ownerName;

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    final user = FirebaseAuth.instance.currentUser!;

    ownerId = user.uid;

    ownerName = user.displayName ?? user.email ?? 'Cliente';

    final userPets = await petDatasource.getPetsByOwner(ownerId);

    final groomersList = await groomerDatasource.getGroomers();

    final servicesList = await serviceDatasource.getServices();

    setState(() {
      pets = userPets;

      groomers = groomersList;

      services = servicesList;

      if (pets.isNotEmpty) {
        selectedPetId = pets.first.id;
      }

      if (groomers.isNotEmpty) {
        selectedGroomerId = groomers.first['id'];
      }
    });
  }

  Future<void> loadAvailableSlots() async {
    if (selectedGroomerId == null) {
      return;
    }

    final duration = selectedServices.fold<int>(
      0,
      (sum, service) => sum + service.duration,
    );

    if (duration <= 0) {
      return;
    }

    final slots = await context
        .read<AppointmentBloc>()
        .repository
        .getAvailableSlots(
          date: selectedDate,
          groomerId: selectedGroomerId!,
          durationMinutes: duration,
        );

    setState(() {
      availableSlots = slots;

      selectedHour = null;
    });
  }

  Future<void> pickDate() async {
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

    await loadAvailableSlots();
  }

  void createAppointment() {
    if (selectedPetId == null ||
        selectedGroomerId == null ||
        selectedServices.isEmpty) {
      return;
    }

    if (selectedHour == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecciona una hora')));

      return;
    }

    final selectedPet = pets.firstWhere((e) => e.id == selectedPetId);

    final selectedGroomer = groomers.firstWhere(
      (e) => e['id'] == selectedGroomerId,
    );

    final split = selectedHour!.split(':');

    final startTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(split[0]),
      int.parse(split[1]),
    );

    final duration = selectedServices.fold<int>(
      0,
      (sum, service) => sum + service.duration,
    );

    final appointment = AppointmentEntity(
      id: '',

      petId: selectedPet.id,

      petName: selectedPet.name,

      ownerId: ownerId,

      ownerName: ownerName,

      groomerId: selectedGroomerId!,

      groomerName: selectedGroomer['nombre'],

      services: selectedServices
          .map(
            (e) => {
              'serviceId': e.id,
              'name': e.name,
              'price': e.price,
              'duration': e.duration,
            },
          )
          .toList(),

      total: total,

      durationMinutes: duration,

      startTime: startTime,

      endTime: startTime.add(Duration(minutes: duration)),

      status: 'pending',

      notes: '',

      completedChecklist: [],

      paymentCompleted: false,

      paymentMethod: '',

      createdAt: DateTime.now(),
    );

    context.read<AppointmentBloc>().add(CreateAppointmentEvent(appointment));
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

          if (state is AppointmentError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
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
                initialValue: ownerName,

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
                        child: Text(g['nombre'] ?? ''),
                      ),
                    )
                    .toList(),

                onChanged: (v) async {
                  setState(() {
                    selectedGroomerId = v;
                  });

                  await loadAvailableSlots();
                },
              ),

              const SizedBox(height: 30),

              const Text(
                'Servicios',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              ...services.map((service) {
                final selected = selectedServices.any(
                  (e) => e.id == service.id,
                );

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),

                  child: CheckboxListTile(
                    value: selected,

                    title: Text(service.name),

                    subtitle: Text(
                      'Bs ${service.price} • ${service.duration} min',
                    ),

                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedServices.add(service);
                        } else {
                          selectedServices.removeWhere(
                            (e) => e.id == service.id,
                          );
                        }

                        total = selectedServices.fold(
                          0,
                          (previousValue, element) =>
                              previousValue + element.price,
                        );
                      });

                      loadAvailableSlots();
                    },
                  ),
                );
              }),

              const SizedBox(height: 15),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),

                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          Text('Bs $total'),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Text(
                            'Duración',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          Text(
                            '${selectedServices.fold<int>(0, (sum, service) => sum + service.duration)} min',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: pickDate,

                icon: const Icon(Icons.calendar_month),

                label: Text(
                  'Escoger día (${selectedDate.day}/${selectedDate.month}/${selectedDate.year})',
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Horas disponibles',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              if (availableSlots.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Selecciona servicios y groomer para ver horarios disponibles',
                    ),
                  ),
                )
              else
                Wrap(
                  spacing: 10,
                  runSpacing: 10,

                  children: availableSlots.map((hour) {
                    final selected = selectedHour == hour;

                    return ChoiceChip(
                      label: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: Text(hour),
                      ),

                      selected: selected,

                      onSelected: (_) {
                        setState(() {
                          selectedHour = hour;
                        });
                      },
                    );
                  }).toList(),
                ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  onPressed: createAppointment,

                  icon: const Icon(Icons.check),

                  label: const Text('Crear Cita'),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

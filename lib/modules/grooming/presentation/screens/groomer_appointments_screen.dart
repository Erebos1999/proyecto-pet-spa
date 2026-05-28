import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../appointments/data/datasource/appointment_firestore_datasource.dart';
import '../../../appointments/data/repositories/appointment_repository_impl.dart';
import '../../../appointments/domain/entities/appointment_entity.dart';
import 'grooming_detail_screen.dart';

class GroomerAppointmentsScreen extends StatefulWidget {
  const GroomerAppointmentsScreen({super.key});

  @override
  State<GroomerAppointmentsScreen> createState() =>
      _GroomerAppointmentsScreenState();
}

class _GroomerAppointmentsScreenState extends State<GroomerAppointmentsScreen> {
  final repository = AppointmentRepositoryImpl(
    AppointmentFirestoreDatasource(),
  );

  List<AppointmentEntity> appointments = [];

  bool loading = true;

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    loadAppointments();
  }

  Future<void> loadAppointments() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final data = await repository.getAppointmentsByGroomer(
      groomerId: uid,
      date: selectedDate,
    );

    setState(() {
      appointments = data;
      loading = false;
    });
  }

  Future<void> changeDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    setState(() {
      selectedDate = date;
      loading = true;
    });

    loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fa),

      appBar: AppBar(title: const Text('Mi Agenda')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            InkWell(
              onTap: changeDate,

              borderRadius: BorderRadius.circular(20),

              child: Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Color(0xff66c7d8)),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(selectedDate),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const Icon(Icons.arrow_forward_ios, size: 18),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : appointments.isEmpty
                  ? const Center(child: Text('No hay citas'))
                  : ListView.builder(
                      itemCount: appointments.length,

                      itemBuilder: (_, i) {
                        final a = appointments[i];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),

                          padding: const EdgeInsets.all(20),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Color(0xff66c7d8),

                                    child: Icon(
                                      Icons.pets,
                                      color: Colors.white,
                                    ),
                                  ),

                                  const SizedBox(width: 15),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          a.petName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),

                                        Text(a.ownerName),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    DateFormat('HH:mm').format(a.startTime),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              Text(a.services.map((e) => e['name']).join(', ')),

                              const SizedBox(height: 20),

                              Row(
                                children: [
                                  Chip(label: Text(a.status)),

                                  const Spacer(),

                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => GroomingDetailScreen(
                                            appointment: a,
                                          ),
                                        ),
                                      );
                                    },

                                    child: const Text('Abrir ficha'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

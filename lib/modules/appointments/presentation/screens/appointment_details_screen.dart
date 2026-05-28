import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/appointment_entity.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final AppointmentEntity appointment;

  const AppointmentDetailsScreen({super.key, required this.appointment});

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  late List<String> checklist;

  final notesController = TextEditingController();

  final requiredChecklist = [
    'Baño realizado',
    'Uñas cortadas',
    'Oídos limpiados',
  ];

  @override
  void initState() {
    super.initState();

    checklist = List.from(widget.appointment.completedChecklist);

    notesController.text = widget.appointment.notes;
  }

  bool get canCloseService {
    return requiredChecklist.every((item) => checklist.contains(item));
  }

  void toggleItem(String item) {
    setState(() {
      if (checklist.contains(item)) {
        checklist.remove(item);
      } else {
        checklist.add(item);
      }
    });
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;

    return Scaffold(
      backgroundColor: const Color(0xfff4f7fb),

      appBar: AppBar(title: const Text('Detalle Servicio')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: const Color(0xff66c7d8).withOpacity(0.15),

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: const Icon(
                          Icons.pets,
                          size: 40,
                          color: Color(0xff66c7d8),
                        ),
                      ),

                      const SizedBox(width: 18),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              appointment.petName,

                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(appointment.ownerName),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: infoCard(
                          'Inicio',
                          DateFormat('HH:mm').format(appointment.startTime),
                          Icons.schedule,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: infoCard(
                          'Fin',
                          DateFormat('HH:mm').format(appointment.endTime),
                          Icons.timer,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  infoCard(
                    'Groomer',
                    appointment.groomerName,
                    Icons.content_cut,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            sectionTitle('Servicios'),

            ...appointment.services.map((service) => serviceCard(service)),

            const SizedBox(height: 30),

            sectionTitle('Checklist Grooming'),

            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),

              child: Column(
                children: requiredChecklist
                    .map(
                      (item) => CheckboxListTile(
                        value: checklist.contains(item),

                        title: Text(item),

                        activeColor: const Color(0xff66c7d8),

                        onChanged: (_) {
                          toggleItem(item);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 30),

            sectionTitle('Observaciones'),

            TextField(
              controller: notesController,

              maxLines: 5,

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                hintText: 'Agregar observaciones del servicio...',
              ),
            ),

            const SizedBox(height: 30),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),

              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        'Bs ${appointment.total.toStringAsFixed(2)}',

                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,

                          color: Color(0xff66c7d8),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,

                    height: 55,

                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canCloseService
                            ? const Color(0xff66c7d8)
                            : Colors.grey,
                      ),

                      onPressed: canCloseService
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Servicio finalizado'),
                                ),
                              );
                            }
                          : null,

                      icon: const Icon(Icons.check),

                      label: Text(
                        canCloseService
                            ? 'Cerrar Servicio'
                            : 'Checklist incompleto',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget infoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        children: [
          Icon(icon, color: const Color(0xff66c7d8)),

          const SizedBox(height: 10),

          Text(title, style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 6),

          Text(
            value,
            textAlign: TextAlign.center,

            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget serviceCard(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: const Color(0xff66c7d8).withOpacity(0.12),

              borderRadius: BorderRadius.circular(18),
            ),

            child: const Icon(Icons.spa, color: Color(0xff66c7d8)),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  service['name'],

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text('${service['duration']} min'),
              ],
            ),
          ),

          Text(
            'Bs ${service['price']}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

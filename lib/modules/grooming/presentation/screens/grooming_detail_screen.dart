import 'package:flutter/material.dart';

import '../../../appointments/domain/entities/appointment_entity.dart';

class GroomingDetailScreen extends StatelessWidget {
  final AppointmentEntity appointment;

  const GroomingDetailScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ficha Grooming')),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    appointment.petName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text('Cliente: ${appointment.ownerName}'),

                  Text('Estado: ${appointment.status}'),

                  Text('Duración: ${appointment.durationMinutes} min'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Servicios',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          ...appointment.services.map(
            (service) => Card(
              child: ListTile(
                leading: const Icon(
                  Icons.check_circle,
                  color: Color(0xff66c7d8),
                ),
                title: Text(service['name']),
                trailing: Text('Bs ${service['price']}'),
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Checklist Grooming',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          CheckboxListTile(
            value: false,
            onChanged: (_) {},
            title: const Text('Baño completo'),
          ),

          CheckboxListTile(
            value: false,
            onChanged: (_) {},
            title: const Text('Limpieza de oídos'),
          ),

          CheckboxListTile(
            value: false,
            onChanged: (_) {},
            title: const Text('Corte de uñas'),
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {},

            child: const Text('Finalizar Servicio'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/service_entity.dart';
import '../bloc/service_bloc.dart';

class CreateServiceScreen extends StatefulWidget {
  const CreateServiceScreen({super.key});

  @override
  State<CreateServiceScreen> createState() =>
      _CreateServiceScreenState();
}

class _CreateServiceScreenState
    extends State<CreateServiceScreen> {
  final nameController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  final priceController =
      TextEditingController();

  final durationController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();

    descriptionController.dispose();

    priceController.dispose();

    durationController.dispose();

    super.dispose();
  }

  void save() {
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        priceController.text.isEmpty ||
        durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Completa todos los campos'),
        ),
      );

      return;
    }

    final service = ServiceEntity(
      id: '',

      name:
          nameController.text.trim(),

      description:
          descriptionController.text.trim(),

      price: double.parse(
        priceController.text,
      ),

      duration: int.parse(
        durationController.text,
      ),

      active: true,

      createdAt: DateTime.now(),
    );

    context.read<ServiceBloc>().add(
          CreateServiceEvent(service),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Nuevo Servicio'),
      ),

      body: BlocListener<
          ServiceBloc,
          ServiceState>(
        listener: (context, state) {
          if (state is ServiceCreated) {
            Navigator.pop(context);
          }

          if (state is ServiceError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content:
                    Text(state.message),
              ),
            );
          }
        },

        child: Padding(
          padding:
              const EdgeInsets.all(24),

          child: ListView(
            children: [
              TextField(
                controller:
                    nameController,

                decoration:
                    const InputDecoration(
                  labelText:
                      'Nombre del servicio',
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller:
                    descriptionController,

                maxLines: 4,

                decoration:
                    const InputDecoration(
                  labelText:
                      'Descripción',
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller:
                    priceController,

                keyboardType:
                    TextInputType.number,

                decoration:
                    const InputDecoration(
                  labelText:
                      'Precio (Bs)',
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller:
                    durationController,

                keyboardType:
                    TextInputType.number,

                decoration:
                    const InputDecoration(
                  labelText:
                      'Duración (minutos)',
                ),
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  onPressed: save,

                  icon: const Icon(
                    Icons.save,
                  ),

                  label: const Text(
                    'Guardar Servicio',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
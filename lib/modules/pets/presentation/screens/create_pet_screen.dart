import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/pet_entity.dart';
import '../bloc/pet_bloc.dart';

class CreatePetScreen
    extends StatefulWidget {
  const CreatePetScreen(
      {super.key});

  @override
  State<CreatePetScreen>
      createState() =>
          _CreatePetScreenState();
}

class _CreatePetScreenState
    extends State<CreatePetScreen> {
  final name =
      TextEditingController();
  final breed =
      TextEditingController();

  String size = 'mediano';
  String temperament =
      'tranquilo';

  void save() {
    final uid =
        FirebaseAuth.instance
            .currentUser!
            .uid;

    final pet = PetEntity(
      id: '',
      ownerId: uid,
      name: name.text,
      breed: breed.text,
      size: size,
      birthDate:
          DateTime.now(),
      temperament:
          temperament,
      photoUrl: '',
      createdAt:
          DateTime.now(),
    );

    context
        .read<PetBloc>()
        .add(
          CreatePetEvent(
              pet),
        );
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Registrar Mascota'),
      ),
      body:
          BlocListener<
              PetBloc,
              PetState>(
        listener:
            (context, state) {
          if (state
              is PetCreated) {
            Navigator.pop(
                context);
          }
        },
        child: Padding(
          padding:
              const EdgeInsets.all(
                  24),
          child: Column(
            children: [
              TextField(
                controller:
                    name,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Nombre',
                ),
              ),
              TextField(
                controller:
                    breed,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Raza',
                ),
              ),
              const SizedBox(
                  height: 20),
              ElevatedButton(
                onPressed:
                    save,
                child:
                    const Text(
                  'Guardar',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
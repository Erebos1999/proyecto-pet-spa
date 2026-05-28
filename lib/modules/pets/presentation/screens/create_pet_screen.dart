import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/pet_entity.dart';
import '../bloc/pet_bloc.dart';

class CreatePetScreen
    extends StatefulWidget {
  const CreatePetScreen({
    super.key,
  });

  @override
  State<CreatePetScreen>
      createState() =>
          _CreatePetScreenState();
}

class _CreatePetScreenState
    extends State<CreatePetScreen> {
  final nameController =
      TextEditingController();

  final speciesController =
      TextEditingController();

  final breedController =
      TextEditingController();

  final weightController =
      TextEditingController();

  final vaccinesController =
      TextEditingController();

  final allergiesController =
      TextEditingController();

  final observationsController =
      TextEditingController();

  String selectedSize =
      'Mediano';

  String selectedSex =
      'Macho';

  String selectedTemperament =
      'Tranquilo';

  DateTime birthDate =
      DateTime.now();

  Future<void> pickBirthDate() async {
    final date =
        await showDatePicker(
      context: context,
      initialDate:
          DateTime.now(),
      firstDate:
          DateTime(2010),
      lastDate:
          DateTime.now(),
    );

    if (date == null) return;

    setState(() {
      birthDate = date;
    });
  }

  void createPet() {
    final pet = PetEntity(
      id: '',
      ownerId: FirebaseAuth
          .instance
          .currentUser!
          .uid,
      name:
          nameController.text,
      species:
          speciesController.text,
      breed:
          breedController.text,
      size: selectedSize,
      sex: selectedSex,
      weight: double.tryParse(
            weightController.text,
          ) ??
          0,
      temperament:
          selectedTemperament,
      vaccines:
          vaccinesController.text,
      allergies:
          allergiesController.text,
      observations:
          observationsController
              .text,
      photoUrl: '',
      birthDate: birthDate,
      createdAt:
          DateTime.now(),
    );

    context.read<PetBloc>().add(
          CreatePetEvent(pet),
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registrar Mascota',
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(
          20,
        ),

        child: ListView(
          children: [
            TextField(
              controller:
                  nameController,
              decoration:
                  const InputDecoration(
                labelText:
                    'Nombre',
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            TextField(
              controller:
                  speciesController,
              decoration:
                  const InputDecoration(
                labelText:
                    'Especie',
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            TextField(
              controller:
                  breedController,
              decoration:
                  const InputDecoration(
                labelText:
                    'Raza',
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            DropdownButtonFormField(
              value:
                  selectedSize,

              decoration:
                  const InputDecoration(
                labelText:
                    'Tamaño',
              ),

              items: const [
                DropdownMenuItem(
                  value:
                      'Pequeño',
                  child: Text(
                    'Pequeño',
                  ),
                ),

                DropdownMenuItem(
                  value:
                      'Mediano',
                  child: Text(
                    'Mediano',
                  ),
                ),

                DropdownMenuItem(
                  value:
                      'Grande',
                  child: Text(
                    'Grande',
                  ),
                ),
              ],

              onChanged: (v) {
                setState(() {
                  selectedSize =
                      v!;
                });
              },
            ),

            const SizedBox(
              height: 16,
            ),

            DropdownButtonFormField(
              value:
                  selectedSex,

              decoration:
                  const InputDecoration(
                labelText:
                    'Sexo',
              ),

              items: const [
                DropdownMenuItem(
                  value:
                      'Macho',
                  child: Text(
                    'Macho',
                  ),
                ),

                DropdownMenuItem(
                  value:
                      'Hembra',
                  child: Text(
                    'Hembra',
                  ),
                ),
              ],

              onChanged: (v) {
                setState(() {
                  selectedSex =
                      v!;
                });
              },
            ),

            const SizedBox(
              height: 16,
            ),

            DropdownButtonFormField(
              value:
                  selectedTemperament,

              decoration:
                  const InputDecoration(
                labelText:
                    'Temperamento',
              ),

              items: const [
                DropdownMenuItem(
                  value:
                      'Tranquilo',
                  child: Text(
                    'Tranquilo',
                  ),
                ),

                DropdownMenuItem(
                  value:
                      'Nervioso',
                  child: Text(
                    'Nervioso',
                  ),
                ),

                DropdownMenuItem(
                  value:
                      'Agresivo',
                  child: Text(
                    'Agresivo',
                  ),
                ),
              ],

              onChanged: (v) {
                setState(() {
                  selectedTemperament =
                      v!;
                });
              },
            ),

            const SizedBox(
              height: 16,
            ),

            TextField(
              controller:
                  weightController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  const InputDecoration(
                labelText:
                    'Peso',
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            ElevatedButton.icon(
              onPressed:
                  pickBirthDate,
              icon: const Icon(
                Icons.cake,
              ),
              label: const Text(
                'Seleccionar fecha nacimiento',
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            TextField(
              controller:
                  vaccinesController,
              maxLines: 3,
              decoration:
                  const InputDecoration(
                labelText:
                    'Vacunas',
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            TextField(
              controller:
                  allergiesController,
              maxLines: 2,
              decoration:
                  const InputDecoration(
                labelText:
                    'Alergias',
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            TextField(
              controller:
                  observationsController,
              maxLines: 4,
              decoration:
                  const InputDecoration(
                labelText:
                    'Observaciones',
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(
              width:
                  double.infinity,
              child: ElevatedButton(
                onPressed:
                    createPet,
                child: const Text(
                  'Registrar Mascota',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
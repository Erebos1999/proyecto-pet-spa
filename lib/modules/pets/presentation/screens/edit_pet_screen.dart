import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/pet_entity.dart';
import '../bloc/pet_bloc.dart';

class EditPetScreen extends StatefulWidget {
  final PetEntity pet;

  const EditPetScreen({
    super.key,
    required this.pet,
  });

  @override
  State<EditPetScreen> createState() =>
      _EditPetScreenState();
}

class _EditPetScreenState
    extends State<EditPetScreen> {
  late TextEditingController
      nameController;

  late TextEditingController
      speciesController;

  late TextEditingController
      breedController;

  late TextEditingController
      weightController;

  late TextEditingController
      vaccinesController;

  late TextEditingController
      allergiesController;

  late TextEditingController
      observationsController;

  late String selectedSize;

  late String selectedSex;

  late String
      selectedTemperament;

  late DateTime birthDate;

  @override
  void initState() {
    super.initState();

    final pet = widget.pet;

    nameController =
        TextEditingController(
      text: pet.name,
    );

    speciesController =
        TextEditingController(
      text: pet.species,
    );

    breedController =
        TextEditingController(
      text: pet.breed,
    );

    weightController =
        TextEditingController(
      text:
          pet.weight.toString(),
    );

    vaccinesController =
        TextEditingController(
      text: pet.vaccines,
    );

    allergiesController =
        TextEditingController(
      text: pet.allergies,
    );

    observationsController =
        TextEditingController(
      text:
          pet.observations,
    );

    selectedSize = pet.size;

    selectedSex = pet.sex;

    selectedTemperament =
        pet.temperament;

    birthDate =
        pet.birthDate;
  }

  @override
  void dispose() {
    nameController.dispose();

    speciesController.dispose();

    breedController.dispose();

    weightController.dispose();

    vaccinesController.dispose();

    allergiesController.dispose();

    observationsController
        .dispose();

    super.dispose();
  }

  Future<void>
      pickBirthDate() async {
    final date =
        await showDatePicker(
      context: context,
      initialDate:
          birthDate,
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

  void updatePet() {
    final updatedPet =
        PetEntity(
      id: widget.pet.id,
      ownerId:
          widget.pet.ownerId,
      name:
          nameController.text,
      species:
          speciesController
              .text,
      breed:
          breedController.text,
      size: selectedSize,
      sex: selectedSex,
      weight:
          double.tryParse(
                weightController
                    .text,
              ) ??
              0,
      temperament:
          selectedTemperament,
      vaccines:
          vaccinesController
              .text,
      allergies:
          allergiesController
              .text,
      observations:
          observationsController
              .text,
      photoUrl:
          widget.pet.photoUrl,
      birthDate: birthDate,
      createdAt:
          widget.pet.createdAt,
    );

    context.read<PetBloc>().add(
          UpdatePetEvent(
            updatedPet,
          ),
        );

    Navigator.pop(context);
  }

  InputDecoration decoration(
    String label,
  ) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        borderSide:
            BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(
        0xfff5f7fa,
      ),

      appBar: AppBar(
        title: const Text(
          'Editar Mascota',
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(
          20,
        ),

        child: ListView(
          children: [
            Container(
              padding:
                  const EdgeInsets.all(
                20,
              ),

              decoration:
                  BoxDecoration(
                color:
                    Colors.white,
                borderRadius:
                    BorderRadius
                        .circular(
                  24,
                ),
              ),

              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 42,
                    backgroundColor:
                        Color(
                      0xff66c7d8,
                    ),
                    child: Icon(
                      Icons.pets,
                      size: 42,
                      color:
                          Colors.white,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  TextField(
                    controller:
                        nameController,
                    decoration:
                        decoration(
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
                        decoration(
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
                        decoration(
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
                        decoration(
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
                        decoration(
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
                        decoration(
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
                        TextInputType
                            .number,
                    decoration:
                        decoration(
                      'Peso',
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  ElevatedButton.icon(
                    onPressed:
                        pickBirthDate,
                    icon:
                        const Icon(
                      Icons.cake,
                    ),
                    label: const Text(
                      'Cambiar fecha nacimiento',
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
                        decoration(
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
                        decoration(
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
                        decoration(
                      'Observaciones',
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  SizedBox(
                    width:
                        double.infinity,
                    height: 55,
                    child:
                        ElevatedButton.icon(
                      onPressed:
                          updatePet,
                      icon:
                          const Icon(
                        Icons.save,
                      ),
                      label:
                          const Text(
                        'Guardar Cambios',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/pet_entity.dart';
import '../bloc/pet_bloc.dart';

class MyPetsScreen
    extends StatefulWidget {
  const MyPetsScreen({
    super.key,
  });

  @override
  State<MyPetsScreen>
      createState() =>
          _MyPetsScreenState();
}

class _MyPetsScreenState
    extends State<MyPetsScreen> {
  @override
  void initState() {
    super.initState();

    context.read<PetBloc>().add(
          LoadPetsEvent(
            FirebaseAuth.instance
                .currentUser!
                .uid,
          ),
        );
  }

  Future<void> deletePet(
    String id,
  ) async {
    context.read<PetBloc>().add(
          DeletePetEvent(id),
        );

    context.read<PetBloc>().add(
          LoadPetsEvent(
            FirebaseAuth.instance
                .currentUser!
                .uid,
          ),
        );
  }

  Widget petCard(
    PetEntity pet,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 18,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          24,
        ),
      ),

      child: ListTile(
        contentPadding:
            const EdgeInsets.all(
          18,
        ),

        leading:
            const CircleAvatar(
          radius: 28,
          backgroundColor:
              Color(0xff66c7d8),
          child: Icon(
            Icons.pets,
            color: Colors.white,
          ),
        ),

        title: Text(
          pet.name,
          style:
              const TextStyle(
            fontWeight:
                FontWeight.bold,
            fontSize: 18,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,

          children: [
            const SizedBox(
              height: 8,
            ),

            Text(
              '${pet.breed} • ${pet.size}',
            ),

            Text(
              'Temperamento: ${pet.temperament}',
            ),

            Text(
              'Peso: ${pet.weight} kg',
            ),
          ],
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.edit,
              ),
              onPressed: () {
                context.push(
                  '/edit-pet',
                  extra: pet,
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text(
                        'Eliminar mascota',
                      ),
                      content: const Text(
                        '¿Deseas eliminar esta mascota?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                            );
                          },
                          child: const Text(
                            'Cancelar',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                            );
                            deletePet(
                              pet.id,
                            );
                          },
                          child: const Text(
                            'Eliminar',
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
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
        title:
            const Text(
          'Mis Mascotas',
        ),
      ),

      floatingActionButton:
          FloatingActionButton(
        backgroundColor:
            const Color(
          0xff66c7d8,
        ),

        onPressed: () async {
          await context.push(
            '/create-pet',
          );

          if (!mounted) return;

          context
              .read<PetBloc>()
              .add(
                LoadPetsEvent(
                  FirebaseAuth
                      .instance
                      .currentUser!
                      .uid,
                ),
              );
        },

        child: const Icon(
          Icons.add,
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(
          20,
        ),

        child: BlocBuilder<
            PetBloc,
            PetState>(
          builder:
              (context, state) {
            if (state
                is PetLoading) {
              return const Center(
                child:
                    CircularProgressIndicator(),
              );
            }

            if (state
                is PetLoaded) {
              if (state
                  .pets
                  .isEmpty) {
                return const Center(
                  child: Text(
                    'No tienes mascotas registradas',
                  ),
                );
              }

              return ListView(
                children: state.pets
                    .map(
                      petCard,
                    )
                    .toList(),
              );
            }

            if (state
                is PetError) {
              return Center(
                child: Text(
                  state.message,
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/pet_bloc.dart';

class MyPetsScreen extends StatefulWidget {
  const MyPetsScreen({super.key});

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  @override
  void initState() {
    super.initState();

    final uid = FirebaseAuth.instance.currentUser!.uid;

    context.read<PetBloc>().add(LoadPetsEvent(uid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Mis Mascotas'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff66c7d8),
        onPressed: () {
          context.push('/create-pet');
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<PetBloc, PetState>(
        builder: (context, state) {
          if (state is PetLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PetLoaded) {
            return ListView(
              children: state.pets
                  .map(
                    (e) => Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.pets,
                          color: Color(0xff66c7d8),
                        ),
                        title: Text(e.name),
                        subtitle: Text(e.breed),
                      ),
                    ),
                  )
                  .toList(),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

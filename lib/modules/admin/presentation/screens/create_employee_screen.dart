import 'package:flutter/material.dart';

import '../../../../core/utils/validators.dart';

import '../../../auth/data/models/user_model.dart';
import '../../data/datasource/admin_firestore_datasource.dart';
import '../../data/repositories/admin_repository_impl.dart';

class CreateEmployeeScreen extends StatefulWidget {
  const CreateEmployeeScreen({super.key});

  @override
  State<CreateEmployeeScreen> createState() => _CreateEmployeeScreenState();
}

class _CreateEmployeeScreenState extends State<CreateEmployeeScreen> {
  final formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final telefonoController = TextEditingController();
  final ciController = TextEditingController();
  final direccionController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final repository = AdminRepositoryImpl(AdminFirestoreDatasource());

  String selectedRole = 'groomer';

  @override
  void dispose() {
    nombreController.dispose();
    telefonoController.dispose();
    ciController.dispose();
    direccionController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> createEmployee() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      final employee = UserModel(
        uid: '',

        email: emailController.text.trim(),

        nombre: nombreController.text.trim(),

        telefono: telefonoController.text.trim(),

        ci: ciController.text.trim(),

        direccion: direccionController.text.trim(),

        rol: selectedRole,

        estado: 'activo',
        failedAttempts: 0,
        lockedUntil: null,
        mfaEnabled: false,
        mfaSecret: '',
      );

      await repository.createEmployee(
        employee: employee,
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Empleado creado')));

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Empleado')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    Validators.validateRequired(value ?? '', 'Nombre'),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: telefonoController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                validator: (value) =>
                    Validators.validateRequired(value ?? '', 'Teléfono'),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: ciController,
                decoration: const InputDecoration(labelText: 'CI'),
                validator: (value) =>
                    Validators.validateRequired(value ?? '', 'CI'),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: direccionController,
                decoration: const InputDecoration(labelText: 'Dirección'),
                validator: (value) =>
                    Validators.validateRequired(value ?? '', 'Dirección'),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator: (value) => Validators.validateEmail(value ?? ''),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                validator: (value) => Validators.validatePassword(value ?? ''),
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField(
                value: selectedRole,

                items: const [
                  DropdownMenuItem(value: 'groomer', child: Text('Groomer')),

                  DropdownMenuItem(
                    value: 'recepcion',
                    child: Text('Recepción'),
                  ),
                ],

                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: createEmployee,
                  child: const Text('Crear Empleado'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

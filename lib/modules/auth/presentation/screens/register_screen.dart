import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/password_strength_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  String currentPassword = '';

  final nombre = TextEditingController();
  final telefono = TextEditingController();
  final ci = TextEditingController();
  final direccion = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    nombre.dispose();
    telefono.dispose();
    ci.dispose();
    direccion.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void register() {
    if (!formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      RegisterEvent(
        email: email.text.trim(),
        password: password.text.trim(),
        nombre: nombre.text.trim(),
        telefono: telefono.text.trim(),
        ci: ci.text.trim(),
        direccion: direccion.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));

            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                context.go('/login');
              }
            });
          }

          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Card(
                margin: const EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const Icon(
                          Icons.pets,
                          size: 70,
                          color: Color(0xff66c7d8),
                        ),
                        const SizedBox(height: 20),

                        _field(nombre, 'Nombre'),

                        _field(telefono, 'Teléfono'),

                        _field(ci, 'CI'),

                        _field(direccion, 'Dirección'),

                        _field(email, 'Correo'),

                        TextFormField(
                          controller: password,
                          obscureText: true,
                          onChanged: (v) {
                            setState(() {
                              currentPassword = v;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                          ),
                          validator: (v) =>
                              Validators.validatePassword(v ?? ''),
                        ),

                        PasswordStrengthWidget(password: currentPassword),

                        const SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: register,
                          child: const Text('Registrarse'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(labelText: t),
        validator: (v) => Validators.validateRequired(v ?? '', t),
      ),
    );
  }
}

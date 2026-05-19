import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    context.read<AuthBloc>().add(
      LoginEvent(
        email: emailController.text.trim(),
        password:
            passwordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      body: BlocListener<
          AuthBloc,
          AuthState>(
        listener: (
          context,
          state,
        ) {
          if (state is AuthSuccess) {
            final role =
                state.user.rol;

            if (role == 'admin' &&
                state.user
                    .mfaEnabled) {
              context.push(
                '/totp-verify/${state.user.mfaSecret}',
              );

              return;
            }

            if (role == 'admin') {
              context.go('/admin');
            } else if (role ==
                'groomer') {
              context.go(
                  '/groomer');
            } else if (role ==
                'recepcion') {
              context.go(
                  '/recepcion');
            } else {
              context.go(
                  '/client');
            }
          }

          if (state is AuthError) {
            if (state.message
                .contains(
                    'Admin debe registrar 2FA')) {
              context.push(
                  '/totp-setup');
              return;
            }

            ScaffoldMessenger.of(
                    context)
                .showSnackBar(
              SnackBar(
                content: Text(
                    state.message),
              ),
            );
          }
        },
        child: Center(
          child:
              SingleChildScrollView(
            child:
                ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 420,
              ),
              child: Card(
                margin:
                    const EdgeInsets.all(
                        24),
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                          30),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.pets,
                        size: 70,
                        color: Color(
                            0xff66c7d8),
                      ),

                      const SizedBox(
                          height:
                              15),

                      const Text(
                        'Pet Spa',
                        style:
                            TextStyle(
                          fontSize:
                              30,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      const SizedBox(
                          height:
                              10),

                      const Text(
                        'Cuidado premium para tu mascota',
                      ),

                      const SizedBox(
                          height:
                              30),

                      TextField(
                        controller:
                            emailController,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Correo',
                        ),
                      ),

                      const SizedBox(
                          height:
                              20),

                      TextField(
                        controller:
                            passwordController,
                        obscureText:
                            true,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Contraseña',
                        ),
                      ),

                      const SizedBox(
                          height:
                              30),

                      BlocBuilder<
                          AuthBloc,
                          AuthState>(
                        builder:
                            (
                              context,
                              state,
                            ) {
                          if (state
                              is AuthLoading) {
                            return const CircularProgressIndicator();
                          }

                          return SizedBox(
                            width: double
                                .infinity,
                            child:
                                ElevatedButton(
                              onPressed:
                                  login,
                              child:
                                  const Text(
                                'Iniciar Sesión',
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(
                          height:
                              20),

                      SizedBox(
                        width: double
                            .infinity,
                        child:
                            OutlinedButton(
                          onPressed:
                              () {
                            context
                                .read<
                                    AuthBloc>()
                                .add(
                                  GoogleSignInEvent(),
                                );
                          },
                          child:
                              const Text(
                            'Continuar con Google',
                          ),
                        ),
                      ),

                      const SizedBox(
                          height:
                              10),

                      TextButton(
                        onPressed:
                            () {
                          context.go(
                              '/register');
                        },
                        child:
                            const Text(
                          'Crear cuenta',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
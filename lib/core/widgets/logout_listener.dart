import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/auth/presentation/bloc/auth_bloc.dart';
import '../../modules/auth/presentation/bloc/auth_state.dart';
import '../../modules/auth/presentation/screens/login_screen.dart';

class LogoutListener extends StatelessWidget {
  final Widget child;

  const LogoutListener({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
        return current is AuthInitial;
      },

      listener: (context, state) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
          (route) => false,
        );
      },

      child: child,
    );
  }
}
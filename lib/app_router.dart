import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'modules/auth/presentation/screens/login_screen.dart';
import 'modules/auth/presentation/screens/register_screen.dart';

import 'modules/home/presentation/screens/admin_home_screen.dart';
import 'modules/home/presentation/screens/client_home_screen.dart';
import 'modules/home/presentation/screens/groomer_home_screen.dart';
import 'modules/home/presentation/screens/reception_home_screen.dart';

import 'modules/admin/presentation/screens/admin_totp_setup_screen.dart';
import 'modules/admin/presentation/screens/admin_totp_verify_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',

  routes: [
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginScreen(),
    ),

    GoRoute(
      path: '/register',
      builder: (_, __) => const RegisterScreen(),
    ),

    GoRoute(
      path: '/admin',
      builder: (_, __) => const AdminHomeScreen(),
    ),

    GoRoute(
      path: '/client',
      builder: (_, __) => const ClientHomeScreen(),
    ),

    GoRoute(
      path: '/groomer',
      builder: (_, __) => const GroomerHomeScreen(),
    ),

    GoRoute(
      path: '/recepcion',
      builder: (_, __) => const ReceptionHomeScreen(),
    ),

    GoRoute(
      path: '/totp-setup',
      builder: (_, __) => const AdminTotpSetupScreen(),
    ),

    GoRoute(
      path: '/totp-verify/:secret',
      builder: (context, state) {
        final secret = state.pathParameters['secret']!;

        return AdminTotpVerifyScreen(
          secret: secret,
        );
      },
    ),
  ],
);
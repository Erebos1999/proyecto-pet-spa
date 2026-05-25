import 'package:cerberus_pet_spa/modules/admin/presentation/screens/create_employee_screen.dart';
import 'package:cerberus_pet_spa/modules/appointments/presentation/screens/calendar_screen.dart';
import 'package:cerberus_pet_spa/modules/appointments/presentation/screens/create_appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../modules/auth/presentation/screens/login_screen.dart';
import '../../modules/auth/presentation/screens/register_screen.dart';

import '../../modules/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../modules/customer/presentation/screens/customer_dashboard_screen.dart';
import '../../modules/grooming/presentation/screens/groomer_dashboard_screen.dart';
import '../../modules/reception/presentation/screens/reception_dashboard_screen.dart';

import '../../modules/admin/presentation/screens/admin_totp_setup_screen.dart';
import '../../modules/admin/presentation/screens/admin_totp_verify_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',

  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),

    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),

    GoRoute(path: '/admin', builder: (_, __) => const AdminDashboardScreen()),

    GoRoute(
      path: '/client',
      builder: (_, __) => const CustomerDashboardScreen(),
    ),

    GoRoute(
      path: '/groomer',
      builder: (_, __) => const GroomerDashboardScreen(),
    ),

    GoRoute(
      path: '/recepcion',
      builder: (_, __) => const ReceptionDashboardScreen(),
    ),

    GoRoute(
      path: '/totp-setup',
      builder: (_, __) => const AdminTotpSetupScreen(),
    ),

    GoRoute(
      path: '/totp-verify/:secret',
      builder: (context, state) {
        final secret = state.pathParameters['secret']!;

        return AdminTotpVerifyScreen(secret: secret);
      },
    ),
    GoRoute(
      path: '/create-employee',
      builder: (_, __) => const CreateEmployeeScreen(),
    ),
    GoRoute(
      path: '/appointments',
      builder: (_, __) => const CalendarScreen(),
    ),
    GoRoute(
      path: '/create-appointment',
      builder: (_, __) => const CreateAppointmentScreen(),
    ),
  ],
);

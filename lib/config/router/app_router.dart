import 'package:cerberus_pet_spa/modules/admin/presentation/screens/create_employee_screen.dart';
import 'package:cerberus_pet_spa/modules/admin/presentation/screens/edit_product_screen.dart';
import 'package:cerberus_pet_spa/modules/appointments/domain/entities/appointment_entity.dart';
import 'package:cerberus_pet_spa/modules/appointments/presentation/screens/appointment_details_screen.dart';
import 'package:cerberus_pet_spa/modules/appointments/presentation/screens/calendar_screen.dart';
import 'package:cerberus_pet_spa/modules/appointments/presentation/screens/create_appointment_screen.dart';
import 'package:cerberus_pet_spa/modules/appointments/presentation/screens/schedule_screen.dart';

import 'package:cerberus_pet_spa/modules/grooming/presentation/screens/groomer_appointments_screen.dart';
import 'package:cerberus_pet_spa/modules/grooming/presentation/screens/groomer_schedule_screen.dart';
import 'package:cerberus_pet_spa/modules/grooming/presentation/screens/grooming_detail_screen.dart';
import 'package:cerberus_pet_spa/modules/inventory/domain/entities/product_entity.dart';
import 'package:cerberus_pet_spa/modules/inventory/presentation/screens/create_product_screen.dart';
import 'package:cerberus_pet_spa/modules/inventory/presentation/screens/products_screen.dart';

import 'package:cerberus_pet_spa/modules/pets/domain/entities/pet_entity.dart';
import 'package:cerberus_pet_spa/modules/pets/presentation/screens/create_pet_screen.dart';
import 'package:cerberus_pet_spa/modules/pets/presentation/screens/edit_pet_screen.dart';
import 'package:cerberus_pet_spa/modules/pets/presentation/screens/my_pets_screen.dart';

import 'package:cerberus_pet_spa/modules/services/presentation/screens/create_service_screen.dart';
import 'package:cerberus_pet_spa/modules/services/presentation/screens/services_admin_screen.dart';

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

    GoRoute(path: '/appointments', builder: (_, __) => const CalendarScreen()),

    GoRoute(
      path: '/create-appointment',
      builder: (_, __) => const CreateAppointmentScreen(),
    ),

    GoRoute(path: '/my-pets', builder: (_, __) => const MyPetsScreen()),

    GoRoute(path: '/create-pet', builder: (_, __) => const CreatePetScreen()),

    GoRoute(
      path: '/edit-pet',
      builder: (_, state) {
        final pet = state.extra as PetEntity;

        return EditPetScreen(pet: pet);
      },
    ),

    GoRoute(path: '/services', builder: (_, __) => const ServicesAdminScreen()),

    GoRoute(
      path: '/create-service',
      builder: (_, __) => const CreateServiceScreen(),
    ),

    GoRoute(path: '/schedule', builder: (_, __) => const ScheduleScreen()),

    GoRoute(
      path: '/appointment-details',
      builder: (_, state) {
        final appointment = state.extra as AppointmentEntity;

        return AppointmentDetailsScreen(appointment: appointment);
      },
    ),

    GoRoute(
      path: '/groomer-appointments',
      builder: (_, __) => const GroomerAppointmentsScreen(),
    ),

    GoRoute(
      path: '/grooming-detail',
      builder: (_, state) {
        final appointment = state.extra as AppointmentEntity;

        return GroomingDetailScreen(appointment: appointment);
      },
    ),
    GoRoute(
      path: '/groomer-schedule',
      builder: (_, __) => const GroomerScheduleScreen(),
    ),
    GoRoute(path: '/products', builder: (_, __) => const ProductsScreen()),

    GoRoute(
      path: '/create-product',
      builder: (_, __) => const CreateProductScreen(),
    ),

    GoRoute(
      path: '/edit-product',
      builder: (_, state) {
        final product = state.extra as ProductEntity;

        return EditProductScreen(product: product);
      },
    ),
  ],
);

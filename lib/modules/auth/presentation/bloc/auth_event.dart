import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [
        email,
        password,
      ];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;

  final String nombre;
  final String telefono;
  final String ci;
  final String direccion;

  RegisterEvent({
    required this.email,
    required this.password,
    required this.nombre,
    required this.telefono,
    required this.ci,
    required this.direccion,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        nombre,
        telefono,
        ci,
        direccion,
      ];
}
class GoogleSignInEvent extends AuthEvent {}
class LogoutEvent extends AuthEvent {}
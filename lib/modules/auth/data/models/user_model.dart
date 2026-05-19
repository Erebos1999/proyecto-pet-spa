import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.email,
    required super.nombre,
    required super.telefono,
    required super.ci,
    required super.direccion,
    required super.rol,
    required super.estado,
    required super.failedAttempts,
    required super.lockedUntil,
    required super.mfaEnabled,
    required super.mfaSecret,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      nombre: map['nombre'],
      telefono: map['telefono'],
      ci: map['ci'],
      direccion: map['direccion'],
      rol: map['rol'],
      estado: map['estado'],
      failedAttempts: map['failedAttempts'] ?? 0,
      mfaEnabled: map['mfaEnabled'] ?? false,
      mfaSecret: map['mfaSecret'] ?? '',

      lockedUntil: map['lockedUntil'] != null
          ? DateTime.parse(map['lockedUntil'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nombre': nombre,
      'telefono': telefono,
      'ci': ci,
      'direccion': direccion,
      'rol': rol,
      'estado': estado,
      'failedAttempts': failedAttempts,
      'lockedUntil': lockedUntil?.toIso8601String(),
      'mfaEnabled': mfaEnabled,
      'mfaSecret': mfaSecret,
    };
  }
}

class UserEntity {
  final String uid;
  final String email;
  final String nombre;
  final String telefono;
  final String ci;
  final String direccion;
  final String rol;
  final String estado;
  final int failedAttempts;
  final DateTime? lockedUntil;
  final bool mfaEnabled;
  final String mfaSecret;

  UserEntity({
    required this.uid,
    required this.email,
    required this.nombre,
    required this.telefono,
    required this.ci,
    required this.direccion,
    required this.rol,
    required this.estado,
    required this.failedAttempts,
    required this.lockedUntil,
    required this.mfaEnabled,
    required this.mfaSecret,
  });
}

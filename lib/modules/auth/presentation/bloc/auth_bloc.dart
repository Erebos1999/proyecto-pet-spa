import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/auth_repository_impl.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    print('AUTH BLOC CREATED');
    /*on<LoginEvent>((event, emit) async {
      try {
        emit(AuthLoading());

        //await repository.login(email: event.email, password: event.password);

        final user = await repository.login(
          email: event.email,
          password: event.password,
        );

        final completeUser = await repository.getUser(user.uid);

        emit(AuthSuccess(completeUser));

        //emit(AuthSuccess());
        
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });*/
    on<LoginEvent>((event, emit) async {
      try {
        print('1. emit loading');
        emit(AuthLoading());

        print('2. llamando repository.login');
        final user = await repository.login(
          email: event.email,
          password: event.password,
        );

        print('3. login ok: ${user.uid}');

        final completeUser = await repository.getUser(user.uid);

        print('4. emit success');
        emit(AuthSuccess(completeUser));
      } catch (e) {
        print('ERROR LOGIN: $e');
        emit(AuthError(e.toString()));
      }
    });
    on<RegisterEvent>((event, emit) async {
      try {
        emit(AuthLoading());

        final user = await repository.register(
          email: event.email,
          password: event.password,
          nombre: event.nombre,
          telefono: event.telefono,
          ci: event.ci,
          direccion: event.direccion,
        );

        emit(RegisterSuccess('Valide su correo e inicie sesión'));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<GoogleSignInEvent>((event, emit) async {
      try {
        emit(AuthLoading());

        /* await repository.signInWithGoogle();

        emit(AuthSuccess());*/

        final user = await repository.signInWithGoogle();

        final completeUser = await repository.getUser(user.uid);

        emit(AuthSuccess(completeUser));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    on<LogoutEvent>((event, emit) async {
      try {
        await repository.logout();
        print('logout emit authinitial');
        emit(AuthInitial());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}

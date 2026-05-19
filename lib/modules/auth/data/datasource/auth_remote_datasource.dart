import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth =
      FirebaseAuth.instance;

  final GoogleSignIn googleSignIn =
      GoogleSignIn.instance;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    final credential =
        await firebaseAuth
            .createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user
        ?.sendEmailVerification();

    return credential;
  }

  Future<UserCredential> signInWithGoogle() async {
  if (kIsWeb) {
    final googleProvider = GoogleAuthProvider();

    googleProvider.setCustomParameters({
      'prompt': 'select_account',
    });

    return await firebaseAuth.signInWithPopup(
      googleProvider,
    );
  }

  await googleSignIn.initialize(
    clientId:
        '276501101976-3j86t1k9h2qef392eap7fdnsdqhm53k8.apps.googleusercontent.com',
  );

  final GoogleSignInAccount googleUser =
      await googleSignIn.authenticate();

  final GoogleSignInAuthentication googleAuth =
      googleUser.authentication;

  final credential =
      GoogleAuthProvider.credential(
    idToken: googleAuth.idToken,
  );

  return await firebaseAuth.signInWithCredential(
    credential,
  );
}


  Future<void> logout() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
  }
}
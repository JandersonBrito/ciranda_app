import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/constants/firestore_collections.dart';
import '../../../models/usuario_model.dart';
import '../../../providers/firebase_providers.dart';
import 'auth_remote_datasource.dart';

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn();
});

final authDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    datasource: ref.watch(authDatasourceProvider),
    firestore: ref.watch(firestoreProvider),
  );
});

class AuthRepository {
  AuthRepository({
    required AuthRemoteDatasource datasource,
    required FirebaseFirestore firestore,
  })  : _datasource = datasource,
        _firestore = firestore;

  final AuthRemoteDatasource _datasource;
  final FirebaseFirestore _firestore;

  /// Login com e-mail e senha
  Future<UsuarioModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _datasource.signInWithEmailPassword(
      email: email,
      password: password,
    );
    return _getOrCreateUser(credential.user!);
  }

  /// Cadastro com e-mail e senha
  Future<UsuarioModel> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _datasource.createUserWithEmailPassword(
      email: email,
      password: password,
      displayName: displayName,
    );
    return _createUser(credential.user!, displayName: displayName);
  }

  /// Login com Google
  Future<UsuarioModel> signInWithGoogle() async {
    final credential = await _datasource.signInWithGoogle();
    return _getOrCreateUser(credential.user!);
  }

  /// Logout
  Future<void> signOut() => _datasource.signOut();

  /// Recuperação de senha
  Future<void> sendPasswordResetEmail(String email) =>
      _datasource.sendPasswordResetEmail(email);

  // ── Helpers privados ──────────────────────────────────────────────────────

  Future<UsuarioModel> _getOrCreateUser(User firebaseUser) async {
    final doc = await _firestore
        .collection(FirestoreCollections.users)
        .doc(firebaseUser.uid)
        .get();

    if (doc.exists) {
      return UsuarioModel.fromFirestore(doc);
    }

    return _createUser(firebaseUser);
  }

  Future<UsuarioModel> _createUser(
    User firebaseUser, {
    String? displayName,
  }) async {
    final user = UsuarioModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: displayName ??
          firebaseUser.displayName ??
          firebaseUser.email?.split('@').first ??
          'Brincante',
      fotoUrl: firebaseUser.photoURL,
      role: UserRole.publico,
    );

    await _firestore
        .collection(FirestoreCollections.users)
        .doc(user.uid)
        .set(user.toFirestore());

    return user;
  }
}

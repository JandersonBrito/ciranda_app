import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/usuario_model.dart';
import '../../../providers/firebase_providers.dart';
import 'perfil_datasource.dart';

final perfilDatasourceProvider = Provider<PerfilDatasource>((ref) {
  return PerfilDatasource(firestore: ref.watch(firestoreProvider));
});

final perfilRepositoryProvider = Provider<PerfilRepository>((ref) {
  return PerfilRepository(
    datasource: ref.watch(perfilDatasourceProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
});

class PerfilRepository {
  PerfilRepository({
    required PerfilDatasource datasource,
    required FirebaseAuth auth,
  })  : _datasource = datasource,
        _auth = auth;

  final PerfilDatasource _datasource;
  final FirebaseAuth _auth;

  Stream<UsuarioModel> getUsuario(String uid) =>
      _datasource.getUsuario(uid);

  Future<void> updateDisplayName(String uid, String name) async {
    await _auth.currentUser?.updateDisplayName(name);
    await _datasource.updateUsuario(
      UsuarioModel(
        uid: uid,
        email: _auth.currentUser?.email ?? '',
        displayName: name,
      ),
    );
  }

  Future<void> updateAvatar(String uid, String fotoUrl) async {
    await _auth.currentUser?.updatePhotoURL(fotoUrl);
    await _datasource.updateAvatar(uid, fotoUrl);
  }

  Future<void> updateUsuario(UsuarioModel usuario) =>
      _datasource.updateUsuario(usuario);
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_collections.dart';
import '../../../models/usuario_model.dart';

class PerfilDatasource {
  PerfilDatasource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Stream<UsuarioModel> getUsuario(String uid) {
    return _firestore
        .collection(FirestoreCollections.users)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (!doc.exists) throw Exception('Usuário não encontrado');
      return UsuarioModel.fromFirestore(doc);
    });
  }

  Future<void> updateUsuario(UsuarioModel usuario) {
    return _firestore
        .collection(FirestoreCollections.users)
        .doc(usuario.uid)
        .update(usuario.toFirestore());
  }

  Future<void> updateAvatar(String uid, String fotoUrl) {
    return _firestore
        .collection(FirestoreCollections.users)
        .doc(uid)
        .update({'fotoUrl': fotoUrl});
  }
}

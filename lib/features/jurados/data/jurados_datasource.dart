import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_collections.dart';
import '../../../models/jurado_model.dart';
import '../../../models/voto_model.dart';

class JuradosDatasource {
  JuradosDatasource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Stream<List<JuradoModel>> getJurados(String festivalId) {
    return _firestore
        .collection(FirestoreCollections.jurados)
        .where('festivalId', isEqualTo: festivalId)
        .where('isAtivo', isEqualTo: true)
        .snapshots()
        .map((s) => s.docs.map(JuradoModel.fromFirestore).toList());
  }

  Future<JuradoModel?> getJuradoByUid(String uid) async {
    final snap = await _firestore
        .collection(FirestoreCollections.jurados)
        .where('uid', isEqualTo: uid)
        .where('isAtivo', isEqualTo: true)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return JuradoModel.fromFirestore(snap.docs.first);
  }

  /// Votos já registrados por jurado em uma quadrilha
  Stream<List<VotoModel>> getVotos({
    required String festivalId,
    required String quadrilhaId,
    required String juradoId,
  }) {
    return _firestore
        .collection(FirestoreCollections.votos)
        .where('festivalId', isEqualTo: festivalId)
        .where('quadrilhaId', isEqualTo: quadrilhaId)
        .where('juradoId', isEqualTo: juradoId)
        .snapshots()
        .map((s) => s.docs.map(VotoModel.fromFirestore).toList());
  }

  /// Submeter voto de uma categoria
  Future<void> submitVoto(VotoModel voto) async {
    // Verifica se já votou nessa categoria/quadrilha
    final existing = await _firestore
        .collection(FirestoreCollections.votos)
        .where('festivalId', isEqualTo: voto.festivalId)
        .where('quadrilhaId', isEqualTo: voto.quadrilhaId)
        .where('juradoId', isEqualTo: voto.juradoId)
        .where('categoriaId', isEqualTo: voto.categoriaId)
        .get();

    if (existing.docs.isNotEmpty) {
      // Atualiza o voto existente
      await existing.docs.first.reference.update(voto.toFirestore());
    } else {
      // Cria novo voto
      await _firestore
          .collection(FirestoreCollections.votos)
          .add(voto.toFirestore());
    }
  }
}

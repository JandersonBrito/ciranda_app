import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_collections.dart';
import '../../../models/resultado_model.dart';

class ResultadosDatasource {
  ResultadosDatasource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Stream<List<ResultadoModel>> getResultados(String festivalId) {
    return _firestore
        .collection(FirestoreCollections.resultados)
        .where('festivalId', isEqualTo: festivalId)
        .where('isPublicado', isEqualTo: true)
        .orderBy('posicao')
        .snapshots()
        .map((s) => s.docs.map(ResultadoModel.fromFirestore).toList());
  }

  Stream<List<ResultadoModel>> getAllResultados({bool adminView = false}) {
    var query = _firestore
        .collection(FirestoreCollections.resultados)
        .orderBy('publicadoEm', descending: true);

    if (!adminView) {
      query = query.where('isPublicado', isEqualTo: true) as Query<Map<String, dynamic>>;
    }

    return (query as Query<Map<String, dynamic>>)
        .snapshots()
        .map((s) => s.docs.map(ResultadoModel.fromFirestore).toList());
  }

  Future<void> publishResultados(String festivalId) async {
    final batch = _firestore.batch();
    final snap = await _firestore
        .collection(FirestoreCollections.resultados)
        .where('festivalId', isEqualTo: festivalId)
        .get();

    for (final doc in snap.docs) {
      batch.update(doc.reference, {
        'isPublicado': true,
        'publicadoEm': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  Future<void> upsertResultado(ResultadoModel resultado) async {
    final existing = await _firestore
        .collection(FirestoreCollections.resultados)
        .where('festivalId', isEqualTo: resultado.festivalId)
        .where('quadrilhaId', isEqualTo: resultado.quadrilhaId)
        .get();

    if (existing.docs.isNotEmpty) {
      await existing.docs.first.reference.update(resultado.toFirestore());
    } else {
      await _firestore
          .collection(FirestoreCollections.resultados)
          .add(resultado.toFirestore());
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_collections.dart';
import '../../../models/quadrilha_model.dart';

class QuadrilhasDatasource {
  QuadrilhasDatasource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference get _col =>
      _firestore.collection(FirestoreCollections.quadrilhas);

  Stream<List<QuadrilhaModel>> getQuadrilhas(String festivalId) {
    return _col
        .where('festivalId', isEqualTo: festivalId)
        .orderBy('posicao')
        .snapshots()
        .map((s) => s.docs.map(QuadrilhaModel.fromFirestore).toList());
  }

  Stream<List<QuadrilhaModel>> getAllQuadrilhas() {
    return _col
        .orderBy('nome')
        .snapshots()
        .map((s) => s.docs.map(QuadrilhaModel.fromFirestore).toList());
  }

  Stream<QuadrilhaModel> getQuadrilhaById(String id) {
    return _col.doc(id).snapshots().map((doc) {
      if (!doc.exists) throw Exception('Quadrilha não encontrada');
      return QuadrilhaModel.fromFirestore(doc);
    });
  }

  Stream<List<IntegranteModel>> getIntegrantes(String quadrilhaId) {
    return _col
        .doc(quadrilhaId)
        .collection(FirestoreCollections.integrantes)
        .orderBy('nome')
        .snapshots()
        .map((s) => s.docs.map(IntegranteModel.fromFirestore).toList());
  }

  Future<void> createQuadrilha(QuadrilhaModel quadrilha) {
    return _col.add(quadrilha.toFirestore());
  }

  Future<void> updateQuadrilha(QuadrilhaModel quadrilha) {
    return _col.doc(quadrilha.id).update(quadrilha.toFirestore());
  }
}

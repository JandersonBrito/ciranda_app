import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_collections.dart';
import '../../../models/categoria_model.dart';
import '../../../models/festival_model.dart';

class FestivaisDatasource {
  FestivaisDatasource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference get _col =>
      _firestore.collection(FirestoreCollections.festivais);

  /// Stream de todos os festivais ativos
  Stream<List<FestivalModel>> getFestivais() {
    return _col
        .orderBy('dataInicio', descending: true)
        .snapshots()
        .map((s) => s.docs.map(FestivalModel.fromFirestore).toList());
  }

  /// Stream de um festival específico
  Stream<FestivalModel> getFestivalById(String festivalId) {
    return _col.doc(festivalId).snapshots().map((doc) {
      if (!doc.exists) throw Exception('Festival não encontrado');
      return FestivalModel.fromFirestore(doc);
    });
  }

  /// Stream de categorias de um festival
  Stream<List<CategoriaModel>> getCategorias(String festivalId) {
    return _col
        .doc(festivalId)
        .collection(FirestoreCollections.categorias)
        .orderBy('ordem')
        .snapshots()
        .map((s) => s.docs.map(CategoriaModel.fromFirestore).toList());
  }

  /// Busca festivais por nome (client-side filter — ideal usar Algolia em prod)
  Stream<List<FestivalModel>> searchFestivais(String query) {
    return getFestivais().map((festivais) {
      final q = query.toLowerCase();
      return festivais
          .where((f) =>
              f.nome.toLowerCase().contains(q) ||
              f.cidade.toLowerCase().contains(q) ||
              f.estado.toLowerCase().contains(q))
          .toList();
    });
  }

  /// Criar festival
  Future<DocumentReference> createFestival(FestivalModel festival) {
    return _col.add(festival.toFirestore());
  }

  /// Atualizar festival
  Future<void> updateFestival(FestivalModel festival) {
    return _col.doc(festival.id).update(festival.toFirestore());
  }

  /// Remover festival
  Future<void> deleteFestival(String festivalId) {
    return _col.doc(festivalId).delete();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/quadrilha_model.dart';
import '../../../providers/firebase_providers.dart';
import 'quadrilhas_datasource.dart';

final quadrilhasDatasourceProvider = Provider<QuadrilhasDatasource>((ref) {
  return QuadrilhasDatasource(firestore: ref.watch(firestoreProvider));
});

final quadrilhasRepositoryProvider = Provider<QuadrilhasRepository>((ref) {
  return QuadrilhasRepository(ref.watch(quadrilhasDatasourceProvider));
});

class QuadrilhasRepository {
  QuadrilhasRepository(this._datasource);

  final QuadrilhasDatasource _datasource;

  Stream<List<QuadrilhaModel>> getQuadrilhas(String festivalId) =>
      _datasource.getQuadrilhas(festivalId);

  Stream<List<QuadrilhaModel>> getAllQuadrilhas() =>
      _datasource.getAllQuadrilhas();

  Stream<QuadrilhaModel> getQuadrilhaById(String id) =>
      _datasource.getQuadrilhaById(id);

  Stream<List<IntegranteModel>> getIntegrantes(String quadrilhaId) =>
      _datasource.getIntegrantes(quadrilhaId);

  Future<void> createQuadrilha(QuadrilhaModel quadrilha) =>
      _datasource.createQuadrilha(quadrilha);

  Future<void> updateQuadrilha(QuadrilhaModel quadrilha) =>
      _datasource.updateQuadrilha(quadrilha);
}

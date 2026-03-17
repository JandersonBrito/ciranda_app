import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/quadrilha_model.dart';
import '../../data/quadrilhas_repository.dart';

final quadrilhasListProvider =
    StreamProvider.family<List<QuadrilhaModel>, String>((ref, festivalId) {
  return ref.watch(quadrilhasRepositoryProvider).getQuadrilhas(festivalId);
});

final allQuadrilhasProvider = StreamProvider<List<QuadrilhaModel>>((ref) {
  return ref.watch(quadrilhasRepositoryProvider).getAllQuadrilhas();
});

final quadrilhaDetailProvider =
    StreamProvider.family<QuadrilhaModel, String>((ref, quadrilhaId) {
  return ref.watch(quadrilhasRepositoryProvider).getQuadrilhaById(quadrilhaId);
});

final integrantesProvider =
    StreamProvider.family<List<IntegranteModel>, String>((ref, quadrilhaId) {
  return ref.watch(quadrilhasRepositoryProvider).getIntegrantes(quadrilhaId);
});

class QuadrilhasSearchController extends StateNotifier<String> {
  QuadrilhasSearchController() : super('');
  void setQuery(String q) => state = q;
  void clear() => state = '';
}

final quadrilhasSearchControllerProvider =
    StateNotifierProvider<QuadrilhasSearchController, String>(
  (ref) => QuadrilhasSearchController(),
);

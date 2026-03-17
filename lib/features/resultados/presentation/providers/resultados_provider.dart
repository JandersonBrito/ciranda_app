import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/resultado_model.dart';
import '../../data/resultados_repository.dart';

final resultadosFestivalProvider =
    StreamProvider.family<List<ResultadoModel>, String>((ref, festivalId) {
  return ref.watch(resultadosRepositoryProvider).getResultados(festivalId);
});

final todosResultadosProvider =
    StreamProvider<List<ResultadoModel>>((ref) {
  return ref.watch(resultadosRepositoryProvider).getAllResultados();
});

/// Festival selecionado na tela de resultados
class ResultadosFestivalController extends StateNotifier<String?> {
  ResultadosFestivalController() : super(null);
  void selectFestival(String? id) => state = id;
}

final resultadosFestivalControllerProvider =
    StateNotifierProvider<ResultadosFestivalController, String?>(
  (ref) => ResultadosFestivalController(),
);

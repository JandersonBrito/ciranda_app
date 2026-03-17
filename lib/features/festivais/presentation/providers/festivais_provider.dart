import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/categoria_model.dart';
import '../../../../models/festival_model.dart';
import '../../data/festivais_repository.dart';

/// Lista todos os festivais
final festivaisListProvider = StreamProvider<List<FestivalModel>>((ref) {
  return ref.watch(festivaisRepositoryProvider).getFestivais();
});

/// Detalhe de um festival específico
final festivalDetailProvider =
    StreamProvider.family<FestivalModel, String>((ref, festivalId) {
  return ref.watch(festivaisRepositoryProvider).getFestivalById(festivalId);
});

/// Categorias de um festival
final festivalCategoriasProvider =
    StreamProvider.family<List<CategoriaModel>, String>((ref, festivalId) {
  return ref.watch(festivaisRepositoryProvider).getCategorias(festivalId);
});

/// Busca de festivais
final festivaisBuscaProvider =
    StreamProvider.family<List<FestivalModel>, String>((ref, query) {
  if (query.isEmpty) {
    return ref.watch(festivaisRepositoryProvider).getFestivais();
  }
  return ref.watch(festivaisRepositoryProvider).searchFestivais(query);
});

/// Controller da busca
class FestivaisSearchController extends StateNotifier<String> {
  FestivaisSearchController() : super('');

  void setQuery(String query) => state = query;
  void clear() => state = '';
}

final festivaisSearchControllerProvider =
    StateNotifierProvider<FestivaisSearchController, String>(
  (ref) => FestivaisSearchController(),
);

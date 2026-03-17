import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../models/jurado_model.dart';
import '../../../../models/voto_model.dart';
import '../../../../providers/firebase_providers.dart';
import '../../data/jurados_repository.dart';

/// Lista de jurados de um festival
final juradosListProvider =
    StreamProvider.family<List<JuradoModel>, String>((ref, festivalId) {
  return ref.watch(juradosRepositoryProvider).getJurados(festivalId);
});

/// Jurado do usuário atual
final currentJuradoProvider = FutureProvider<JuradoModel?>((ref) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return null;
  return ref.watch(juradosRepositoryProvider).getJuradoByUid(uid);
});

/// Votos do jurado atual para uma quadrilha em um festival
final votosJuradoProvider = StreamProvider.family<List<VotoModel>,
    ({String festivalId, String quadrilhaId, String juradoId})>((ref, args) {
  return ref.watch(juradosRepositoryProvider).getVotos(
        festivalId: args.festivalId,
        quadrilhaId: args.quadrilhaId,
        juradoId: args.juradoId,
      );
});

// ── Controlador de Votação ────────────────────────────────────────────────

class VotacaoState {
  const VotacaoState({
    this.notas = const {},
    this.isSubmitting = false,
    this.submitted = false,
    this.error,
  });

  final Map<String, double> notas; // categoriaId -> nota
  final bool isSubmitting;
  final bool submitted;
  final String? error;

  VotacaoState copyWith({
    Map<String, double>? notas,
    bool? isSubmitting,
    bool? submitted,
    String? error,
  }) =>
      VotacaoState(
        notas: notas ?? this.notas,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        submitted: submitted ?? this.submitted,
        error: error ?? this.error,
      );
}

class VotacaoController extends StateNotifier<VotacaoState> {
  VotacaoController(this._ref, this._juradoId) : super(const VotacaoState());

  final Ref _ref;
  final String _juradoId;
  final _uuid = const Uuid();

  void setNota(String categoriaId, double nota) {
    state = state.copyWith(
      notas: {...state.notas, categoriaId: nota},
    );
  }

  /// Pré-carrega notas já salvas para evitar sobreposição
  void loadExistingVotos(List<VotoModel> votos) {
    final notas = {for (final v in votos) v.categoriaId: v.nota};
    state = state.copyWith(notas: notas, submitted: votos.isNotEmpty);
  }

  Future<void> submitVotos({
    required String festivalId,
    required String quadrilhaId,
    required String juradoNome,
    required List<String> categoriaIds,
    required List<String> categoriaNomes,
  }) async {
    // Valida que todas as categorias têm nota
    for (final id in categoriaIds) {
      if (!state.notas.containsKey(id)) {
        state = state.copyWith(
            error: 'Preencha a nota de todas as categorias');
        return;
      }
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final repo = _ref.read(juradosRepositoryProvider);
      for (int i = 0; i < categoriaIds.length; i++) {
        final voto = VotoModel(
          id: _uuid.v4(),
          juradoId: _juradoId,
          juradoNome: juradoNome,
          quadrilhaId: quadrilhaId,
          festivalId: festivalId,
          categoriaId: categoriaIds[i],
          categoriaNome: categoriaNomes[i],
          nota: state.notas[categoriaIds[i]]!,
          timestamp: DateTime.now(),
        );
        await repo.submitVoto(voto);
      }
      state = state.copyWith(isSubmitting: false, submitted: true);
    } catch (e) {
      state = state.copyWith(
          isSubmitting: false, error: 'Erro ao salvar votos: $e');
    }
  }

  void reset() => state = const VotacaoState();
}

final votacaoControllerProvider = StateNotifierProvider.family<
    VotacaoController, VotacaoState, String>((ref, juradoId) {
  return VotacaoController(ref, juradoId);
});

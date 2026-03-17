import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/usuario_model.dart';
import '../../../../providers/firebase_providers.dart';
import '../../data/perfil_repository.dart';

/// Stream do perfil do usuário atual
final perfilProvider = StreamProvider<UsuarioModel?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);
  return ref.watch(perfilRepositoryProvider).getUsuario(uid);
});

/// Controller de edição do perfil
class PerfilController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  PerfilRepository get _repo => ref.read(perfilRepositoryProvider);

  Future<void> updateDisplayName(String uid, String name) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.updateDisplayName(uid, name),
    );
  }

  Future<void> updateAvatar(String uid, String fotoUrl) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.updateAvatar(uid, fotoUrl),
    );
  }

  Future<void> updatePerfil(UsuarioModel usuario) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.updateUsuario(usuario),
    );
  }
}

final perfilControllerProvider =
    AsyncNotifierProvider<PerfilController, void>(PerfilController.new);

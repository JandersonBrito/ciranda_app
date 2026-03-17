import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/auth_repository.dart';

/// Controller de autenticação — login, cadastro, logout
class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.signInWithEmail(email: email, password: password),
    );
  }

  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.registerWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repo.signInWithGoogle);
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repo.signOut);
  }

  Future<void> sendPasswordReset(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repo.sendPasswordResetEmail(email),
    );
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, void>(AuthController.new);

/// Mensagem de erro legível para FirebaseAuthException
String authErrorMessage(Object error) {
  if (error is FirebaseAuthException) {
    return switch (error.code) {
      'user-not-found' => 'Usuário não encontrado.',
      'wrong-password' => 'Senha incorreta.',
      'email-already-in-use' => 'E-mail já cadastrado.',
      'weak-password' => 'Senha muito fraca. Use pelo menos 6 caracteres.',
      'invalid-email' => 'E-mail inválido.',
      'user-disabled' => 'Conta desativada. Contate o suporte.',
      'too-many-requests' => 'Muitas tentativas. Aguarde e tente novamente.',
      'network-request-failed' => 'Sem conexão com a internet.',
      'sign-in-cancelled' => 'Login cancelado.',
      _ => error.message ?? 'Erro de autenticação. Tente novamente.',
    };
  }
  return 'Erro inesperado. Tente novamente.';
}

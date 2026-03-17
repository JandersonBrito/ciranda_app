import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Firebase Auth singleton
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

/// Firestore singleton
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// Firebase Storage singleton
final storageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

/// Stream do estado de autenticação
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

/// Usuário atual (pode ser null se não autenticado)
final currentFirebaseUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateChangesProvider).valueOrNull;
});

/// UID do usuário atual
final currentUidProvider = Provider<String?>((ref) {
  return ref.watch(currentFirebaseUserProvider)?.uid;
});

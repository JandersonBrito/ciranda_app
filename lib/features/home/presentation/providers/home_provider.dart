import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../models/festival_model.dart';
import '../../../../models/resultado_model.dart';
import '../../../../providers/firebase_providers.dart';

/// Festivais ativos (em andamento ou próximos)
final festivaisDestaquesProvider =
    StreamProvider<List<FestivalModel>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore
      .collection(FirestoreCollections.festivais)
      .where('isAtivo', isEqualTo: true)
      .orderBy('dataInicio')
      .limit(5)
      .snapshots()
      .map((snap) =>
          snap.docs.map(FestivalModel.fromFirestore).toList());
});

/// Próximos festivais (que ainda não começaram)
final proximosFestivaisProvider =
    StreamProvider<List<FestivalModel>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final agora = Timestamp.fromDate(DateTime.now());
  return firestore
      .collection(FirestoreCollections.festivais)
      .where('dataInicio', isGreaterThan: agora)
      .orderBy('dataInicio')
      .limit(10)
      .snapshots()
      .map((snap) =>
          snap.docs.map(FestivalModel.fromFirestore).toList());
});

/// Últimos resultados publicados
final ultimosResultadosProvider =
    StreamProvider<List<ResultadoModel>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore
      .collection(FirestoreCollections.resultados)
      .where('isPublicado', isEqualTo: true)
      .orderBy('publicadoEm', descending: true)
      .limit(10)
      .snapshots()
      .map((snap) =>
          snap.docs.map(ResultadoModel.fromFirestore).toList());
});

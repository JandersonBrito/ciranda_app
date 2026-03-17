import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/categoria_model.dart';
import '../../../models/festival_model.dart';
import '../../../providers/firebase_providers.dart';
import 'festivais_datasource.dart';

final festivaisDatasourceProvider = Provider<FestivaisDatasource>((ref) {
  return FestivaisDatasource(firestore: ref.watch(firestoreProvider));
});

final festivaisRepositoryProvider = Provider<FestivaisRepository>((ref) {
  return FestivaisRepository(ref.watch(festivaisDatasourceProvider));
});

class FestivaisRepository {
  FestivaisRepository(this._datasource);

  final FestivaisDatasource _datasource;

  Stream<List<FestivalModel>> getFestivais() =>
      _datasource.getFestivais();

  Stream<FestivalModel> getFestivalById(String id) =>
      _datasource.getFestivalById(id);

  Stream<List<CategoriaModel>> getCategorias(String festivalId) =>
      _datasource.getCategorias(festivalId);

  Stream<List<FestivalModel>> searchFestivais(String query) =>
      _datasource.searchFestivais(query);

  Future<void> createFestival(FestivalModel festival) =>
      _datasource.createFestival(festival);

  Future<void> updateFestival(FestivalModel festival) =>
      _datasource.updateFestival(festival);

  Future<void> deleteFestival(String festivalId) =>
      _datasource.deleteFestival(festivalId);
}

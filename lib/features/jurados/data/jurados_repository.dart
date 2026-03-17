import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/jurado_model.dart';
import '../../../models/voto_model.dart';
import '../../../providers/firebase_providers.dart';
import 'jurados_datasource.dart';

final juradosDatasourceProvider = Provider<JuradosDatasource>((ref) {
  return JuradosDatasource(firestore: ref.watch(firestoreProvider));
});

final juradosRepositoryProvider = Provider<JuradosRepository>((ref) {
  return JuradosRepository(ref.watch(juradosDatasourceProvider));
});

class JuradosRepository {
  JuradosRepository(this._datasource);

  final JuradosDatasource _datasource;

  Stream<List<JuradoModel>> getJurados(String festivalId) =>
      _datasource.getJurados(festivalId);

  Future<JuradoModel?> getJuradoByUid(String uid) =>
      _datasource.getJuradoByUid(uid);

  Stream<List<VotoModel>> getVotos({
    required String festivalId,
    required String quadrilhaId,
    required String juradoId,
  }) =>
      _datasource.getVotos(
        festivalId: festivalId,
        quadrilhaId: quadrilhaId,
        juradoId: juradoId,
      );

  Future<void> submitVoto(VotoModel voto) =>
      _datasource.submitVoto(voto);
}

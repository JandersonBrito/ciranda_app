import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/resultado_model.dart';
import '../../../providers/firebase_providers.dart';
import 'resultados_datasource.dart';

final resultadosDatasourceProvider = Provider<ResultadosDatasource>((ref) {
  return ResultadosDatasource(firestore: ref.watch(firestoreProvider));
});

final resultadosRepositoryProvider = Provider<ResultadosRepository>((ref) {
  return ResultadosRepository(ref.watch(resultadosDatasourceProvider));
});

class ResultadosRepository {
  ResultadosRepository(this._datasource);

  final ResultadosDatasource _datasource;

  Stream<List<ResultadoModel>> getResultados(String festivalId) =>
      _datasource.getResultados(festivalId);

  Stream<List<ResultadoModel>> getAllResultados({bool adminView = false}) =>
      _datasource.getAllResultados(adminView: adminView);

  Future<void> publishResultados(String festivalId) =>
      _datasource.publishResultados(festivalId);

  Future<void> upsertResultado(ResultadoModel resultado) =>
      _datasource.upsertResultado(resultado);
}

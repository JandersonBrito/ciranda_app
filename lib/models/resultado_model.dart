import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ResultadoModel extends Equatable {
  const ResultadoModel({
    required this.id,
    required this.festivalId,
    required this.quadrilhaId,
    required this.quadrilhaNome,
    required this.quadrilhaFotoUrl,
    required this.municipio,
    required this.estado,
    required this.pontuacaoFinal,
    required this.posicao,
    this.notasPorCategoria = const {},
    this.publicadoEm,
    this.isPublicado = false,
  });

  final String id;
  final String festivalId;
  final String quadrilhaId;
  final String quadrilhaNome;
  final String? quadrilhaFotoUrl;
  final String municipio;
  final String estado;
  final double pontuacaoFinal;
  final int posicao;
  final Map<String, double> notasPorCategoria;
  final DateTime? publicadoEm;
  final bool isPublicado;

  String get cidadeEstado => '$municipio/$estado';

  String get posicaoLabel {
    return switch (posicao) {
      1 => '1º lugar',
      2 => '2º lugar',
      3 => '3º lugar',
      _ => '${posicao}º lugar',
    };
  }

  String get posicaoEmoji {
    return switch (posicao) {
      1 => '🏆',
      2 => '🥈',
      3 => '🥉',
      _ => '🎭',
    };
  }

  factory ResultadoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final notasMap = data['notasPorCategoria'] as Map<String, dynamic>? ?? {};
    return ResultadoModel(
      id: doc.id,
      festivalId: data['festivalId'] as String? ?? '',
      quadrilhaId: data['quadrilhaId'] as String? ?? '',
      quadrilhaNome: data['quadrilhaNome'] as String? ?? '',
      quadrilhaFotoUrl: data['quadrilhaFotoUrl'] as String?,
      municipio: data['municipio'] as String? ?? '',
      estado: data['estado'] as String? ?? '',
      pontuacaoFinal: (data['pontuacaoFinal'] as num?)?.toDouble() ?? 0.0,
      posicao: data['posicao'] as int? ?? 0,
      notasPorCategoria: notasMap.map(
          (k, v) => MapEntry(k, (v as num).toDouble())),
      publicadoEm: (data['publicadoEm'] as Timestamp?)?.toDate(),
      isPublicado: data['isPublicado'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'festivalId': festivalId,
        'quadrilhaId': quadrilhaId,
        'quadrilhaNome': quadrilhaNome,
        'quadrilhaFotoUrl': quadrilhaFotoUrl,
        'municipio': municipio,
        'estado': estado,
        'pontuacaoFinal': pontuacaoFinal,
        'posicao': posicao,
        'notasPorCategoria': notasPorCategoria,
        'publicadoEm': publicadoEm != null
            ? Timestamp.fromDate(publicadoEm!)
            : null,
        'isPublicado': isPublicado,
      };

  ResultadoModel copyWith({
    String? id,
    String? festivalId,
    String? quadrilhaId,
    String? quadrilhaNome,
    String? quadrilhaFotoUrl,
    String? municipio,
    String? estado,
    double? pontuacaoFinal,
    int? posicao,
    Map<String, double>? notasPorCategoria,
    DateTime? publicadoEm,
    bool? isPublicado,
  }) =>
      ResultadoModel(
        id: id ?? this.id,
        festivalId: festivalId ?? this.festivalId,
        quadrilhaId: quadrilhaId ?? this.quadrilhaId,
        quadrilhaNome: quadrilhaNome ?? this.quadrilhaNome,
        quadrilhaFotoUrl: quadrilhaFotoUrl ?? this.quadrilhaFotoUrl,
        municipio: municipio ?? this.municipio,
        estado: estado ?? this.estado,
        pontuacaoFinal: pontuacaoFinal ?? this.pontuacaoFinal,
        posicao: posicao ?? this.posicao,
        notasPorCategoria: notasPorCategoria ?? this.notasPorCategoria,
        publicadoEm: publicadoEm ?? this.publicadoEm,
        isPublicado: isPublicado ?? this.isPublicado,
      );

  @override
  List<Object?> get props => [id, quadrilhaId, festivalId, posicao];
}

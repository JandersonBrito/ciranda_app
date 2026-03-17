import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class VotoModel extends Equatable {
  const VotoModel({
    required this.id,
    required this.juradoId,
    required this.juradoNome,
    required this.quadrilhaId,
    required this.festivalId,
    required this.categoriaId,
    required this.categoriaNome,
    required this.nota,
    this.observacao,
    this.timestamp,
  }) : assert(nota >= 0.0 && nota <= 10.0, 'Nota deve ser entre 0 e 10');

  final String id;
  final String juradoId;
  final String juradoNome;
  final String quadrilhaId;
  final String festivalId;
  final String categoriaId;
  final String categoriaNome;
  final double nota;
  final String? observacao;
  final DateTime? timestamp;

  factory VotoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return VotoModel(
      id: doc.id,
      juradoId: data['juradoId'] as String? ?? '',
      juradoNome: data['juradoNome'] as String? ?? '',
      quadrilhaId: data['quadrilhaId'] as String? ?? '',
      festivalId: data['festivalId'] as String? ?? '',
      categoriaId: data['categoriaId'] as String? ?? '',
      categoriaNome: data['categoriaNome'] as String? ?? '',
      nota: (data['nota'] as num?)?.toDouble() ?? 0.0,
      observacao: data['observacao'] as String?,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'juradoId': juradoId,
        'juradoNome': juradoNome,
        'quadrilhaId': quadrilhaId,
        'festivalId': festivalId,
        'categoriaId': categoriaId,
        'categoriaNome': categoriaNome,
        'nota': nota,
        'observacao': observacao,
        'timestamp': timestamp != null
            ? Timestamp.fromDate(timestamp!)
            : FieldValue.serverTimestamp(),
      };

  @override
  List<Object?> get props =>
      [id, juradoId, quadrilhaId, categoriaId, festivalId];
}

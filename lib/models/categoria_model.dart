import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CategoriaModel extends Equatable {
  const CategoriaModel({
    required this.id,
    required this.nome,
    required this.peso,
    required this.festivalId,
    this.descricao = '',
    this.ordem = 0,
  });

  final String id;
  final String nome;
  final double peso; // peso em % (ex: 0.20 = 20%)
  final String festivalId;
  final String descricao;
  final int ordem;

  String get pesoLabel => '${(peso * 100).toStringAsFixed(0)}%';

  factory CategoriaModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoriaModel(
      id: doc.id,
      nome: data['nome'] as String? ?? '',
      peso: (data['peso'] as num?)?.toDouble() ?? 0.0,
      festivalId: data['festivalId'] as String? ?? '',
      descricao: data['descricao'] as String? ?? '',
      ordem: data['ordem'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'nome': nome,
        'peso': peso,
        'festivalId': festivalId,
        'descricao': descricao,
        'ordem': ordem,
      };

  @override
  List<Object?> get props => [id, nome, peso, festivalId];
}

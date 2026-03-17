import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class QuadrilhaModel extends Equatable {
  const QuadrilhaModel({
    required this.id,
    required this.nome,
    required this.municipio,
    required this.estado,
    required this.anoFundacao,
    this.fotoUrl,
    this.logoUrl,
    this.descricao = '',
    this.festivalId,
    this.pontuacaoTotal = 0.0,
    this.posicao = 0,
    this.seguidores = 0,
    this.createdAt,
  });

  final String id;
  final String nome;
  final String municipio;
  final String estado;
  final int anoFundacao;
  final String? fotoUrl;
  final String? logoUrl;
  final String descricao;
  final String? festivalId;
  final double pontuacaoTotal;
  final int posicao;
  final int seguidores;
  final DateTime? createdAt;

  String get cidadeEstado => '$municipio/$estado';

  String get posicaoLabel {
    if (posicao == 0) return '--';
    return '${posicao}º';
  }

  factory QuadrilhaModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return QuadrilhaModel(
      id: doc.id,
      nome: data['nome'] as String? ?? '',
      municipio: data['municipio'] as String? ?? '',
      estado: data['estado'] as String? ?? '',
      anoFundacao: data['anoFundacao'] as int? ?? DateTime.now().year,
      fotoUrl: data['fotoUrl'] as String?,
      logoUrl: data['logoUrl'] as String?,
      descricao: data['descricao'] as String? ?? '',
      festivalId: data['festivalId'] as String?,
      pontuacaoTotal: (data['pontuacaoTotal'] as num?)?.toDouble() ?? 0.0,
      posicao: data['posicao'] as int? ?? 0,
      seguidores: data['seguidores'] as int? ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'nome': nome,
        'municipio': municipio,
        'estado': estado,
        'anoFundacao': anoFundacao,
        'fotoUrl': fotoUrl,
        'logoUrl': logoUrl,
        'descricao': descricao,
        'festivalId': festivalId,
        'pontuacaoTotal': pontuacaoTotal,
        'posicao': posicao,
        'seguidores': seguidores,
        'createdAt': createdAt != null
            ? Timestamp.fromDate(createdAt!)
            : FieldValue.serverTimestamp(),
      };

  QuadrilhaModel copyWith({
    String? id,
    String? nome,
    String? municipio,
    String? estado,
    int? anoFundacao,
    String? fotoUrl,
    String? logoUrl,
    String? descricao,
    String? festivalId,
    double? pontuacaoTotal,
    int? posicao,
    int? seguidores,
    DateTime? createdAt,
  }) =>
      QuadrilhaModel(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        municipio: municipio ?? this.municipio,
        estado: estado ?? this.estado,
        anoFundacao: anoFundacao ?? this.anoFundacao,
        fotoUrl: fotoUrl ?? this.fotoUrl,
        logoUrl: logoUrl ?? this.logoUrl,
        descricao: descricao ?? this.descricao,
        festivalId: festivalId ?? this.festivalId,
        pontuacaoTotal: pontuacaoTotal ?? this.pontuacaoTotal,
        posicao: posicao ?? this.posicao,
        seguidores: seguidores ?? this.seguidores,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  List<Object?> get props => [id, nome, pontuacaoTotal, posicao];
}

class IntegranteModel extends Equatable {
  const IntegranteModel({
    required this.id,
    required this.nome,
    required this.funcao,
    this.fotoUrl,
    this.quadrilhaId,
  });

  final String id;
  final String nome;
  final String funcao;
  final String? fotoUrl;
  final String? quadrilhaId;

  factory IntegranteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return IntegranteModel(
      id: doc.id,
      nome: data['nome'] as String? ?? '',
      funcao: data['funcao'] as String? ?? '',
      fotoUrl: data['fotoUrl'] as String?,
      quadrilhaId: data['quadrilhaId'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() => {
        'nome': nome,
        'funcao': funcao,
        'fotoUrl': fotoUrl,
        'quadrilhaId': quadrilhaId,
      };

  @override
  List<Object?> get props => [id, nome, funcao];
}

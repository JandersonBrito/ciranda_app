import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum FestivalTipo { municipal, estadual, regional, nacional }

class FestivalModel extends Equatable {
  const FestivalModel({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.dataInicio,
    required this.dataFim,
    required this.cidade,
    required this.estado,
    required this.endereco,
    required this.latitude,
    required this.longitude,
    this.bannerUrl,
    this.isAtivo = true,
    this.tipo = FestivalTipo.municipal,
    this.categorias = const [],
    this.createdAt,
  });

  final String id;
  final String nome;
  final String descricao;
  final DateTime dataInicio;
  final DateTime dataFim;
  final String cidade;
  final String estado;
  final String endereco;
  final double latitude;
  final double longitude;
  final String? bannerUrl;
  final bool isAtivo;
  final FestivalTipo tipo;
  final List<String> categorias;
  final DateTime? createdAt;

  String get cidadeEstado => '$cidade/$estado';

  bool get isHappening {
    final now = DateTime.now();
    return now.isAfter(dataInicio) && now.isBefore(dataFim);
  }

  bool get isUpcoming => DateTime.now().isBefore(dataInicio);

  factory FestivalModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FestivalModel(
      id: doc.id,
      nome: data['nome'] as String? ?? '',
      descricao: data['descricao'] as String? ?? '',
      dataInicio: (data['dataInicio'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dataFim: (data['dataFim'] as Timestamp?)?.toDate() ?? DateTime.now(),
      cidade: data['cidade'] as String? ?? '',
      estado: data['estado'] as String? ?? '',
      endereco: data['endereco'] as String? ?? '',
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      bannerUrl: data['bannerUrl'] as String?,
      isAtivo: data['isAtivo'] as bool? ?? true,
      tipo: FestivalTipo.values.firstWhere(
        (e) => e.name == (data['tipo'] as String? ?? 'municipal'),
        orElse: () => FestivalTipo.municipal,
      ),
      categorias: List<String>.from(data['categorias'] as List? ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'nome': nome,
        'descricao': descricao,
        'dataInicio': Timestamp.fromDate(dataInicio),
        'dataFim': Timestamp.fromDate(dataFim),
        'cidade': cidade,
        'estado': estado,
        'endereco': endereco,
        'latitude': latitude,
        'longitude': longitude,
        'bannerUrl': bannerUrl,
        'isAtivo': isAtivo,
        'tipo': tipo.name,
        'categorias': categorias,
        'createdAt': createdAt != null
            ? Timestamp.fromDate(createdAt!)
            : FieldValue.serverTimestamp(),
      };

  FestivalModel copyWith({
    String? id,
    String? nome,
    String? descricao,
    DateTime? dataInicio,
    DateTime? dataFim,
    String? cidade,
    String? estado,
    String? endereco,
    double? latitude,
    double? longitude,
    String? bannerUrl,
    bool? isAtivo,
    FestivalTipo? tipo,
    List<String>? categorias,
    DateTime? createdAt,
  }) =>
      FestivalModel(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        descricao: descricao ?? this.descricao,
        dataInicio: dataInicio ?? this.dataInicio,
        dataFim: dataFim ?? this.dataFim,
        cidade: cidade ?? this.cidade,
        estado: estado ?? this.estado,
        endereco: endereco ?? this.endereco,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        bannerUrl: bannerUrl ?? this.bannerUrl,
        isAtivo: isAtivo ?? this.isAtivo,
        tipo: tipo ?? this.tipo,
        categorias: categorias ?? this.categorias,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  List<Object?> get props => [id, nome, dataInicio, dataFim, isAtivo];
}

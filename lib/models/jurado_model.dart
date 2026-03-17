import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class JuradoModel extends Equatable {
  const JuradoModel({
    required this.id,
    required this.uid,
    required this.nome,
    required this.especialidade,
    this.fotoUrl,
    this.bio = '',
    this.cidade = '',
    this.estado = '',
    this.festivalId,
    this.isAtivo = true,
    this.festivaisJulgados = const [],
  });

  final String id;
  final String uid; // Firebase Auth UID
  final String nome;
  final String especialidade;
  final String? fotoUrl;
  final String bio;
  final String cidade;
  final String estado;
  final String? festivalId;
  final bool isAtivo;
  final List<String> festivaisJulgados;

  String get cidadeEstado => '$cidade/$estado';

  factory JuradoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JuradoModel(
      id: doc.id,
      uid: data['uid'] as String? ?? '',
      nome: data['nome'] as String? ?? '',
      especialidade: data['especialidade'] as String? ?? '',
      fotoUrl: data['fotoUrl'] as String?,
      bio: data['bio'] as String? ?? '',
      cidade: data['cidade'] as String? ?? '',
      estado: data['estado'] as String? ?? '',
      festivalId: data['festivalId'] as String?,
      isAtivo: data['isAtivo'] as bool? ?? true,
      festivaisJulgados: List<String>.from(
          data['festivaisJulgados'] as List? ?? []),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'uid': uid,
        'nome': nome,
        'especialidade': especialidade,
        'fotoUrl': fotoUrl,
        'bio': bio,
        'cidade': cidade,
        'estado': estado,
        'festivalId': festivalId,
        'isAtivo': isAtivo,
        'festivaisJulgados': festivaisJulgados,
      };

  JuradoModel copyWith({
    String? id,
    String? uid,
    String? nome,
    String? especialidade,
    String? fotoUrl,
    String? bio,
    String? cidade,
    String? estado,
    String? festivalId,
    bool? isAtivo,
    List<String>? festivaisJulgados,
  }) =>
      JuradoModel(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        nome: nome ?? this.nome,
        especialidade: especialidade ?? this.especialidade,
        fotoUrl: fotoUrl ?? this.fotoUrl,
        bio: bio ?? this.bio,
        cidade: cidade ?? this.cidade,
        estado: estado ?? this.estado,
        festivalId: festivalId ?? this.festivalId,
        isAtivo: isAtivo ?? this.isAtivo,
        festivaisJulgados: festivaisJulgados ?? this.festivaisJulgados,
      );

  @override
  List<Object?> get props => [id, uid, nome, festivalId];
}

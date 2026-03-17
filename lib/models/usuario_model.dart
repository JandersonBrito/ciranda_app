import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum UserRole { admin, jurado, publico }

class UsuarioModel extends Equatable {
  const UsuarioModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.fotoUrl,
    this.cidade = '',
    this.estado = '',
    this.role = UserRole.publico,
    this.festivalIds = const [],
    this.createdAt,
  });

  final String uid;
  final String email;
  final String displayName;
  final String? fotoUrl;
  final String cidade;
  final String estado;
  final UserRole role;
  final List<String> festivalIds;
  final DateTime? createdAt;

  bool get isAdmin => role == UserRole.admin;
  bool get isJurado => role == UserRole.jurado;

  String get initials {
    final parts = displayName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
  }

  factory UsuarioModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UsuarioModel(
      uid: doc.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      fotoUrl: data['fotoUrl'] as String?,
      cidade: data['cidade'] as String? ?? '',
      estado: data['estado'] as String? ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == (data['role'] as String? ?? 'publico'),
        orElse: () => UserRole.publico,
      ),
      festivalIds: List<String>.from(data['festivalIds'] as List? ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'email': email,
        'displayName': displayName,
        'fotoUrl': fotoUrl,
        'cidade': cidade,
        'estado': estado,
        'role': role.name,
        'festivalIds': festivalIds,
        'createdAt': createdAt != null
            ? Timestamp.fromDate(createdAt!)
            : FieldValue.serverTimestamp(),
      };

  UsuarioModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? fotoUrl,
    String? cidade,
    String? estado,
    UserRole? role,
    List<String>? festivalIds,
    DateTime? createdAt,
  }) =>
      UsuarioModel(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        displayName: displayName ?? this.displayName,
        fotoUrl: fotoUrl ?? this.fotoUrl,
        cidade: cidade ?? this.cidade,
        estado: estado ?? this.estado,
        role: role ?? this.role,
        festivalIds: festivalIds ?? this.festivalIds,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  List<Object?> get props => [uid, email, role];
}

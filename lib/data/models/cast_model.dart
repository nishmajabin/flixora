import 'package:equatable/equatable.dart';

/// Model representing a cast member from TMDB movie credits.
class CastMember extends Equatable {
  final int id;
  final String name;
  final String? character;
  final String? profilePath;
  final int order;

  const CastMember({
    required this.id,
    required this.name,
    this.character,
    this.profilePath,
    this.order = 0,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      character: json['character'] as String?,
      profilePath: json['profile_path'] as String?,
      order: json['order'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, name, character, profilePath, order];

  @override
  String toString() => 'CastMember(id: $id, name: $name)';
}

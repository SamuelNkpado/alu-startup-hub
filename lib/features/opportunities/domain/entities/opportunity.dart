import 'package:equatable/equatable.dart';

enum OpportunityStatus { open, closed }

/// Core domain model. Notice there is nothing Firestore-specific here —
/// no DocumentSnapshot, no Timestamp. That is the whole point of the
/// domain layer: it should be able to survive a backend swap untouched.
class Opportunity extends Equatable {
  final String id;
  final String startupId;
  final String startupName;
  final String title;
  final String description;
  final String roleType;
  final List<String> tags;
  final OpportunityStatus status;
  final DateTime createdAt;

  const Opportunity({
    required this.id,
    required this.startupId,
    required this.startupName,
    required this.title,
    required this.description,
    required this.roleType,
    required this.tags,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    startupId,
    startupName,
    title,
    description,
    roleType,
    tags,
    status,
    createdAt,
  ];
}
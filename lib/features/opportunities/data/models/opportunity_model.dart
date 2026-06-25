import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/opportunity.dart';

/// OpportunityModel extends the domain Opportunity and adds Firestore-specific
/// translation methods. This is the only place in the whole feature that is
/// allowed to know what a DocumentSnapshot or Timestamp is.
class OpportunityModel extends Opportunity {
  const OpportunityModel({
    required super.id,
    required super.startupId,
    required super.startupName,
    required super.title,
    required super.description,
    required super.roleType,
    required super.tags,
    required super.status,
    required super.createdAt,
  });

  factory OpportunityModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OpportunityModel(
      id: doc.id,
      startupId: data['startupId'] as String,
      startupName: data['startupName'] as String? ?? '',
      title: data['title'] as String,
      description: data['description'] as String,
      roleType: data['roleType'] as String,
      tags: List<String>.from(data['tags'] as List? ?? []),
      status: (data['status'] as String) == 'closed'
          ? OpportunityStatus.closed
          : OpportunityStatus.open,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'startupId': startupId,
      'startupName': startupName,
      'title': title,
      'description': description,
      'roleType': roleType,
      'tags': tags,
      'status': status == OpportunityStatus.closed ? 'closed' : 'open',
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory OpportunityModel.fromEntity(Opportunity entity) {
    return OpportunityModel(
      id: entity.id,
      startupId: entity.startupId,
      startupName: entity.startupName,
      title: entity.title,
      description: entity.description,
      roleType: entity.roleType,
      tags: entity.tags,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/opportunity.dart';
import '../../domain/repositories/opportunity_repository.dart';
import '../datasources/opportunity_firestore_datasource.dart';
import '../models/opportunity_model.dart';

/// This is the bridge. It implements the abstract OpportunityRepository
/// from the domain layer, using the Firestore data source underneath.
/// Notice it converts Model -> Entity on the way out, and Entity -> Model
/// on the way in. The rest of the app never sees a Model, only Entities.
class OpportunityRepositoryImpl implements OpportunityRepository {
  final OpportunityFirestoreDataSource dataSource;
  final FirebaseFirestore firestore;

  OpportunityRepositoryImpl(this.dataSource, this.firestore);

  @override
  Stream<List<Opportunity>> watchOpenOpportunities() {
    return dataSource.watchOpenOpportunities();
  }

  @override
  Future<Opportunity> getOpportunityById(String id) {
    return dataSource.getById(id);
  }

  @override
  Future<void> createOpportunity(Opportunity opportunity) async {
    // Generate the Firestore document id up front so the entity created
    // on the form side and the document written to Firestore share an id.
    final docId = opportunity.id.isNotEmpty
        ? opportunity.id
        : firestore.collection('opportunities').doc().id;

    final model = OpportunityModel.fromEntity(
      Opportunity(
        id: docId,
        startupId: opportunity.startupId,
        startupName: opportunity.startupName,
        title: opportunity.title,
        description: opportunity.description,
        roleType: opportunity.roleType,
        tags: opportunity.tags,
        status: opportunity.status,
        createdAt: opportunity.createdAt,
      ),
    );
    await dataSource.create(model);
  }

  @override
  Future<void> updateOpportunity(Opportunity opportunity) {
    return dataSource.update(OpportunityModel.fromEntity(opportunity));
  }

  @override
  Future<void> closeOpportunity(String id) {
    return dataSource.close(id);
  }
}
import '../entities/opportunity.dart';

/// This is an abstract contract. The domain layer defines WHAT operations
/// exist, never HOW they're done. The data layer (Firestore, in our case)
/// implements this interface. If we ever migrated off Firebase, only the
/// data layer would change — domain and presentation would not need to know.
abstract class OpportunityRepository {
  /// Live feed — real-time updates requirement is satisfied here.
  Stream<List<Opportunity>> watchOpenOpportunities();

  Future<Opportunity> getOpportunityById(String id);

  Future<void> createOpportunity(Opportunity opportunity);

  Future<void> updateOpportunity(Opportunity opportunity);

  Future<void> closeOpportunity(String id);
}
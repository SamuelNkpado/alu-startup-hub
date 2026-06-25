import '../repositories/opportunity_repository.dart';

class CloseOpportunity {
  final OpportunityRepository repository;

  CloseOpportunity(this.repository);

  Future<void> call(String opportunityId) {
    return repository.closeOpportunity(opportunityId);
  }
}
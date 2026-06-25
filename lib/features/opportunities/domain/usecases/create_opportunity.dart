import '../entities/opportunity.dart';
import '../repositories/opportunity_repository.dart';

class CreateOpportunity {
  final OpportunityRepository repository;

  CreateOpportunity(this.repository);

  Future<void> call(Opportunity opportunity) {
    return repository.createOpportunity(opportunity);
  }
}
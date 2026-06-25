import '../entities/opportunity.dart';
import '../repositories/opportunity_repository.dart';

class UpdateOpportunity {
  final OpportunityRepository repository;

  UpdateOpportunity(this.repository);

  Future<void> call(Opportunity opportunity) {
    return repository.updateOpportunity(opportunity);
  }
}
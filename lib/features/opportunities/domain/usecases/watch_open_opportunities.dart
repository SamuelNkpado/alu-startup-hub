import '../entities/opportunity.dart';
import '../repositories/opportunity_repository.dart';

/// A use case wraps exactly one business action. It knows nothing about
/// BLoC, widgets, or Firestore — only the repository contract above.
/// This is what gets unit-tested in isolation.
class WatchOpenOpportunities {
  final OpportunityRepository repository;

  WatchOpenOpportunities(this.repository);

  Stream<List<Opportunity>> call() {
    return repository.watchOpenOpportunities();
  }
}
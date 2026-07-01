import 'package:equatable/equatable.dart';
import '../../domain/entities/opportunity.dart';

abstract class OpportunityEvent extends Equatable {
  const OpportunityEvent();

  @override
  List<Object?> get props => [];
}

class WatchOpportunitiesStarted extends OpportunityEvent {
  const WatchOpportunitiesStarted();
}

class OpportunitiesUpdated extends OpportunityEvent {
  final List<Opportunity> opportunities;
  const OpportunitiesUpdated(this.opportunities);

  @override
  List<Object?> get props => [opportunities];
}

class OpportunityCreateSubmitted extends OpportunityEvent {
  final Opportunity opportunity;
  const OpportunityCreateSubmitted(this.opportunity);

  @override
  List<Object?> get props => [opportunity];
}

class OpportunityCloseRequested extends OpportunityEvent {
  final String opportunityId;
  const OpportunityCloseRequested(this.opportunityId);

  @override
  List<Object?> get props => [opportunityId];
}

class WatchOpportunitiesErrorOccurred extends OpportunityEvent {
  final String message;
  const WatchOpportunitiesErrorOccurred(this.message);

  @override
  List<Object?> get props => [message];
}

/// Fired by the search bar on every keystroke.
class OpportunitySearchChanged extends OpportunityEvent {
  final String query;
  const OpportunitySearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}
import 'package:equatable/equatable.dart';
import '../../domain/entities/opportunity.dart';

/// A single, non-exclusive state shape. The feed list and the submit-form
/// status are independent concerns that happen to live in one BLoC (per
/// our one-BLoC-per-feature decision) — so they're separate fields, not
/// separate mutually-exclusive subtypes. This is what stops "submitting"
/// from clobbering an already-loaded feed underneath it.
class OpportunityState extends Equatable {
  final List<Opportunity> opportunities;
  final bool isLoadingFeed;
  final bool isSubmitting;
  final String? feedError;
  final String? submitError;

  const OpportunityState({
    this.opportunities = const [],
    this.isLoadingFeed = false,
    this.isSubmitting = false,
    this.feedError,
    this.submitError,
  });

  OpportunityState copyWith({
    List<Opportunity>? opportunities,
    bool? isLoadingFeed,
    bool? isSubmitting,
    String? feedError,
    String? submitError,
  }) {
    return OpportunityState(
      opportunities: opportunities ?? this.opportunities,
      isLoadingFeed: isLoadingFeed ?? this.isLoadingFeed,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      feedError: feedError,
      submitError: submitError,
    );
  }

  @override
  List<Object?> get props =>
      [opportunities, isLoadingFeed, isSubmitting, feedError, submitError];
}
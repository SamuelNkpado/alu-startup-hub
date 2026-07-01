import 'package:equatable/equatable.dart';
import '../../domain/entities/opportunity.dart';

class OpportunityState extends Equatable {
  final List<Opportunity> opportunities;
  final bool isLoadingFeed;
  final bool isSubmitting;
  final String? feedError;
  final String? submitError;
  final String searchQuery;

  const OpportunityState({
    this.opportunities = const [],
    this.isLoadingFeed = false,
    this.isSubmitting = false,
    this.feedError,
    this.submitError,
    this.searchQuery = '',
  });

  /// Client-side filter — no extra Firestore query needed.
  /// Matches against title, startup name, or role type.
  List<Opportunity> get filteredOpportunities {
    if (searchQuery.isEmpty) return opportunities;
    final q = searchQuery.toLowerCase();
    return opportunities.where((o) {
      return o.title.toLowerCase().contains(q) ||
          o.startupName.toLowerCase().contains(q) ||
          o.roleType.toLowerCase().contains(q);
    }).toList();
  }

  OpportunityState copyWith({
    List<Opportunity>? opportunities,
    bool? isLoadingFeed,
    bool? isSubmitting,
    String? feedError,
    String? submitError,
    String? searchQuery,
  }) {
    return OpportunityState(
      opportunities: opportunities ?? this.opportunities,
      isLoadingFeed: isLoadingFeed ?? this.isLoadingFeed,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      feedError: feedError,
      submitError: submitError,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    opportunities,
    isLoadingFeed,
    isSubmitting,
    feedError,
    submitError,
    searchQuery,
  ];
}
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/close_opportunity.dart';
import '../../domain/usecases/create_opportunity.dart';
import '../../domain/usecases/watch_open_opportunities.dart';
import 'opportunity_event.dart';
import 'opportunity_state.dart';

class OpportunityBloc extends Bloc<OpportunityEvent, OpportunityState> {
  final WatchOpenOpportunities watchOpenOpportunities;
  final CreateOpportunity createOpportunity;
  final CloseOpportunity closeOpportunity;

  StreamSubscription? _feedSubscription;

  OpportunityBloc({
    required this.watchOpenOpportunities,
    required this.createOpportunity,
    required this.closeOpportunity,
  }) : super(const OpportunityState()) {
    on<WatchOpportunitiesStarted>(_onWatchStarted);
    on<OpportunitiesUpdated>(_onOpportunitiesUpdated);
    on<OpportunityCreateSubmitted>(_onCreateSubmitted);
    on<WatchOpportunitiesErrorOccurred>(_onWatchError);
    on<OpportunityCloseRequested>(_onCloseRequested);
  }

  /// This is the real-time mechanism: the BLoC subscribes once to the
  /// domain-layer Stream, and every emission from Firestore is re-dispatched
  /// as an internal event. Going through `add()` rather than mutating state
  /// directly inside the subscription callback keeps every state change
  /// flowing through the same event->state pipeline, which is what makes
  /// the BLoC's behavior predictable and explainable.
  void _onWatchStarted(
      WatchOpportunitiesStarted event, Emitter<OpportunityState> emit) async {
    emit(state.copyWith(isLoadingFeed: true, feedError: null));

    await _feedSubscription?.cancel();
    _feedSubscription = watchOpenOpportunities().listen(
      (opportunities) => add(OpportunitiesUpdated(opportunities)),
      onError: (error) => add(WatchOpportunitiesErrorOccurred(error.toString())),
    );
  }

  void _onWatchError(
      WatchOpportunitiesErrorOccurred event, Emitter<OpportunityState> emit) {
    emit(state.copyWith(isLoadingFeed: false, feedError: event.message));
  }

  void _onOpportunitiesUpdated(
      OpportunitiesUpdated event, Emitter<OpportunityState> emit) {
    emit(state.copyWith(
      opportunities: event.opportunities,
      isLoadingFeed: false,
      feedError: null,
    ));
  }

  Future<void> _onCreateSubmitted(
      OpportunityCreateSubmitted event, Emitter<OpportunityState> emit) async {
    emit(state.copyWith(isSubmitting: true, submitError: null));
    try {
      await createOpportunity(event.opportunity);
      emit(state.copyWith(isSubmitting: false));
      // No need to manually refresh the feed — the Firestore stream
      // subscription above will emit the new list automatically.
    } catch (error) {
      emit(state.copyWith(isSubmitting: false, submitError: error.toString()));
    }
  }

  Future<void> _onCloseRequested(
      OpportunityCloseRequested event, Emitter<OpportunityState> emit) async {
    try {
      await closeOpportunity(event.opportunityId);
    } catch (error) {
      emit(state.copyWith(submitError: error.toString()));
    }
  }

  @override
  Future<void> close() {
    _feedSubscription?.cancel();
    return super.close();
  }
}
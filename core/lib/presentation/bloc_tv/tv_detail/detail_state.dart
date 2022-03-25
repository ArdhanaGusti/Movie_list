import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';

class DetailState extends Equatable {
  final TvDetail? tvDetail;
  final List<Tv> tvRecommendations;
  final RequestState tvDetailState;
  final RequestState tvRecommendationState;
  final String message;
  final String watchlistMessage;
  final bool isAddedToWatchlist;

  DetailState({
    required this.tvDetail,
    required this.tvRecommendations,
    required this.tvDetailState,
    required this.tvRecommendationState,
    required this.message,
    required this.watchlistMessage,
    required this.isAddedToWatchlist,
  });

  DetailState copyWith({
    TvDetail? tvDetail,
    List<Tv>? tvRecommendations,
    RequestState? tvDetailState,
    RequestState? tvRecommendationState,
    String? message,
    String? watchlistMessage,
    bool? isAddedToWatchlist,
  }) {
    return DetailState(
      tvDetail: tvDetail ?? this.tvDetail,
      tvRecommendations: tvRecommendations ?? this.tvRecommendations,
      tvDetailState: tvDetailState ?? this.tvDetailState,
      tvRecommendationState:
          tvRecommendationState ?? this.tvRecommendationState,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  factory DetailState.initial() {
    return DetailState(
      tvDetail: null,
      tvRecommendations: [],
      tvDetailState: RequestState.Empty,
      tvRecommendationState: RequestState.Empty,
      message: '',
      watchlistMessage: '',
      isAddedToWatchlist: false,
    );
  }

  @override
  List<Object?> get props {
    return [
      tvDetail,
      tvRecommendations,
      tvDetailState,
      tvRecommendationState,
      message,
      watchlistMessage,
      isAddedToWatchlist,
    ];
  }
}

import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';

class DetailState extends Equatable {
  final MovieDetail? movieDetail;
  final List<Movie> movieRecommendations;
  final RequestState movieDetailState;
  final RequestState movieRecommendationState;
  final String message;
  final String watchlistMessage;
  final bool isAddedToWatchlist;

  DetailState({
    required this.movieDetail,
    required this.movieRecommendations,
    required this.movieDetailState,
    required this.movieRecommendationState,
    required this.message,
    required this.watchlistMessage,
    required this.isAddedToWatchlist,
  });

  DetailState copyWith({
    MovieDetail? movieDetail,
    List<Movie>? movieRecommendations,
    RequestState? movieDetailState,
    RequestState? movieRecommendationState,
    String? message,
    String? watchlistMessage,
    bool? isAddedToWatchlist,
  }) {
    return DetailState(
      movieDetail: movieDetail ?? this.movieDetail,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      movieDetailState: movieDetailState ?? this.movieDetailState,
      movieRecommendationState:
          movieRecommendationState ?? this.movieRecommendationState,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  factory DetailState.initial() {
    return DetailState(
      movieDetail: null,
      movieRecommendations: [],
      movieDetailState: RequestState.Empty,
      movieRecommendationState: RequestState.Empty,
      message: '',
      watchlistMessage: '',
      isAddedToWatchlist: false,
    );
  }

  @override
  List<Object?> get props {
    return [
      movieDetail,
      movieRecommendations,
      movieDetailState,
      movieRecommendationState,
      message,
      watchlistMessage,
      isAddedToWatchlist,
    ];
  }
}

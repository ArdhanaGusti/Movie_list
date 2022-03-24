import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:core/presentation/bloc_movie/detail_event.dart';
import 'package:core/presentation/bloc_movie/detail_state.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieBlocDetail extends Bloc<DetailEvent, DetailState> {
  final GetMovieDetail _getMovieDetail;
  final GetMovieRecommendations _getMovieRecommendations;
  final GetWatchListStatus _getWatchListStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  MovieBlocDetail(this._getMovieDetail, this._getMovieRecommendations,
      this._getWatchListStatus, this._saveWatchlist, this._removeWatchlist)
      : super(DetailState.initial()) {
    on<OnDetailList>(
      (event, emit) async {
        emit(state.copyWith(
          movieDetailState: RequestState.Loading,
        ));
        final result = await _getMovieDetail.execute(event.id);
        final recomendation = await _getMovieRecommendations.execute(event.id);

        result.fold(
          (failure) {
            emit(state.copyWith(
              movieDetailState: RequestState.Error,
              message: failure.message,
            ));
          },
          (detail) {
            emit(state.copyWith(
              movieRecommendationState: RequestState.Loading,
              message: '',
              movieDetailState: RequestState.Loaded,
              movieDetail: detail,
            ));
            recomendation.fold((failure) {
              emit(state.copyWith(
                movieRecommendationState: RequestState.Error,
                message: failure.message,
              ));
            }, (recomen) {
              emit(state.copyWith(
                movieRecommendations: recomen,
                movieRecommendationState: RequestState.Loaded,
                message: '',
              ));
            });
          },
        );
      },
    );
    on<AddWatchlist>(
      (event, emit) async {
        final result = await _saveWatchlist.execute(event.movieDetail);

        result.fold(
          (failure) {
            emit(state.copyWith(watchlistMessage: failure.message));
          },
          (added) {
            emit(state.copyWith(
              watchlistMessage: watchlistAddSuccessMessage,
            ));
          },
        );

        add(WatchlistStatus(event.movieDetail.id));
      },
    );
    on<EraseWatchlist>(
      (event, emit) async {
        final result = await _removeWatchlist.execute(event.movieDetail);
        result.fold(
          (failure) {
            emit(state.copyWith(watchlistMessage: failure.message));
          },
          (added) {
            emit(state.copyWith(
              watchlistMessage: watchlistRemoveSuccessMessage,
            ));
          },
        );
        add(WatchlistStatus(event.movieDetail.id));
      },
    );
    on<WatchlistStatus>(
      (event, emit) async {
        final result = await _getWatchListStatus.execute(event.id);
        emit(state.copyWith(isAddedToWatchlist: result));
      },
    );
  }
}

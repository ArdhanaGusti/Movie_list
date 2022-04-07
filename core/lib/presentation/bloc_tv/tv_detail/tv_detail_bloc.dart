import 'package:core/domain/usecases_tv/get_watchlist_status.dart';
import 'package:core/domain/usecases_tv/remove_watchlist.dart';
import 'package:core/domain/usecases_tv/save_watchlist.dart';
import 'package:core/domain/usecases_tv/get_tv_detail.dart';
import 'package:core/domain/usecases_tv/get_tv_recommendations.dart';
import 'package:core/presentation/bloc_tv/tv_detail/detail_event.dart';
import 'package:core/presentation/bloc_tv/tv_detail/detail_state.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvBlocDetail extends Bloc<DetailEvent, DetailState> {
  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListStatusTv getWatchListStatus;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  TvBlocDetail(
      {required this.getTvDetail,
      required this.getTvRecommendations,
      required this.getWatchListStatus,
      required this.saveWatchlist,
      required this.removeWatchlist})
      : super(DetailState.initial()) {
    on<OnDetailList>(
      (event, emit) async {
        emit(state.copyWith(
          tvDetailState: RequestState.Loading,
        ));
        final result = await getTvDetail.execute(event.id);
        final recomendation = await getTvRecommendations.execute(event.id);

        result.fold(
          (failure) {
            emit(state.copyWith(
              tvDetailState: RequestState.Error,
              message: failure.message,
            ));
          },
          (detail) {
            emit(state.copyWith(
              tvRecommendationState: RequestState.Loading,
              message: '',
              tvDetailState: RequestState.Loaded,
              tvDetail: detail,
            ));
            recomendation.fold((failure) {
              emit(state.copyWith(
                tvRecommendationState: RequestState.Error,
                message: failure.message,
              ));
            }, (recomen) {
              emit(state.copyWith(
                tvRecommendations: recomen,
                tvRecommendationState: RequestState.Loaded,
                message: '',
              ));
            });
          },
        );
      },
    );
    on<AddWatchlist>(
      (event, emit) async {
        final result = await saveWatchlist.execute(event.movieDetail);

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
        final result = await removeWatchlist.execute(event.movieDetail);
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
        final result = await getWatchListStatus.execute(event.id);
        emit(state.copyWith(isAddedToWatchlist: result));
      },
    );
  }
}

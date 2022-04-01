import 'package:core/domain/usecases_tv/get_watchlist_tv.dart';
import 'package:core/presentation/bloc_tv/tv_watchlist/watchlist_event.dart';
import 'package:core/presentation/bloc_tv/tv_watchlist/watchlist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvBlocWatchList extends Bloc<WatchlistEventTv, WatchlistStateTv> {
  final GetWatchlistTv _getWatchlist;

  TvBlocWatchList(this._getWatchlist) : super(WatchlistTvEmpty()) {
    on<WatchlistTv>(
      (event, emit) async {
        emit(WatchlistTvLoading());
        final result = await _getWatchlist.execute();

        result.fold(
          (failure) {
            emit(WatchlistTvError(failure.message));
          },
          (data) {
            emit(WatchlistTvHasData(data));
          },
        );
      },
    );
  }
}

import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/presentation/bloc_movie/movie_watchlist/watchlist_event.dart';
import 'package:core/presentation/bloc_movie/movie_watchlist/watchlist_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieBlocWatchList extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlistMovies _getWatchlist;

  MovieBlocWatchList(this._getWatchlist) : super(WatchlistEmpty()) {
    on<WatchlistMovie>(
      (event, emit) async {
        emit(WatchlistLoading());
        final result = await _getWatchlist.execute();

        result.fold(
          (failure) {
            emit(WatchlistError(failure.message));
          },
          (data) {
            emit(WatchlistHasData(data));
          },
        );
      },
    );
  }
}

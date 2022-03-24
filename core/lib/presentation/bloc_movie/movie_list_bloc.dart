import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/presentation/bloc_movie/movie_event.dart';
import 'package:core/presentation/bloc_movie/movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rxdart/rxdart.dart';

class MovieBlocList extends Bloc<MovieEvent, MovieState> {
  final GetNowPlayingMovies _nowPlayingMovies;
  // EventTransformer<T> debounce<T>(Duration duration) {
  //   return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  // }

  MovieBlocList(this._nowPlayingMovies) : super(MovieEmpty()) {
    on<OnMovieList>(
      (event, emit) async {
        emit(MovieLoading());
        final result = await _nowPlayingMovies.execute();

        result.fold(
          (failure) {
            emit(MovieError(failure.message));
          },
          (data) {
            emit(MovieHasData(data));
          },
        );
      },
      // transformer: debounce(const Duration(milliseconds: 500)),
    );
  }
}

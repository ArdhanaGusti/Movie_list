import 'package:core/domain/entities/movie.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases_tv/get_watchlist_tv.dart';
import 'package:core/presentation/bloc_movie/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:core/presentation/bloc_movie/movie_watchlist/watchlist_event.dart';
import 'package:core/presentation/bloc_movie/movie_watchlist/watchlist_state.dart';
import 'package:core/presentation/bloc_tv/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies, GetWatchlistTv])
void main() {
  late MovieBlocWatchList watchlistMoviesBloc;
  late TvBlocWatchList watchlistTvShowsBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchlistTvShows mockGetWatchlistTvShows;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchlistTvShows = MockGetWatchlistTvShows();
    watchlistMoviesBloc = MovieBlocWatchList(mockGetWatchlistMovies);
    watchlistTvShowsBloc = TvBlocWatchList(mockGetWatchlistTvShows);
  });

  final tMovies = <Movie>[testMovie];

  group('Watchlist Movies', () {
    test('Initial state should be empty', () {
      expect(watchlistMoviesBloc.state, WatchlistEmpty());
    });

    blocTest<MovieBlocWatchList, WatchlistState>(
      'Should emit [WatchlistLoading, WatchlistHasData] when data is gotten successfully',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(tMovies));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovie()),
      expect: () => [
        WatchlistLoading(),
        WatchlistHasData(tMovies),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<MovieBlocWatchList, WatchlistState>(
      'Should emit [WatchlistLoading, WatchlistHasData[], WatchlistEmpty] when data is empty',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(<Movie>[]));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovie()),
      expect: () => [
        WatchlistLoading(),
        WatchlistHasData(<Movie>[]),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<MovieBlocWatchList, WatchlistState>(
      'Should emit [WatchlistLoading, WatchlistError] when data is unsuccessful',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovie()),
      expect: () => [
        WatchlistLoading(),
        WatchlistError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      },
    );
  });

  final tTvShows = <Tv>[testTvShow];

  // group('Watchlist Tv Shows', () {
  //   test('Initial state should be empty', () {
  //     expect(watchlistTvShowsBloc.state, WatchlistEmpty());
  //   });

  //   blocTest<TvBlocWatchList, WatchlistState>(
  //     'Should emit [WatchlistLoading, WatchlistHasData] when data is gotten successfully',
  //     build: () {
  //       when(mockGetWatchlistTvShows.execute())
  //           .thenAnswer((_) async => Right(tTvShows));
  //       return watchlistTvShowsBloc;
  //     },
  //     act: (bloc) => bloc.add(WatchlistEvent()),
  //     expect: () => [
  //       WatchlistTvLoading(),
  //       WatchlistTvHasData(tTvShows),
  //     ],
  //     verify: (bloc) {
  //       verify(mockGetWatchlistTvShows.execute());
  //     },
  //   );

  //   blocTest<TvBlocWatchList, WatchlistStateTv>(
  //     'Should emit [WatchlistLoading, WatchlistHasData[], WatchlistEmpty] when data is empty',
  //     build: () {
  //       when(mockGetWatchlistTvShows.execute())
  //           .thenAnswer((_) async => Right(<Tv>[]));
  //       return watchlistTvShowsBloc;
  //     },
  //     act: (bloc) => bloc.add(WatchlistEvent()),
  //     expect: () => [
  //       WatchlistTvLoading(),
  //       WatchlistTvHasData(<Tv>[]),
  //       WatchlistTvEmpty(),
  //     ],
  //     verify: (bloc) {
  //       verify(mockGetWatchlistTvShows.execute());
  //     },
  //   );

  //   blocTest<TvBlocWatchList, WatchlistStateTv>(
  //     'Should emit [WatchlistLoading, WatchlistError] when data is unsuccessful',
  //     build: () {
  //       when(mockGetWatchlistTvShows.execute())
  //           .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
  //       return watchlistTvShowsBloc;
  //     },
  //     act: (bloc) => bloc.add(WatchlistEvent()),
  //     expect: () => [
  //       WatchlistTvLoading(),
  //       WatchlistTvError('Server Failure'),
  //     ],
  //     verify: (bloc) {
  //       verify(mockGetWatchlistTvShows.execute());
  //     },
  //   );
  // });
}

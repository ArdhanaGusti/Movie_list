import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc_movie/movie_event.dart';
import 'package:core/presentation/bloc_movie/movie_list_bloc.dart';
import 'package:core/presentation/bloc_movie/movie_popular_bloc.dart';
import 'package:core/presentation/bloc_movie/movie_state.dart';
import 'package:core/presentation/bloc_movie/movie_top_rated_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/utils/failure.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieBlocList movieBlocList;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MovieBlocPopular movieBlocPopular;
  late MockGetPopularMovies mockGetPopularMovies;
  late MovieBlocTopRated topRatedMovieListBloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    movieBlocList = MovieBlocList(mockGetNowPlayingMovies);
    mockGetPopularMovies = MockGetPopularMovies();
    movieBlocPopular = MovieBlocPopular(mockGetPopularMovies);
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMovieListBloc = MovieBlocTopRated(mockGetTopRatedMovies);
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  group('now playing movie list', () {
    test('Initial state should be empty', () {
      expect(movieBlocList.state, MovieEmpty());
    });

    blocTest<MovieBlocList, MovieState>(
      'Should emit [MovieListLoading, MovieListLoaded] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieBlocList;
      },
      act: (bloc) => bloc.add(OnMovieList()),
      expect: () => [
        MovieLoading(),
        MovieHasData(tMovieList),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<MovieBlocList, MovieState>(
      'Should emit [MovieListLoading, MovieListError] when get Failure',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return movieBlocList;
      },
      act: (bloc) => bloc.add(OnMovieList()),
      expect: () => [
        MovieLoading(),
        MovieError('Failed'),
      ],
      verify: (_) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );
  });

  group('popular movie list', () {
    test('Initial state should be empty', () {
      expect(movieBlocPopular.state, MovieEmpty());
    });

    blocTest<MovieBlocPopular, MovieState>(
      'Should emit [MovieListLoading, MovieListLoaded] when data is gotten successfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieBlocPopular;
      },
      act: (bloc) => bloc.add(OnMovieList()),
      expect: () => [
        MovieLoading(),
        MovieHasData(tMovieList),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<MovieBlocPopular, MovieState>(
      'Should emit [MovieListLoading, MovieListError] when get Failure',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return movieBlocPopular;
      },
      act: (bloc) => bloc.add(OnMovieList()),
      expect: () => [
        MovieLoading(),
        MovieError('Failed'),
      ],
      verify: (_) {
        verify(mockGetPopularMovies.execute());
      },
    );
  });

  group('top rated movie list', () {
    test('Initial state should be empty', () {
      expect(topRatedMovieListBloc.state, MovieEmpty());
    });

    blocTest<MovieBlocTopRated, MovieState>(
      'Should emit [MovieListLoading, MovieListLoaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return topRatedMovieListBloc;
      },
      act: (bloc) => bloc.add(OnMovieList()),
      expect: () => [
        MovieLoading(),
        MovieHasData(tMovieList),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      },
    );

    blocTest<MovieBlocTopRated, MovieState>(
      'Should emit [MovieListLoading, MovieListError] when get Failure',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return topRatedMovieListBloc;
      },
      act: (bloc) => bloc.add(OnMovieList()),
      expect: () => [
        MovieLoading(),
        MovieError('Failed'),
      ],
      verify: (_) {
        verify(mockGetTopRatedMovies.execute());
      },
    );
  });
}

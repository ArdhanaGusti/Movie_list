import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc_movie/movie_event.dart';
import 'package:core/presentation/bloc_movie/movie_state.dart';
import 'package:core/presentation/bloc_movie/movie_top_rated_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';

import 'top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late MovieBlocTopRated movieBlocTopRated;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    movieBlocTopRated = MovieBlocTopRated(mockGetTopRatedMovies);
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

  group('TopRated Movies', () {
    test('Initial state should be empty', () {
      expect(movieBlocTopRated.state, MovieEmpty());
    });

    blocTest<MovieBlocTopRated, MovieState>(
      'Should emit [TopRatedMoviesLoading, TopRatedMoviesLoaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return movieBlocTopRated;
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
      'Should emit [TopRatedMoviesLoading, TopRatedMoviesLoaded[], TopRatedMoviesEmpty] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(<Movie>[]));
        return movieBlocTopRated;
      },
      act: (bloc) => bloc.add(OnMovieList()),
      expect: () => [
        MovieLoading(),
        MovieHasData(<Movie>[]),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      },
    );

    blocTest<MovieBlocTopRated, MovieState>(
      'Should emit [TopRatedMoviesLoading, TopRatedMoviesError] when get Failure',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return movieBlocTopRated;
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

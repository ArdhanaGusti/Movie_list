import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc_movie/movie_event.dart';
import 'package:core/presentation/bloc_movie/movie_popular_bloc.dart';
import 'package:core/presentation/bloc_movie/movie_state.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late MovieBlocPopular movieBlocPopular;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    movieBlocPopular = MovieBlocPopular(mockGetPopularMovies);
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

  group('Popular Movies', () {
    test('Initial state should be empty', () {
      expect(movieBlocPopular.state, MovieEmpty());
    });

    blocTest<MovieBlocPopular, MovieState>(
      'Should emit [PopularMoviesLoading, PopularMoviesLoaded] when data is gotten successfully',
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
      'Should emit [PopularMoviesLoading, PopularMoviesLoaded[], MovieEmpty] when data is gotten successfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(<Movie>[]));
        return movieBlocPopular;
      },
      act: (bloc) => bloc.add(OnMovieList()),
      expect: () => [
        MovieLoading(),
        MovieHasData(<Movie>[]),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<MovieBlocPopular, MovieState>(
      'Should emit [PopularMoviesLoading, PopularMoviesError] when get Failure',
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
}

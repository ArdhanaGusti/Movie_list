import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:core/presentation/bloc_movie/movie_detail/detail_event.dart';
import 'package:core/presentation/bloc_movie/movie_detail/detail_state.dart';
import 'package:core/presentation/bloc_movie/movie_detail/movie_detail_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieBlocDetail movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatusMovie mockGetWatchlistStatus;
  late MockSaveWatchlistMovie mockSaveWatchlist;
  late MockRemoveWatchlistMovie mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatusMovie();
    mockSaveWatchlist = MockSaveWatchlistMovie();
    mockRemoveWatchlist = MockRemoveWatchlistMovie();
    movieDetailBloc = MovieBlocDetail(
      mockGetMovieDetail,
      mockGetMovieRecommendations,
      mockGetWatchlistStatus,
      mockSaveWatchlist,
      mockRemoveWatchlist,
    );
  });

  final tId = 1;
  final movieDetailStateInit = DetailState.initial();
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
  final tMovies = <Movie>[tMovie];

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Comedy')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 1,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  group('Get Movie Detail', () {
    blocTest<MovieBlocDetail, DetailState>(
      'Shoud emit MovieDetailLoading, RecomendationLoading, MovieDetailLoaded and RecomendationLoaded when get  Detail Movies and Recommendation Success',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(tMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(OnDetailList(tId)),
      expect: () => [
        movieDetailStateInit.copyWith(movieDetailState: RequestState.Loading),
        movieDetailStateInit.copyWith(
          movieRecommendationState: RequestState.Loading,
          movieDetail: tMovieDetail,
          movieDetailState: RequestState.Loaded,
          message: '',
        ),
        movieDetailStateInit.copyWith(
          movieDetailState: RequestState.Loaded,
          movieDetail: tMovieDetail,
          movieRecommendationState: RequestState.Loaded,
          movieRecommendations: tMovies,
          message: '',
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<MovieBlocDetail, DetailState>(
      'Shoud emit MovieDetailLoading, RecomendationLoading, MovieDetailLoaded and RecommendationError when Get MovieRecommendations Failed',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(tMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(OnDetailList(tId)),
      expect: () => [
        movieDetailStateInit.copyWith(movieDetailState: RequestState.Loading),
        movieDetailStateInit.copyWith(
          movieRecommendationState: RequestState.Loading,
          movieDetail: tMovieDetail,
          movieDetailState: RequestState.Loaded,
          message: '',
        ),
        movieDetailStateInit.copyWith(
          movieDetailState: RequestState.Loaded,
          movieDetail: tMovieDetail,
          movieRecommendationState: RequestState.Error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<MovieBlocDetail, DetailState>(
      'Shoud emit MovieDetailError when Get Movie Detail Failed',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(OnDetailList(tId)),
      expect: () => [
        movieDetailStateInit.copyWith(movieDetailState: RequestState.Loading),
        movieDetailStateInit.copyWith(
            movieDetailState: RequestState.Error, message: 'Failed'),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );
  });

  group('AddToWatchlist Movie', () {
    blocTest<MovieBlocDetail, DetailState>(
      'Shoud emit WatchlistMessage and isAddedToWatchlist True when Success AddWatchlist',
      build: () {
        when(mockSaveWatchlist.execute(tMovieDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(tMovieDetail.id))
            .thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlist(tMovieDetail)),
      expect: () => [
        movieDetailStateInit.copyWith(watchlistMessage: 'Added to Watchlist'),
        movieDetailStateInit.copyWith(
            watchlistMessage: 'Added to Watchlist', isAddedToWatchlist: true),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(tMovieDetail));
        verify(mockGetWatchlistStatus.execute(tMovieDetail.id));
      },
    );

    blocTest<MovieBlocDetail, DetailState>(
      'Shoud emit watchlistMessage when Failed',
      build: () {
        when(mockSaveWatchlist.execute(tMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(tMovieDetail.id))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlist(tMovieDetail)),
      expect: () => [
        movieDetailStateInit.copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(tMovieDetail));
        verify(mockGetWatchlistStatus.execute(tMovieDetail.id));
      },
    );
  });

  group('RemoveFromWatchlist Movie', () {
    // blocTest<MovieBlocDetail, DetailState>(
    //   'Shoud emit WatchlistMessage and isAddedToWatchlist False when Success RemoveFromWatchlist',
    //   build: () {
    //     when(mockRemoveWatchlist.execute(tMovieDetail))
    //         .thenAnswer((_) async => Right('Removed From Watchlist'));
    //     when(mockGetWatchlistStatus.execute(tMovieDetail.id))
    //         .thenAnswer((_) async => false);
    //     return movieDetailBloc;
    //   },
    //   act: (bloc) => bloc.add(EraseWatchlist(tMovieDetail)),
    //   expect: () => [
    //     movieDetailStateInit.copyWith(
    //         watchlistMessage: 'Removed From Watchlist',
    //         isAddedToWatchlist: false),
    //   ],
    //   verify: (_) {
    //     verify(mockRemoveWatchlist.execute(tMovieDetail));
    //     verify(mockGetWatchlistStatus.execute(tMovieDetail.id));
    //   },
    // );

    blocTest<MovieBlocDetail, DetailState>(
      'Shoud emit watchlistMessage when Failed',
      build: () {
        when(mockRemoveWatchlist.execute(tMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(tMovieDetail.id))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(EraseWatchlist(tMovieDetail)),
      expect: () => [
        movieDetailStateInit.copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockRemoveWatchlist.execute(tMovieDetail));
        verify(mockGetWatchlistStatus.execute(tMovieDetail.id));
      },
    );
  });

  group('LoadWatchlistStatus', () {
    blocTest<MovieBlocDetail, DetailState>(
      'Should Emit AddWatchlistStatus True',
      build: () {
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(WatchlistStatus(tId)),
      expect: () => [
        movieDetailStateInit.copyWith(isAddedToWatchlist: true),
      ],
      verify: (_) {
        verify(mockGetWatchlistStatus.execute(tMovieDetail.id));
      },
    );
  });
}

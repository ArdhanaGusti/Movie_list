import 'package:bloc_test/bloc_test.dart';
import 'package:core/data/models/tv_detail_model.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/presentation/bloc_tv/tv_detail/detail_event.dart';
import 'package:core/presentation/bloc_tv/tv_detail/detail_state.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core/domain/usecases_tv/get_tv_detail.dart';
import 'package:core/domain/usecases_tv/get_tv_recommendations.dart';
import 'package:core/presentation/bloc_tv/tv_detail/tv_detail_bloc.dart';
import 'package:core/domain/usecases_tv/get_watchlist_status.dart';
import 'package:core/domain/usecases_tv/remove_watchlist.dart';
import 'package:core/domain/usecases_tv/save_watchlist.dart';

import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetWatchListStatusTv,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late TvBlocDetail tvBlocDetail;
  late MockGetTvShowDetail mockGetTvShowDetail;
  late MockGetTvShowRecommendations mockGetTvShowRecommendations;
  late MockGetWatchListStatusTvShow mockGetWatchlistStatus;
  late MockSaveWatchlistTvShow mockSaveWatchlist;
  late MockRemoveWatchlistTvShow mockRemoveWatchlist;

  setUp(() {
    mockGetTvShowDetail = MockGetTvShowDetail();
    mockGetTvShowRecommendations = MockGetTvShowRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatusTvShow();
    mockSaveWatchlist = MockSaveWatchlistTvShow();
    mockRemoveWatchlist = MockRemoveWatchlistTvShow();
    tvBlocDetail = TvBlocDetail(
      getTvDetail: mockGetTvShowDetail,
      getTvRecommendations: mockGetTvShowRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  final tId = 1;
  final TvShowDetailStateInit = DetailState.initial();
  final tTvShow = Tv(
      backdropPath: "/xAKMj134XHQVNHLC6rWsccLMenG.jpg",
      genreIds: [10765, 35, 80],
      id: 90462,
      name: "Chucky",
      originalName: "Chucky",
      overview:
          "After a vintage Chucky doll turns up at a suburban yard sale, an idyllic American town is thrown into chaos as a series of horrifying murders begin to expose the town’s hypocrisies and secrets. Meanwhile, the arrival of enemies — and allies — from Chucky’s past threatens to expose the truth behind the killings, as well as the demon doll’s untold origins.",
      popularity: 6008.272,
      posterPath: "/iF8ai2QLNiHV4anwY1TuSGZXqfN.jpg",
      voteAverage: 8,
      voteCount: 987);
  final tTvShows = <Tv>[tTvShow];

  final tTvShowDetail = TvDetail(
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genres: [Genre(id: 1, name: 'Comedy')],
    id: 1,
    name: 'name',
    originalName: 'originalName',
    overview: 'overview',
    posterPath: 'posterPath',
    seasons: [
      Season(
        episodeCount: 1,
        id: 1,
        name: 'name',
        overview: 'overview',
        posterPath: 'posterPath',
        seasonNumber: 1,
      )
    ],
    tagline: 'tagline',
    voteAverage: 1,
    voteCount: 1,
    adult: false,
    createdBy: [],
    episodeRunTime: [],
    homepage: '',
    inProduction: false,
    languages: [],
    lastAirDate: '',
    networks: [],
    numberOfEpisodes: 1,
    numberOfSeasons: 1,
    originalLanguage: '',
    originCountry: [],
    popularity: 1.0,
    productionCompanies: [],
    productionCountries: [],
    spokenLanguages: [],
    status: '',
    type: '',
  );

  group('Get TvShow Detail', () {
    blocTest<TvBlocDetail, DetailState>(
      'Shoud emit TvShowDetailLoading, RecomendationLoading, TvShowDetailLoaded and RecomendationLoaded when get  Detail TvShows and Recommendation Success',
      build: () {
        when(mockGetTvShowDetail.execute(tId))
            .thenAnswer((_) async => Right(tTvShowDetail));
        when(mockGetTvShowRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvShows));
        return tvBlocDetail;
      },
      act: (bloc) => bloc.add(OnDetailList(tId)),
      expect: () => [
        TvShowDetailStateInit.copyWith(tvDetailState: RequestState.Loading),
        TvShowDetailStateInit.copyWith(
          tvRecommendationState: RequestState.Loading,
          tvDetail: tTvShowDetail,
          tvDetailState: RequestState.Loaded,
          message: '',
        ),
        TvShowDetailStateInit.copyWith(
          tvDetailState: RequestState.Loaded,
          tvDetail: tTvShowDetail,
          tvRecommendationState: RequestState.Loaded,
          tvRecommendations: tTvShows,
          message: '',
        ),
      ],
      verify: (_) {
        verify(mockGetTvShowDetail.execute(tId));
        verify(mockGetTvShowRecommendations.execute(tId));
      },
    );

    blocTest<TvBlocDetail, DetailState>(
      'Shoud emit TvShowDetailLoading, RecomendationLoading, TvShowDetailLoaded and RecommendationError when Get TvShowRecommendations Failed',
      build: () {
        when(mockGetTvShowDetail.execute(tId))
            .thenAnswer((_) async => Right(tTvShowDetail));
        when(mockGetTvShowRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
        return tvBlocDetail;
      },
      act: (bloc) => bloc.add(OnDetailList(tId)),
      expect: () => [
        TvShowDetailStateInit.copyWith(tvDetailState: RequestState.Loading),
        TvShowDetailStateInit.copyWith(
          tvRecommendationState: RequestState.Loading,
          tvDetail: tTvShowDetail,
          tvDetailState: RequestState.Loaded,
          message: '',
        ),
        TvShowDetailStateInit.copyWith(
          tvDetailState: RequestState.Loaded,
          tvDetail: tTvShowDetail,
          tvRecommendationState: RequestState.Error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetTvShowDetail.execute(tId));
        verify(mockGetTvShowRecommendations.execute(tId));
      },
    );

    blocTest<TvBlocDetail, DetailState>(
      'Shoud emit TvShowDetailError when Get TvShow Detail Failed',
      build: () {
        when(mockGetTvShowDetail.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
        when(mockGetTvShowRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvShows));
        return tvBlocDetail;
      },
      act: (bloc) => bloc.add(OnDetailList(tId)),
      expect: () => [
        TvShowDetailStateInit.copyWith(tvDetailState: RequestState.Loading),
        TvShowDetailStateInit.copyWith(
            tvDetailState: RequestState.Error, message: 'Failed'),
      ],
      verify: (_) {
        verify(mockGetTvShowDetail.execute(tId));
        verify(mockGetTvShowRecommendations.execute(tId));
      },
    );
  });

  group('AddToWatchlist TvShow', () {
    blocTest<TvBlocDetail, DetailState>(
      'Shoud emit WatchlistMessage and isAddedToWatchlist True when Success AddWatchlist',
      build: () {
        when(mockSaveWatchlist.execute(tTvShowDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(tTvShowDetail.id))
            .thenAnswer((_) async => true);
        return tvBlocDetail;
      },
      act: (bloc) => bloc.add(AddWatchlist(tTvShowDetail)),
      expect: () => [
        TvShowDetailStateInit.copyWith(watchlistMessage: 'Added to Watchlist'),
        TvShowDetailStateInit.copyWith(
            watchlistMessage: 'Added to Watchlist', isAddedToWatchlist: true),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(tTvShowDetail));
        verify(mockGetWatchlistStatus.execute(tTvShowDetail.id));
      },
    );

    blocTest<TvBlocDetail, DetailState>(
      'Shoud emit watchlistMessage when Failed',
      build: () {
        when(mockSaveWatchlist.execute(tTvShowDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(tTvShowDetail.id))
            .thenAnswer((_) async => false);
        return tvBlocDetail;
      },
      act: (bloc) => bloc.add(AddWatchlist(tTvShowDetail)),
      expect: () => [
        TvShowDetailStateInit.copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(tTvShowDetail));
        verify(mockGetWatchlistStatus.execute(tTvShowDetail.id));
      },
    );
  });

  group('RemoveFromWatchlist TvShow', () {
    // blocTest<TvBlocDetail, DetailState>(
    //   'Shoud emit WatchlistMessage and isAddedToWatchlist False when Success RemoveFromWatchlist',
    //   build: () {
    //     when(mockRemoveWatchlist.execute(tTvShowDetail))
    //         .thenAnswer((_) async => Right('Removed From Watchlist'));
    //     when(mockGetWatchlistStatus.execute(tTvShowDetail.id))
    //         .thenAnswer((_) async => false);
    //     return tvBlocDetail;
    //   },
    //   act: (bloc) => bloc.add(EraseWatchlist(tTvShowDetail)),
    //   expect: () => [
    //     TvShowDetailStateInit.copyWith(
    //         watchlistMessage: 'Removed From Watchlist',
    //         isAddedToWatchlist: false),
    //   ],
    //   verify: (_) {
    //     verify(mockRemoveWatchlist.execute(tTvShowDetail));
    //     verify(mockGetWatchlistStatus.execute(tTvShowDetail.id));
    //   },
    // );

    blocTest<TvBlocDetail, DetailState>(
      'Shoud emit watchlistMessage when Failed',
      build: () {
        when(mockRemoveWatchlist.execute(tTvShowDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(tTvShowDetail.id))
            .thenAnswer((_) async => false);
        return tvBlocDetail;
      },
      act: (bloc) => bloc.add(EraseWatchlist(tTvShowDetail)),
      expect: () => [
        TvShowDetailStateInit.copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockRemoveWatchlist.execute(tTvShowDetail));
        verify(mockGetWatchlistStatus.execute(tTvShowDetail.id));
      },
    );
  });

  group('LoadWatchlistStatus', () {
    blocTest<TvBlocDetail, DetailState>(
      'Should Emit AddWatchlistStatus True',
      build: () {
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return tvBlocDetail;
      },
      act: (bloc) => bloc.add(WatchlistStatus(tId)),
      expect: () => [
        TvShowDetailStateInit.copyWith(isAddedToWatchlist: true),
      ],
      verify: (_) {
        verify(mockGetWatchlistStatus.execute(tTvShowDetail.id));
      },
    );
  });
}

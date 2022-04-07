import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/presentation/bloc_tv/tv_event.dart';
import 'package:core/presentation/bloc_tv/tv_popular_bloc.dart';
import 'package:core/presentation/bloc_tv/tv_state.dart';
import 'package:core/presentation/bloc_tv/tv_top_rated_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core/domain/usecases_tv/get_now_playing_tv.dart';
import 'package:core/domain/usecases_tv/get_popular_tv.dart';
import 'package:core/domain/usecases_tv/get_top_rated_tv.dart';
import 'package:core/presentation/bloc_tv/tv_list_bloc.dart';

import 'tv_show_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTv, GetPopularTv, GetTopRatedTv])
void main() {
  late TvBlocList tvBlocList;
  late MockGetAiringTodayTvShows mockGetAiringTodayTvShows;
  late TvBlocPopular tvBlocPopular;
  late MockGetPopularTvShows mockGetPopularTvShows;
  late TvBlocTopRated tvBlocTopRated;
  late MockGetTopRatedTvShows mockGetTopRatedTvShows;

  setUp(() {
    mockGetAiringTodayTvShows = MockGetAiringTodayTvShows();
    tvBlocList = TvBlocList(mockGetAiringTodayTvShows);
    mockGetPopularTvShows = MockGetPopularTvShows();
    tvBlocPopular = TvBlocPopular(mockGetPopularTvShows);
    mockGetTopRatedTvShows = MockGetTopRatedTvShows();
    tvBlocTopRated = TvBlocTopRated(mockGetTopRatedTvShows);
  });

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
  final tTvShowList = <Tv>[tTvShow];

  group('Airing Today Tv Show list', () {
    test('Initial state should be empty', () {
      expect(tvBlocList.state, TvEmpty());
    });

    blocTest<TvBlocList, TvState>(
      'Should emit [TvShowListLoading, TvShowListLoaded] when data is gotten successfully',
      build: () {
        when(mockGetAiringTodayTvShows.execute())
            .thenAnswer((_) async => Right(tTvShowList));
        return tvBlocList;
      },
      act: (bloc) => bloc.add(OnTvList()),
      expect: () => [
        TvLoading(),
        TvHasData(tTvShowList),
      ],
      verify: (bloc) {
        verify(mockGetAiringTodayTvShows.execute());
      },
    );

    blocTest<TvBlocList, TvState>(
      'Should emit [TvShowListLoading, TvShowListError] when get Failure',
      build: () {
        when(mockGetAiringTodayTvShows.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return tvBlocList;
      },
      act: (bloc) => bloc.add(OnTvList()),
      expect: () => [
        TvLoading(),
        TvError('Failed'),
      ],
      verify: (_) {
        verify(mockGetAiringTodayTvShows.execute());
      },
    );
  });

  group('Popular Tv Show list', () {
    test('Initial state should be empty', () {
      expect(tvBlocPopular.state, TvEmpty());
    });

    blocTest<TvBlocPopular, TvState>(
      'Should emit [TvShowListLoading, TvShowListLoaded] when data is gotten successfully',
      build: () {
        when(mockGetPopularTvShows.execute())
            .thenAnswer((_) async => Right(tTvShowList));
        return tvBlocPopular;
      },
      act: (bloc) => bloc.add(OnTvList()),
      expect: () => [
        TvLoading(),
        TvHasData(tTvShowList),
      ],
      verify: (bloc) {
        verify(mockGetPopularTvShows.execute());
      },
    );

    blocTest<TvBlocPopular, TvState>(
      'Should emit [TvShowListLoading, TvShowListError] when get Failure',
      build: () {
        when(mockGetPopularTvShows.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return tvBlocPopular;
      },
      act: (bloc) => bloc.add(OnTvList()),
      expect: () => [
        TvLoading(),
        TvError('Failed'),
      ],
      verify: (_) {
        verify(mockGetPopularTvShows.execute());
      },
    );
  });

  group('Top rated Tv Show list', () {
    test('Initial state should be empty', () {
      expect(tvBlocTopRated.state, TvEmpty());
    });

    blocTest<TvBlocTopRated, TvState>(
      'Should emit [TvShowListLoading, TvShowListLoaded] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTvShows.execute())
            .thenAnswer((_) async => Right(tTvShowList));
        return tvBlocTopRated;
      },
      act: (bloc) => bloc.add(OnTvList()),
      expect: () => [
        TvLoading(),
        TvHasData(tTvShowList),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvShows.execute());
      },
    );

    blocTest<TvBlocTopRated, TvState>(
      'Should emit [TvShowListLoading, TvShowListError] when get Failure',
      build: () {
        when(mockGetTopRatedTvShows.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return tvBlocTopRated;
      },
      act: (bloc) => bloc.add(OnTvList()),
      expect: () => [
        TvLoading(),
        TvError('Failed'),
      ],
      verify: (_) {
        verify(mockGetTopRatedTvShows.execute());
      },
    );
  });
}

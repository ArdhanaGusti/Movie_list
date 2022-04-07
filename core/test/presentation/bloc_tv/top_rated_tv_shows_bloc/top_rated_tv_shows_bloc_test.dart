import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/presentation/bloc_tv/tv_event.dart';
import 'package:core/presentation/bloc_tv/tv_state.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core/domain/usecases_tv/get_top_rated_tv.dart';
import 'package:core/presentation/bloc_tv/tv_top_rated_bloc.dart';

import 'top_rated_tv_shows_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTv])
void main() {
  late MockGetTopRatedTvShows mockGetTopRatedTvShows;
  late TvBlocTopRated tvBlocTopRated;

  setUp(() {
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

  group('Top Rated Tv Shows', () {
    test('Initial state should be empty', () {
      expect(tvBlocTopRated.state, TvEmpty());
    });

    blocTest<TvBlocTopRated, TvState>(
      'Should emit [TvLoading, TvHasData] when data is gotten successfully',
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
      'Should emit [TvLoading, TvHasData[], TopRatedTvShowsEmpty] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTvShows.execute())
            .thenAnswer((_) async => Right(<Tv>[]));
        return tvBlocTopRated;
      },
      act: (bloc) => bloc.add(OnTvList()),
      expect: () => [
        TvLoading(),
        TvHasData(<Tv>[]),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvShows.execute());
      },
    );

    blocTest<TvBlocTopRated, TvState>(
      'Should emit [TvLoading, TopRatedTvShowsError] when get Failure',
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

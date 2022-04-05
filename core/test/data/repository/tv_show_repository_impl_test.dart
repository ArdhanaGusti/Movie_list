import 'dart:io';

import 'package:core/data/models/tv_detail_model.dart';
import 'package:core/data/models/tv_model.dart';
import 'package:core/data/repositories/tv_repository_impl.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_data_tv_detail.dart';
import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockTvLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockTvLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TvRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tTvShowModel = TvModel(
      backdropPath: '/qw3J9cNeLioOLoR68WX7z79aCdK.jpg',
      genreIds: [10759, 9648, 18],
      id: 93405,
      name: 'Squid Game',
      originalName: '오징어 게임',
      overview:
          'Hundreds of cash-strapped players accept a strange invitation to compete in children\'s games—with high stakes. But, a tempting prize awaits the victor.',
      popularity: 3686.872,
      posterPath: '/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg',
      voteAverage: 7.8,
      voteCount: 8271,
      originalLanguage: null,
      originCountry: null);

  final tTvShow = Tv(
      backdropPath: '/qw3J9cNeLioOLoR68WX7z79aCdK.jpg',
      genreIds: [10759, 9648, 18],
      id: 93405,
      name: 'Squid Game',
      originalName: '오징어 게임',
      overview:
          'Hundreds of cash-strapped players accept a strange invitation to compete in children\'s games—with high stakes. But, a tempting prize awaits the victor.',
      popularity: 3686.872,
      posterPath: '/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg',
      voteAverage: 7.8,
      voteCount: 8271);

  final tTvShowModelList = <TvModel>[tTvShowModel];
  final tTvShowList = <Tv>[tTvShow];

  group('Now Playing Tv Shows', () {
    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getNowPlayingTv()).thenAnswer((_) async => []);
      //act
      await repository.getNowPlayingTv();
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getNowPlayingTv())
            .thenAnswer((_) async => tTvShowModelList);
        // act
        final result = await repository.getNowPlayingTv();
        // assert
        verify(mockRemoteDataSource.getNowPlayingTv());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvShowList);
      });

      test(
          'should cache data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getNowPlayingTv())
            .thenAnswer((_) async => tTvShowModelList);
        // act
        await repository.getNowPlayingTv();
        // assert
        verify(mockRemoteDataSource.getNowPlayingTv());
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getNowPlayingTv())
            .thenThrow(ServerException());
        // act
        final result = await repository.getNowPlayingTv();
        // assert
        verify(mockRemoteDataSource.getNowPlayingTv());
        expect(result, equals(Left(ServerFailure(''))));
      });

      test(
          'should return Certification Failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getNowPlayingTv()).thenThrow(TlsException());
        // act
        final result = await repository.getNowPlayingTv();
        // assert
        verify(mockRemoteDataSource.getNowPlayingTv());
        expect(
            result, equals(Left(CommonFailure('Certificated Not Valid:\n'))));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return CacheFailure when app has no cache', () async {
        // arrange
        when(mockLocalDataSource.getCachedNowPlayingTv())
            .thenThrow(CacheException('No Cache'));
        // act
        final result = await repository.getNowPlayingTv();
        // assert
        verify(mockLocalDataSource.getCachedNowPlayingTv());
        expect(result, Left(CacheFailure('No Cache')));
      });
    });
  });

  group('Popular Tv Shows', () {
    // test('should check if the device is online', () async {
    //   //arrange
    //   when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    //   when(mockRemoteDataSource.getPopularTv()).thenAnswer((_) async => []);
    //   //act
    //   await repository.getPopularTv();
    //   //assert
    //   verify(mockNetworkInfo.isConnected == true);
    // });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getPopularTv())
            .thenAnswer((_) async => tTvShowModelList);
        // act
        final result = await repository.getPopularTv();
        // assert
        verify(mockRemoteDataSource.getPopularTv());
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvShowList);
      });

      test(
          'should cache data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getPopularTv())
            .thenAnswer((_) async => tTvShowModelList);
        // act
        await repository.getPopularTv();
        // assert
        verify(mockRemoteDataSource.getPopularTv());
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getPopularTv()).thenThrow(ServerException());
        // act
        final result = await repository.getPopularTv();
        // assert
        verify(mockRemoteDataSource.getPopularTv());
        expect(result, equals(Left(ServerFailure(''))));
      });

      test(
          'should return Certification Failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getPopularTv()).thenThrow(TlsException());
        // act
        final result = await repository.getPopularTv();
        // assert
        verify(mockRemoteDataSource.getPopularTv());
        expect(
            result, equals(Left(CommonFailure('Certificated Not Valid:\n'))));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
    });
  });

  group('Now Top Rated Tv Shows', () {
    // test('should check if the device is online', () async {
    //   //arrange
    //   when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    //   when(mockRemoteDataSource.getTopRatedTv()).thenAnswer((_) async => []);
    //   //act
    //   await repository.getTopRatedTv();
    //   //assert
    //   verify(mockNetworkInfo.isConnected);
    // });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedTv())
            .thenAnswer((_) async => tTvShowModelList);
        // act
        final result = await repository.getTopRatedTv();
        // assert
        verify(mockRemoteDataSource.getTopRatedTv());
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvShowList);
      });

      test(
          'should cache data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedTv())
            .thenAnswer((_) async => tTvShowModelList);
        // act
        await repository.getTopRatedTv();
        // assert
        verify(mockRemoteDataSource.getTopRatedTv());
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedTv()).thenThrow(ServerException());
        // act
        final result = await repository.getTopRatedTv();
        // assert
        verify(mockRemoteDataSource.getTopRatedTv());
        expect(result, equals(Left(ServerFailure(''))));
      });

      test(
          'should return Certification Failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedTv()).thenThrow(TlsException());
        // act
        final result = await repository.getTopRatedTv();
        // assert
        verify(mockRemoteDataSource.getTopRatedTv());
        expect(
            result, equals(Left(CommonFailure('Certificated Not Valid:\n'))));
      });
    });

    group('Get Tv Show Detail', () {
      final tId = 1;
      final tTvShowResponse = TvDetailResponse(
        backdropPath: 'backdropPath',
        episodeRunTime: [1, 2],
        firstAirDate: "2021-10-31",
        genres: [Genre(id: 1, name: 'Action')],
        homepage: "https://google.com",
        id: 1,
        inProduction: true,
        lastAirDate: "2021-10-31",
        name: 'name',
        numberOfEpisodes: 1,
        numberOfSeasons: 1,
        originalName: 'originalName',
        overview: 'overview',
        popularity: 1,
        posterPath: 'posterPath',
        seasons: [
          Season(
            episodeCount: 1,
            id: 1,
            name: 'name',
            overview: 'overview',
            posterPath: 'posterPath',
            seasonNumber: 1,
          ),
        ],
        status: 'status',
        tagline: 'tagline',
        type: 'type',
        voteAverage: 5.0,
        voteCount: 1,
        adult: false,
        createdBy: [],
        languages: [],
        networks: [],
        originalLanguage: '',
        originCountry: [],
        productionCompanies: [],
        productionCountries: [],
        spokenLanguages: [],
      );

      // test(
      //     'should return Tv Show data when the call to remote data source is successful',
      //     () async {
      //   // arrange
      //   when(mockRemoteDataSource.getTvDetail(tId))
      //       .thenAnswer((_) async => tTvShowResponse);
      //   // act
      //   final result = await repository.getTvDetail(tId);
      //   // assert
      //   verify(mockRemoteDataSource.getTvDetail(tId));
      //   expect(result, equals(Right(testTvShowDetail)));
      // });

      test(
          'should return Server Failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getTvDetail(tId))
            .thenThrow(ServerException());
        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvDetail(tId));
        expect(result, equals(Left(ServerFailure(''))));
      });

      test(
          'should return connection failure when the device is not connected to internet',
          () async {
        // arrange
        when(mockRemoteDataSource.getTvDetail(tId))
            .thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvDetail(tId));
        expect(
            result,
            equals(
                Left(ConnectionFailure('Failed to connect to the network'))));
      });

      test(
          'should return Certification Failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getTvDetail(tId)).thenThrow(TlsException());
        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvDetail(tId));
        expect(
            result, equals(Left(CommonFailure('Certificated Not Valid:\n'))));
      });
    });

    group('Get Tv Show Recommendations', () {
      final tTvShowList = <TvModel>[];
      final tId = 1;

      test(
          'should return data Tv Show Recommendations when the call is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getTvRecommendations(tId))
            .thenAnswer((_) async => tTvShowList);
        // act
        final result = await repository.getTvRecommendations(tId);
        // assert
        verify(mockRemoteDataSource.getTvRecommendations(tId));
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, equals(tTvShowList));
      });

      test(
          'should return server failure when call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getTvRecommendations(tId))
            .thenThrow(ServerException());
        // act
        final result = await repository.getTvRecommendations(tId);
        // assertbuild runner
        verify(mockRemoteDataSource.getTvRecommendations(tId));
        expect(result, equals(Left(ServerFailure(''))));
      });

      test(
          'should return connection failure when the device is not connected to the internet',
          () async {
        // arrange
        when(mockRemoteDataSource.getTvRecommendations(tId))
            .thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvRecommendations(tId);
        // assert
        verify(mockRemoteDataSource.getTvRecommendations(tId));
        expect(
            result,
            equals(
                Left(ConnectionFailure('Failed to connect to the network'))));
      });

      test(
        'should return Certification Failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getTvRecommendations(tId))
              .thenThrow(TlsException());
          // act
          final result = await repository.getTvRecommendations(tId);
          // assert
          verify(mockRemoteDataSource.getTvRecommendations(tId));
          expect(
              result, equals(Left(CommonFailure('Certificated Not Valid:\n'))));
        },
      );
    });

    group('Seach Tv Shows', () {
      final tQuery = 'Game of Thrones';

      test('should return Tv Show list when call to data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.searchTv(tQuery))
            .thenAnswer((_) async => tTvShowModelList);
        // act
        final result = await repository.searchTv(tQuery);
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvShowList);
      });

      test(
          'should return ServerFailure when call to data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.searchTv(tQuery))
            .thenThrow(ServerException());
        // act
        final result = await repository.searchTv(tQuery);
        // assert
        expect(result, Left(ServerFailure('')));
      });

      test(
          'should return ConnectionFailure when device is not connected to the internet',
          () async {
        // arrange
        when(mockRemoteDataSource.searchTv(tQuery))
            .thenThrow(SocketException('Failed to connect to the network'));
        // act
        final result = await repository.searchTv(tQuery);
        // assert
        expect(result,
            Left(ConnectionFailure('Failed to connect to the network')));
      });

      test(
        'should return Certification Failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.searchTv(tQuery)).thenThrow(TlsException());
          // act
          final result = await repository.searchTv(tQuery);
          // assert
          expect(
              result, equals(Left(CommonFailure('Certificated Not Valid:\n'))));
        },
      );
    });

    group('save watchlist', () {
      test('should return success message when saving successful', () async {
        // arrange
        when(mockLocalDataSource.insertWatchlist(testTvShowTable))
            .thenAnswer((_) async => 'Added to Watchlist');
        // act
        final result = await repository.saveWatchlist(testTvShowDetail);
        // assert
        expect(result, Right('Added to Watchlist'));
      });

      test('should return DatabaseFailure when saving unsuccessful', () async {
        // arrange
        when(mockLocalDataSource.insertWatchlist(testTvShowTable))
            .thenThrow(DatabaseException('Failed to add watchlist'));
        // act
        final result = await repository.saveWatchlist(testTvShowDetail);
        // assert
        expect(result, Left(DatabaseFailure('Failed to add watchlist')));
      });
    });

    group('remove watchlist', () {
      test('should return success message when remove successful', () async {
        // arrange
        when(mockLocalDataSource.removeWatchlist(testTvShowTable))
            .thenAnswer((_) async => 'Removed from watchlist');
        // act
        final result = await repository.removeWatchlist(testTvShowDetail);
        // assert
        expect(result, Right('Removed from watchlist'));
      });

      test('should return DatabaseFailure when remove unsuccessful', () async {
        // arrange
        when(mockLocalDataSource.removeWatchlist(testTvShowTable))
            .thenThrow(DatabaseException('Failed to remove watchlist'));
        // act
        final result = await repository.removeWatchlist(testTvShowDetail);
        // assert
        expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
      });
    });

    group('get watchlist status', () {
      test('should return watch status whether data is found', () async {
        // arrange
        final tId = 1;
        when(mockLocalDataSource.getTvById(tId)).thenAnswer((_) async => null);
        // act
        final result = await repository.isAddedToWatchlist(tId);
        // assert
        expect(result, false);
      });
    });

    group('get watchlist Tv Shows', () {
      test('should return list of Tv Shows', () async {
        // arrange
        when(mockLocalDataSource.getWatchlistTv())
            .thenAnswer((_) async => [testTvShowTable]);
        // act
        final result = await repository.getWatchlistTv();
        // assert
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testWatchlistTvShow]);
      });
    });
  });
}

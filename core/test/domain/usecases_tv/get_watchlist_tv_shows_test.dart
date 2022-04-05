import 'package:core/domain/usecases_tv/get_watchlist_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTv usecase;
  late MockTvRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvRepository();
    usecase = GetWatchlistTv(mockTvShowRepository);
  });

  test('should get list of Tv Shows from the repository', () async {
    // arrange
    when(mockTvShowRepository.getWatchlistTv())
        .thenAnswer((_) async => Right(testTvShowList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testTvShowList));
  });
}

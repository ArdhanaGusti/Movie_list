import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases_tv/get_tv_recommendations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvRecommendations usecase;
  late MockTvRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvRepository();
    usecase = GetTvRecommendations(mockTvShowRepository);
  });

  final tId = 1;
  final tTvShows = <Tv>[];

  test('should get list of Tv Show recommendations from the repository',
      () async {
    // arrange
    when(mockTvShowRepository.getTvRecommendations(tId))
        .thenAnswer((_) async => Right(tTvShows));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tTvShows));
  });
}

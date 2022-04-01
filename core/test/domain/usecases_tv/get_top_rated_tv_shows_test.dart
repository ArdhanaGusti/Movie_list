import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases_tv/get_top_rated_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTv usecase;
  late MockTvRepository mockTvShowRepository;

  setUp(() {
    mockTvShowRepository = MockTvRepository();
    usecase = GetTopRatedTv(mockTvShowRepository);
  });

  final tTvShows = <Tv>[];

  test('should get list of Tv Shows from repository', () async {
    // arrange
    when(mockTvShowRepository.getTopRatedTv())
        .thenAnswer((_) async => Right(tTvShows));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvShows));
  });
}

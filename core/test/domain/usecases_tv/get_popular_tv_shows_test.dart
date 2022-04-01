import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases_tv/get_popular_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTv usecase;
  late MockTvRepository mockTvShowRpository;

  setUp(() {
    mockTvShowRpository = MockTvRepository();
    usecase = GetPopularTv(mockTvShowRpository);
  });

  final tTvShows = <Tv>[];

  group('GetPopularTv Tests', () {
    group('execute', () {
      test(
          'should get list of Tv Shows from the repository when execute function is called',
          () async {
        // arrange
        when(mockTvShowRpository.getPopularTv())
            .thenAnswer((_) async => Right(tTvShows));
        // act
        final result = await usecase.execute();
        // assert
        expect(result, Right(tTvShows));
      });
    });
  });
}

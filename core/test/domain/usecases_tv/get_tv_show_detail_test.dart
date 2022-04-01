// import 'package:core/domain/usecases_tv/get_tv_detail.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';

// import '../../dummy_data/dummy_objects.dart';
// import '../../helpers/test_helper.mocks.dart';

// void main() {
//   late GetTvDetail usecase;
//   late MockTvRepository mockTvShowRepository;

//   setUp(() {
//     mockTvShowRepository = MockTvRepository();
//     usecase = GetTvDetail(mockTvShowRepository);
//   });

//   final tId = 1;

//   test('should get Tv Show detail from the repository', () async {
//     // arrange
//     when(mockTvShowRepository.getTvDetail(tId))
//         .thenAnswer((_) async => Right(testTvDetail));
//     // act
//     final result = await usecase.execute(tId);
//     // assert
//     expect(result, Right(testTvDetail));
//   });
// }

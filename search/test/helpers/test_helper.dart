import 'package:core/data/datasources/db/database_helper_movie.dart';
import 'package:core/data/datasources/db/database_helper_tv.dart';
import 'package:core/data/datasources/local/movie_local_data_source.dart';
import 'package:core/data/datasources/local/tv_series_local_data_source.dart';
import 'package:core/data/datasources/remote/movie_remote_data_source.dart';
import 'package:core/data/datasources/remote/tv_series_remote_data_source.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/utils/network_info.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  TvRemoteDataSource,
  TvLocalDataSource,
  TvRepository,
  NetworkInfo,
  DatabaseHelperMovie,
  DatabaseHelperTv,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}

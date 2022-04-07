// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:core/presentation/bloc_movie/movie_detail/movie_detail_bloc.dart';
import 'package:core/presentation/bloc_movie/movie_list_bloc.dart';
import 'package:core/presentation/bloc_movie/movie_popular_bloc.dart';
import 'package:core/presentation/bloc_movie/movie_top_rated_bloc.dart';
import 'package:core/presentation/bloc_movie/movie_watchlist/movie_watchlist_bloc.dart';
import 'package:core/presentation/bloc_tv/tv_detail/tv_detail_bloc.dart';
import 'package:core/presentation/bloc_tv/tv_list_bloc.dart';
import 'package:core/presentation/bloc_tv/tv_popular_bloc.dart';
import 'package:core/presentation/bloc_tv/tv_top_rated_bloc.dart';
import 'package:core/presentation/bloc_tv/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:core/utils/ssl_pin.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:core/core.dart';
import 'package:search/search.dart';
import 'package:core/utils/network_info.dart';
import 'package:core/data/datasources/db/database_helper_movie.dart';
import 'package:core/data/datasources/db/database_helper_tv.dart';
import 'package:core/data/datasources/local/movie_local_data_source.dart';
import 'package:core/data/datasources/local/tv_series_local_data_source.dart';
import 'package:core/data/datasources/remote/movie_remote_data_source.dart';
import 'package:core/data/datasources/remote/tv_series_remote_data_source.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/data/repositories/tv_repository_impl.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:core/domain/usecases_tv/get_watchlist_status.dart';
import 'package:core/domain/usecases_tv/remove_watchlist.dart';
import 'package:core/domain/usecases_tv/save_watchlist.dart';
import 'package:core/domain/usecases_tv/get_now_playing_tv.dart';
import 'package:core/domain/usecases_tv/get_popular_tv.dart';
import 'package:core/domain/usecases_tv/get_top_rated_tv.dart';
import 'package:core/domain/usecases_tv/get_tv_detail.dart';
import 'package:core/domain/usecases_tv/get_tv_recommendations.dart';
import 'package:core/domain/usecases_tv/get_watchlist_tv.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  locator.registerFactory(
    () => SearchBlocMovie(
      locator(),
    ),
  );
  locator.registerFactory(
    () => SearchBlocTv(
      locator(),
    ),
  );
  locator.registerFactory(
    () => MovieBlocList(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TvBlocList(
      locator(),
    ),
  );
  locator.registerFactory(
    () => MovieBlocPopular(
      locator(),
    ),
  );
  locator.registerFactory(
    () => MovieBlocTopRated(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TvBlocPopular(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TvBlocTopRated(
      locator(),
    ),
  );
  locator.registerFactory(
    () => MovieBlocDetail(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => TvBlocDetail(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
      getWatchListStatus: locator(),
      removeWatchlist: locator(),
      saveWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieBlocWatchList(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TvBlocWatchList(
      locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetNowPlayingTv(locator()));
  locator.registerLazySingleton(() => GetPopularTv(locator()));
  locator.registerLazySingleton(() => GetTopRatedTv(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTv(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTv(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));
  locator.registerLazySingleton(() => GetWatchlistTv(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(
      () => TvLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator
      .registerLazySingleton<DatabaseHelperMovie>(() => DatabaseHelperMovie());
  locator.registerLazySingleton<DatabaseHelperTv>(() => DatabaseHelperTv());

  // network info
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  // external
  locator.registerLazySingleton(() => HttpSSLPinning.client);
  locator.registerLazySingleton(() => InternetConnectionChecker());
}

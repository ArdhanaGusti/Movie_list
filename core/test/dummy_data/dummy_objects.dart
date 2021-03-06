import 'package:core/data/models/movie_table.dart';
// import 'package:core/data/models/tv_detail_model.dart';
import 'package:core/data/models/tv_table.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/entities/tv.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testTvShow = Tv(
  backdropPath: 'backdropPath',
  genreIds: [10, 20],
  id: 1,
  name: 'name',
  originalName: 'originalName',
  overview: 'overview',
  popularity: 5.0,
  posterPath: 'posterPath',
  voteAverage: 5.0,
  voteCount: 1,
);

final testMovieList = [testMovie];
final testTvShowList = [testTvShow];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testMovieCache = MovieTable(
  id: 557,
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  title: 'Spider-Man',
);

final testTvShowCache = TvTable(
  id: 93405,
  name: 'Squid Game',
  posterPath: '/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg',
  overview:
      'Hundreds of cash-strapped players accept a strange invitation to compete in children\'s games???with high stakes. But, a tempting prize awaits the victor.',
);

final testMovieCacheMap = {
  'id': 557,
  'overview':
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  'posterPath': '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  'title': 'Spider-Man',
};

final testTvShowCacheMap = {
  'id': 93405,
  'name': 'Squid Game',
  'posterPath': '/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg',
  'overview':
      'Hundreds of cash-strapped players accept a strange invitation to compete in children\'s games???with high stakes. But, a tempting prize awaits the victor.',
};

final testMovieFromCache = Movie.watchlist(
  id: 557,
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  title: 'Spider-Man',
);

final testTvShowFromCache = Tv.watchlist(
  id: 93405,
  overview:
      'Hundreds of cash-strapped players accept a strange invitation to compete in children\'s games???with high stakes. But, a tempting prize awaits the victor.',
  posterPath: '/dDlEmu3EZ0Pgg93K2SVNLCjCSvE.jpg',
  name: 'Squid Game',
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testWatchlistTvShow = Tv.watchlist(
    id: 1, overview: 'overview', posterPath: 'posterPath', name: 'name');

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvShowTable = TvTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTvShowMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};

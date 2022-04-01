import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchMovieEmpty extends SearchState {}

class SearchMovieLoading extends SearchState {}

class SearchMovieError extends SearchState {
  final String message;

  const SearchMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchMovieHasData extends SearchState {
  final List<Movie> result;

  const SearchMovieHasData(this.result);

  @override
  List<Object> get props => [result];
}

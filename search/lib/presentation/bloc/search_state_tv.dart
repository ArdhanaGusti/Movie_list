import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

abstract class SearchStateTv extends Equatable {
  const SearchStateTv();

  @override
  List<Object> get props => [];
}

class SearchTvEmpty extends SearchStateTv {}

class SearchTvLoading extends SearchStateTv {}

class SearchTvError extends SearchStateTv {
  final String message;

  const SearchTvError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchTvHasData extends SearchStateTv {
  final List<Tv> result;

  const SearchTvHasData(this.result);

  @override
  List<Object> get props => [result];
}

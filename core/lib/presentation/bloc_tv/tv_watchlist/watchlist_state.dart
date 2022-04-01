import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

abstract class WatchlistStateTv extends Equatable {
  const WatchlistStateTv();

  @override
  List<Object> get props => [];
}

class WatchlistTvEmpty extends WatchlistStateTv {}

class WatchlistTvLoading extends WatchlistStateTv {}

class WatchlistTvError extends WatchlistStateTv {
  final String message;

  const WatchlistTvError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistTvHasData extends WatchlistStateTv {
  final List<Tv> result;

  const WatchlistTvHasData(this.result);

  @override
  List<Object> get props => [result];
}

import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object> get props => [];
}

class WatchlistEmpty extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistError extends WatchlistState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistHasData extends WatchlistState {
  final List<Tv> result;

  const WatchlistHasData(this.result);

  @override
  List<Object> get props => [result];
}

import 'package:core/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object> get props => [];
}

class OnDetailList extends DetailEvent {
  final int id;

  const OnDetailList(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlist extends DetailEvent {
  final TvDetail movieDetail;

  const AddWatchlist(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class EraseWatchlist extends DetailEvent {
  final TvDetail movieDetail;

  const EraseWatchlist(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class WatchlistStatus extends DetailEvent {
  final int id;

  const WatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

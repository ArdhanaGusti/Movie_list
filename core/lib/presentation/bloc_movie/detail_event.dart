import 'package:core/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object> get props => [];
}

class OnDetailList extends DetailEvent {
  final int id;

  OnDetailList(this.id);

  @override
  List<Object> get props => [];
}

class AddWatchlist extends DetailEvent {
  final MovieDetail movieDetail;

  AddWatchlist(this.movieDetail);

  @override
  List<Object> get props => [];
}

class EraseWatchlist extends DetailEvent {
  final MovieDetail movieDetail;

  EraseWatchlist(this.movieDetail);

  @override
  List<Object> get props => [];
}

class WatchlistStatus extends DetailEvent {
  final int id;

  WatchlistStatus(this.id);

  @override
  List<Object> get props => [];
}

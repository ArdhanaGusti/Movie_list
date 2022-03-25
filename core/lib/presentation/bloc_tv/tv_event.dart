import 'package:equatable/equatable.dart';

abstract class TvEvent extends Equatable {
  const TvEvent();

  @override
  List<Object> get props => [];
}

class OnTvList extends TvEvent {
  @override
  List<Object> get props => [];
}

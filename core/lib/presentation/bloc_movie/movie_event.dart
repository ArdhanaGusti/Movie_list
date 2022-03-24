import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class OnMovieList extends MovieEvent {
  @override
  List<Object> get props => [];
}

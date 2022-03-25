import 'package:core/domain/usecases_tv/get_popular_tv.dart';
import 'package:core/presentation/bloc_tv/tv_event.dart';
import 'package:core/presentation/bloc_tv/tv_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvBlocPopular extends Bloc<TvEvent, TvState> {
  final GetPopularTv _nowPlayingTv;

  TvBlocPopular(this._nowPlayingTv) : super(TvEmpty()) {
    on<OnTvList>(
      (event, emit) async {
        emit(TvLoading());
        final result = await _nowPlayingTv.execute();

        result.fold(
          (failure) {
            emit(TvError(failure.message));
          },
          (data) {
            emit(TvHasData(data));
          },
        );
      },
    );
  }
}

import 'package:core/presentation/bloc_tv/tv_event.dart';
import 'package:core/presentation/bloc_tv/tv_state.dart';
import 'package:core/presentation/bloc_tv/tv_top_rated_bloc.dart';
import 'package:core/utils/state_enum.dart';
import 'package:core/presentation/provider_tv/top_rated_tv_notifier.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class TopRatedTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv';

  @override
  _TopRatedTvPageState createState() => _TopRatedTvPageState();
}

class _TopRatedTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    super.initState();
    context.read<TvBlocTopRated>().add(OnTvList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvBlocTopRated, TvState>(
          builder: (context, state) {
            if (state is TvLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvHasData) {
              final result = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = result[index];
                  return TvCard(movie);
                },
                itemCount: result.length,
              );
            } else if (state is TvError) {
              final result = state.message;
              return Text(result);
            } else {
              return const Text('Failed');
            }
          },
        ),
      ),
    );
  }
}

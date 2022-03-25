import 'package:core/presentation/bloc_tv/tv_watchlist/tv_watchlist_bloc.dart';
import 'package:core/presentation/bloc_tv/tv_watchlist/watchlist_event.dart';
import 'package:core/utils/state_enum.dart';
import 'package:core/presentation/provider_tv/watchlist_tv_notifier.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../bloc_tv/tv_watchlist/watchlist_state.dart';

class WatchlistTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv';

  @override
  _WatchlistTvPageState createState() => _WatchlistTvPageState();
}

class _WatchlistTvPageState extends State<WatchlistTvPage> {
  @override
  void initState() {
    super.initState();
    context.read<TvBlocWatchList>().add(WatchlistTv());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvBlocWatchList, WatchlistState>(
          builder: (context, state) {
            if (state is WatchlistLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistHasData) {
              final result = state.result;
              return RefreshIndicator(
                  onRefresh: () async {
                    context.read<TvBlocWatchList>().add(WatchlistTv());
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final movie = result[index];
                      return TvCard(movie);
                    },
                    itemCount: result.length,
                  ));
            } else if (state is WatchlistError) {
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

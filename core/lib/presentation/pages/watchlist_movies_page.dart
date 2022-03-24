import 'package:core/presentation/bloc_movie/movie_watchlist_bloc.dart';
import 'package:core/presentation/bloc_movie/watchlist_event.dart';
import 'package:core/presentation/bloc_movie/watchlist_state.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage> {
  @override
  void initState() {
    super.initState();
    context.read<MovieBlocWatchList>().add(WatchlistMovie());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MovieBlocWatchList, WatchlistState>(
          builder: (context, state) {
            if (state is WatchlistLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistHasData) {
              final result = state.result;
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<MovieBlocWatchList>().add(WatchlistMovie());
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final movie = result[index];
                    return MovieCard(movie);
                  },
                  itemCount: result.length,
                ),
              );
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

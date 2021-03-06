import 'package:core/presentation/bloc_movie/movie_event.dart';
import 'package:core/presentation/bloc_movie/movie_popular_bloc.dart';
import 'package:core/presentation/bloc_movie/movie_state.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    context.read<MovieBlocPopular>().add(OnMovieList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<MovieBlocPopular, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MovieHasData) {
              final result = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = result[index];
                  return MovieCard(movie);
                },
                itemCount: result.length,
              );
            } else if (state is MovieError) {
              final result = state.message;
              return Text(result);
            } else if (state is MovieEmpty) {
              return const Center(child: Text("Data populer kosong"));
            } else {
              return const Text('Failed');
            }
          },
        ),
      ),
    );
  }
}

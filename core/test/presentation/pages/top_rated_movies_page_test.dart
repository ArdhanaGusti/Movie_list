import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc_movie/movie_event.dart';
import 'package:core/presentation/bloc_movie/movie_state.dart';
import 'package:core/presentation/bloc_movie/movie_top_rated_bloc.dart';
import 'package:core/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class TopRatedMoviesEventFake extends Fake implements MovieEvent {}

class TopRatedMoviesStateFake extends Fake implements MovieState {}

class MockTopRatedMoviesBloc extends MockBloc<MovieEvent, MovieState>
    implements MovieBlocTopRated {}

void main() {
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;

  setUpAll(() {
    registerFallbackValue(TopRatedMoviesEventFake());
    registerFallbackValue(TopRatedMoviesStateFake());
  });

  setUp(() {
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieBlocTopRated>.value(
      value: mockTopRatedMoviesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTopRatedMoviesBloc.state).thenReturn(MovieLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(MovieHasData([testMovie]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Empty',
      (WidgetTester tester) async {
    when(() => mockTopRatedMoviesBloc.state).thenReturn(MovieEmpty());

    final textFinder = find.text('Data top rated kosong');

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}

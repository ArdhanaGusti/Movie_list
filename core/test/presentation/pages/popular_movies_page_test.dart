import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc_movie/movie_event.dart';
import 'package:core/presentation/bloc_movie/movie_popular_bloc.dart';
import 'package:core/presentation/bloc_movie/movie_state.dart';
import 'package:core/presentation/pages/movie/popular_movies_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class PopularMoviesEventFake extends Fake implements MovieEvent {}

class PopularMoviesStateFake extends Fake implements MovieState {}

class MockPopularMoviesBloc extends MockBloc<MovieEvent, MovieState>
    implements MovieBlocPopular {}

void main() {
  late MockPopularMoviesBloc mockPopularMoviesBloc;

  setUpAll(() {
    registerFallbackValue(PopularMoviesEventFake());
    registerFallbackValue(PopularMoviesStateFake());
  });

  setUp(() {
    mockPopularMoviesBloc = MockPopularMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieBlocPopular>.value(
      value: mockPopularMoviesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockPopularMoviesBloc.state).thenReturn(MovieLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockPopularMoviesBloc.state)
        .thenReturn(MovieHasData([testMovie]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Empty',
      (WidgetTester tester) async {
    when(() => mockPopularMoviesBloc.state).thenReturn(MovieEmpty());

    final textFinder = find.text('Data populer kosong');

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}

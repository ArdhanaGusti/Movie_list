import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc_tv/tv_event.dart';
import 'package:core/presentation/bloc_tv/tv_state.dart';
import 'package:core/presentation/bloc_tv/tv_top_rated_bloc.dart';
import 'package:core/presentation/pages/tv/top_rated_tv_pages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class TopRatedTvShowsEventFake extends Fake implements TvEvent {}

class TopRatedTvShowsStateFake extends Fake implements TvState {}

class MockTopRatedTvShowsBloc extends MockBloc<TvEvent, TvState>
    implements TvBlocTopRated {}

void main() {
  late MockTopRatedTvShowsBloc mockTopRatedTvShowsBloc;

  setUpAll(() {
    registerFallbackValue(TopRatedTvShowsEventFake());
    registerFallbackValue(TopRatedTvShowsStateFake());
  });

  setUp(() {
    mockTopRatedTvShowsBloc = MockTopRatedTvShowsBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvBlocTopRated>.value(
      value: mockTopRatedTvShowsBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTopRatedTvShowsBloc.state).thenReturn(TvLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTopRatedTvShowsBloc.state)
        .thenReturn(TvHasData([testTvShow]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Empty',
      (WidgetTester tester) async {
    when(() => mockTopRatedTvShowsBloc.state).thenReturn(TvEmpty());

    final textFinder = find.text('Empty Top Rated Tv Show');

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockTopRatedTvShowsBloc.state).thenReturn(TvError('Failed'));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    expect(textFinder, findsOneWidget);
  });
}

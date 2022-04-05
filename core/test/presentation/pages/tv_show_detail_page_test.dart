import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/bloc_tv/tv_detail/detail_event.dart';
import 'package:core/presentation/bloc_tv/tv_detail/detail_state.dart';
import 'package:core/presentation/bloc_tv/tv_detail/tv_detail_bloc.dart';
import 'package:core/presentation/pages/tv/tv_series_detail_page.dart';
import 'package:core/utils/state_enum.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_data_tv_detail.dart';
import '../../dummy_data/dummy_objects.dart';

class TvShowDetailEventFake extends Fake implements DetailEvent {}

class TvShowDetailStateFake extends Fake implements DetailState {}

class MockTvShowDetailBloc extends MockBloc<DetailEvent, DetailState>
    implements TvBlocDetail {}

void main() {
  late MockTvShowDetailBloc mockTvShowDetailBloc;

  setUpAll(() {
    registerFallbackValue(TvShowDetailEventFake());
    registerFallbackValue(TvShowDetailStateFake());
  });

  setUp(() {
    mockTvShowDetailBloc = MockTvShowDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvBlocDetail>.value(
      value: mockTvShowDetailBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Detail TvShow Page should display Progressbar when loading',
      (WidgetTester tester) async {
    when(() => mockTvShowDetailBloc.state).thenReturn(
        DetailState.initial().copyWith(tvDetailState: RequestState.Loading));

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('should display loading when recommendationState loading',
      (WidgetTester tester) async {
    when(() => mockTvShowDetailBloc.state)
        .thenReturn(DetailState.initial().copyWith(
      tvDetailState: RequestState.Loaded,
      tvDetail: testTvShowDetail,
      tvRecommendationState: RequestState.Loading,
      tvRecommendations: <Tv>[],
      isAddedToWatchlist: false,
    ));

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(progressBarFinder, findsWidgets);
  });

  testWidgets(
      'Watchlist button should display add icon when Tv Show not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockTvShowDetailBloc.state)
        .thenReturn(DetailState.initial().copyWith(
      tvDetailState: RequestState.Loaded,
      tvDetail: testTvShowDetail,
      tvRecommendationState: RequestState.Loaded,
      tvRecommendations: [testTvShow],
      isAddedToWatchlist: false,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when Tv Show is added to wathclist',
      (WidgetTester tester) async {
    when(() => mockTvShowDetailBloc.state)
        .thenReturn(DetailState.initial().copyWith(
      tvDetailState: RequestState.Loaded,
      tvDetail: testTvShowDetail,
      tvRecommendationState: RequestState.Loaded,
      tvRecommendations: [testTvShow],
      isAddedToWatchlist: true,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    whenListen(
        mockTvShowDetailBloc,
        Stream.fromIterable([
          DetailState.initial().copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvShowDetail,
            tvRecommendationState: RequestState.Loaded,
            tvRecommendations: [testTvShow],
            isAddedToWatchlist: false,
          ),
          DetailState.initial().copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvShowDetail,
            tvRecommendationState: RequestState.Loaded,
            tvRecommendations: [testTvShow],
            isAddedToWatchlist: false,
            watchlistMessage: 'Added to Watchlist',
          ),
        ]),
        initialState: DetailState.initial());

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
    await tester.pump();

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when removed from watchlist',
      (WidgetTester tester) async {
    whenListen(
        mockTvShowDetailBloc,
        Stream.fromIterable([
          DetailState.initial().copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvShowDetail,
            tvRecommendationState: RequestState.Loaded,
            tvRecommendations: [testTvShow],
            isAddedToWatchlist: false,
          ),
          DetailState.initial().copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvShowDetail,
            tvRecommendationState: RequestState.Loaded,
            tvRecommendations: [testTvShow],
            isAddedToWatchlist: false,
            watchlistMessage: 'Removed from Watchlist',
          ),
        ]),
        initialState: DetailState.initial());

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
    await tester.pump();

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Removed from Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    whenListen(
        mockTvShowDetailBloc,
        Stream.fromIterable([
          DetailState.initial().copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvShowDetail,
            tvRecommendationState: RequestState.Loaded,
            tvRecommendations: [testTvShow],
            isAddedToWatchlist: false,
          ),
          DetailState.initial().copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvShowDetail,
            tvRecommendationState: RequestState.Loaded,
            tvRecommendations: [testTvShow],
            isAddedToWatchlist: false,
            watchlistMessage: 'Failed',
          ),
          DetailState.initial().copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvShowDetail,
            tvRecommendationState: RequestState.Loaded,
            tvRecommendations: [testTvShow],
            isAddedToWatchlist: false,
            watchlistMessage: 'Failed ',
          ),
        ]),
        initialState: DetailState.initial());

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
    await tester.pump();

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton, warnIfMissed: false);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets(
      'Detail Tv Show Page should display Error Text when No Internet Network (Error)',
      (WidgetTester tester) async {
    when(() => mockTvShowDetailBloc.state).thenReturn(DetailState.initial()
        .copyWith(
            tvDetailState: RequestState.Error,
            message: 'Failed to connect to the network'));

    final textErrorBarFinder = find.text('Failed to connect to the network');

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
    await tester.pump();

    expect(textErrorBarFinder, findsOneWidget);
  });
}

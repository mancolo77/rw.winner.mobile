import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rw_winner_mobile/screens/main_navigation_screen.dart';
import 'package:rw_winner_mobile/services/rwanda_match_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('RwandaMatchService toggles favorites', () {
    final service = RwandaMatchService();
    expect(service.matches.isNotEmpty, isTrue);
    expect(service.teams.isNotEmpty, isTrue);

    service.toggleFavoriteMatch('rw_m2');
    expect(service.favoriteMatchIds.contains('rw_m2'), isTrue);
    service.toggleFavoriteMatch('rw_m2');
    expect(service.favoriteMatchIds.contains('rw_m2'), isFalse);
  });

  testWidgets('MainNavigationScreen has exactly 3 tabs (Matches, Teams, Favorites)', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainNavigationScreen(),
      ),
    );
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    final navFinder = find.byType(BottomNavigationBar);
    expect(find.descendant(of: navFinder, matching: find.text('Matches')), findsOneWidget);
    expect(find.descendant(of: navFinder, matching: find.text('Teams')), findsOneWidget);
    expect(find.descendant(of: navFinder, matching: find.text('Favorites')), findsOneWidget);

    // Switch to Teams
    await tester.tap(find.descendant(of: navFinder, matching: find.text('Teams')));
    await tester.pumpAndSettle();
    expect(find.text('Clubs of the Rwanda Premier League'), findsOneWidget);

    // Switch to Favorites
    await tester.tap(find.descendant(of: navFinder, matching: find.text('Favorites')));
    await tester.pumpAndSettle();
    expect(find.text('Followed Rwanda teams and bookmarked matches'), findsOneWidget);
  });
}

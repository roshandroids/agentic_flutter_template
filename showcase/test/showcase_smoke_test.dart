import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:showcase/main.dart';

void main() {
  testWidgets('renders every showcase section without error', (tester) async {
    // Tall viewport so every section is on-screen without scrolling - the
    // ListView otherwise leaves far-down sections unbuilt.
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // Not pumpAndSettle: the "Loading" section's CircularProgressIndicator
    // animates indefinitely, so pumpAndSettle would time out waiting for
    // it to settle. A couple of fixed pumps is enough for everything else
    // to finish building.
    await tester.pumpWidget(const ShowcaseApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Buttons'), findsOneWidget);
    expect(find.text('Loading'), findsWidgets);
    expect(find.text('Error'), findsOneWidget);
    expect(find.text('Empty'), findsOneWidget);
    expect(find.text('Spacing scale'), findsOneWidget);
    expect(find.text('Radius scale'), findsOneWidget);
  });
}

import 'package:balancika_demo/main.dart';
import 'package:balancika_demo/state/app_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('browse, add to cart, and place a demo order', (
    WidgetTester tester,
  ) async {
    final AppStore store = AppStore();
    tester.view.physicalSize = const Size(480, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(BalancikaApp(store: store));
    await tester.pumpAndSettle();

    expect(find.text('Balancika Demo'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'amok');
    await tester.pumpAndSettle();
    expect(find.text('Amok Trey'), findsOneWidget);
    expect(find.text('Beef Lok Lak'), findsNothing);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();

    expect(find.text('Amok Trey'), findsOneWidget);

    await tester.tap(find.text('Amok Trey'));
    await tester.pumpAndSettle();
    expect(find.text('Add to cart · ៛35,000'), findsOneWidget);

    await tester.tap(find.byTooltip('Increase quantity'));
    await tester.pump();
    expect(find.text('Add to cart · ៛70,000'), findsOneWidget);

    await tester.tap(find.text('Add to cart · ៛70,000'));
    await tester.pumpAndSettle();
    expect(store.cartCount, 2);
    expect(find.textContaining('added to cart'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cart'));
    await tester.pumpAndSettle();
    expect(find.text('My cart'), findsOneWidget);
    expect(find.text('៛70,000'), findsWidgets);

    await tester.tap(find.text('Place order'));
    await tester.pumpAndSettle();
    expect(find.text('Order placed!'), findsOneWidget);
    expect(store.orders.length, 1);
    expect(store.cartIsEmpty, isTrue);

    await tester.tap(find.text('Back to menu'));
    await tester.pumpAndSettle();
    expect(store.selectedTab, 0);
    expect(find.text('Balancika Demo'), findsOneWidget);
  });
}

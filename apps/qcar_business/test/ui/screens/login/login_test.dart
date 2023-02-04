import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_business/core/models/seller_info.dart';
import 'package:qcar_business/ui/screens/home/home_page.dart';

import '../../../builder/entity_builder.dart';
import '../../../mocks/network_client_mock.dart';
import '../../../utils/test_l10n.dart';
import 'login_action.dart';

void main() {
  testWidgets(
    'show login page - all logged out',
    (WidgetTester tester) async {
      final infra = await pushToLogin(tester);
      expect(await infra.authService.isSellerLoggedIn(), isFalse);
      expect(await infra.authService.isDealerLoggedIn(), isFalse);
    },
  );

  testWidgets(
    'load dealer - show not found snackbar',
    (WidgetTester tester) async {
      final l10n = await getTestL10n();

      final infra = await pushToLogin(tester);
      final name = "NoDealer";
      mockClientDealerError(client: infra.loadClient, name: name);

      await loginDealer(tester, name);
      expect(find.text(l10n.noDealerFound(name)), findsOneWidget);
      expect(await infra.authService.isDealerLoggedIn(), isFalse);
    },
  );

  testWidgets(
    'load dealer - dealer logged in',
    (WidgetTester tester) async {
      final l10n = await getTestL10n();

      final dealer = await buildDealerInfo();
      final infra = await createLoginInfra(dealerInfo: dealer);
      await pushToLogin(tester, infra: infra);

      await loginDealer(tester, dealer.name);
      expect(find.text(l10n.noDealerFound(dealer.name)), findsNothing);
      expect(await infra.authService.isDealerLoggedIn(), isTrue);
      expect(find.byType(ElevatedButton), findsNothing);
    },
  );

  testWidgets(
    'select seller - seller logged in - show home page',
    (WidgetTester tester) async {
      final dealer = await buildDealerInfo();
      final sellers = await buildSellerInfos();
      final infra =
          await createLoginInfra(dealerInfo: dealer, sellerInfos: sellers);
      await pushToLogin(tester, infra: infra);

      expect(find.byType(DropdownMenuItem<SellerInfo>), findsNWidgets(0));
      await loginDealer(tester, dealer.name, settle: true);

      await tester.tap(find.byType(DropdownButton<SellerInfo>));
      await tester.pumpAndSettle();
      expect(find.byType(DropdownMenuItem<SellerInfo>),
          findsNWidgets(3 * 2)); // DropdownMenuItem are always doubled

      await tester.tap(find.byType(DropdownMenuItem<SellerInfo>).last);
      await tester.pumpAndSettle();

      expect(await infra.authService.isSellerLoggedIn(), isTrue);
      expect(find.byType(HomePage), findsOneWidget);
    },
  );
}

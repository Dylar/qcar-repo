import 'package:flutter_test/flutter_test.dart';
import 'package:qcar_customer/ui/screens/home/home_page.dart';
import 'package:qcar_customer/ui/viewmodels/home_vm.dart';

HomeViewModel getHomeViewModel() => find
    .byType(HomePage)
    .evaluate()
    .map((e) => e.widget)
    .whereType<HomePage>()
    .first
    .viewModel;

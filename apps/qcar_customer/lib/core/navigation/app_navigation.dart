import 'package:flutter/material.dart';
import 'package:qcar_customer/core/app_theme.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/core/navigation/navi.dart';
import 'package:qcar_customer/ui/screens/home/home_page.dart';
import 'package:qcar_customer/ui/screens/overview/car_overview_page.dart';
import 'package:qcar_customer/ui/screens/qr_scan/qr_scan_page.dart';
import 'package:qcar_customer/ui/screens/settings/settings_page.dart';
import 'package:qcar_customer/ui/screens/video/video_overview_page.dart';
import 'package:qcar_customer/ui/screens/video/video_page.dart';
import 'package:qcar_customer/ui/snackbars/snackbars.dart';
import 'package:qcar_customer/ui/widgets/loading_overlay.dart';

import '../../service/services.dart';
import '../../ui/screens/dir/dir_page.dart';
import '../tracking.dart';

final naviBarData = <Triple<List<String>, String, IconData>>[
  Triple([HomePage.routeName], "Home", Icons.home_outlined),
  Triple(
    [
      CarOverviewPage.routeName,
      DirPage.routeName,
      VideoOverviewPage.routeName,
      VideoPage.routeName,
    ],
    "Videos",
    Icons.ondemand_video_sharp,
  ),
  Triple([QrScanPage.routeName], "QR", Icons.qr_code_scanner),
  Triple([SettingsPage.routeName], "Settings", Icons.settings),
];

class AppNavigation extends StatefulWidget {
  const AppNavigation(this.routeName);

  final String routeName;

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  late int _pageIndex;

  @override
  void initState() {
    super.initState();
    _pageIndex = naviBarData
        .indexWhere((data) => data.firstOrThrow.contains(widget.routeName));
    if (_pageIndex == -1) {
      throw Exception("Route (${widget.routeName}) not in list");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor = theme.tabBarTheme.labelColor;
    final unselectedColor = theme.tabBarTheme.unselectedLabelColor;
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme.bottomAppBarTheme.color,
      selectedItemColor: selectedColor,
      unselectedItemColor: unselectedColor,
      currentIndex: _pageIndex,
      items: _buildIcons(
        selectedColor?.withOpacity(OPACITY_20),
        unselectedColor?.withOpacity(OPACITY_2),
      ),
      onTap: (index) => _onItemTapped(context, index),
    );
  }

  List<BottomNavigationBarItem> _buildIcons(
    Color? selectedColor,
    Color? unselectedColor,
  ) =>
      naviBarData
          .asMap()
          .map<int, BottomNavigationBarItem>(
            (i, data) => MapEntry(
              i,
              BottomNavigationBarItem(
                icon: _buildIcon(i, unselectedColor, data),
                label: data.middleOrThrow,
              ),
            ),
          )
          .values
          .toList();

  Widget _buildIcon(
    int i,
    Color? unselectedColor,
    Triple<List<String>, String, IconData> data,
  ) =>
      Container(
        decoration: BoxDecoration(
          gradient: _pageIndex == i
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    BaseColors.babyBlue,
                    BaseColors.zergPurple,
                  ],
                  tileMode: TileMode.clamp,
                )
              : null,
          color: _pageIndex == i ? null : unselectedColor,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(data.lastOrThrow),
        ),
      );

  Future<void> _onItemTapped(BuildContext context, int index) async {
    final isSame = index == _pageIndex;
    if (isSame) {
      showAlreadyHereSnackBar(context);
      return;
    }
    final routeName = naviBarData[index];
    final thisIsHome = _pageIndex == 0;
    AppRouteSpec routeSpec;
    switch (routeName.firstOrThrow.first) {
      case HomePage.routeName:
        Logger.logI("Home tapped");
        routeSpec = HomePage.poopToRoot();
        break;
      case CarOverviewPage.routeName:
        Logger.logI("Videos tapped");
        final cars = await Services.of(context)!
            .carInfoService
            .carInfoDataSource
            .getAllCars();
        if (cars.length == 1) {
          routeSpec = DirPage.pushIt(cars.first);
        } else {
          routeSpec = thisIsHome
              ? CarOverviewPage.pushIt()
              : CarOverviewPage.popAndPush();
        }
        break;
      case QrScanPage.routeName:
        Logger.logI("QR tapped");
        routeSpec = routeSpec =
            thisIsHome ? QrScanPage.pushIt() : QrScanPage.popAndPush();
        break;
      case SettingsPage.routeName:
        Logger.logI("Settings tapped");
        routeSpec = routeSpec =
            thisIsHome ? SettingsPage.pushIt() : SettingsPage.popAndPush();
        break;
      default:
        throw Exception("No route found");
    }
    Logger.logI("Navi to: ${routeSpec.name}");
    Navigate.to(context, routeSpec);
  }
}

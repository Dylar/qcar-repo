import 'package:flutter/material.dart';
import 'package:qcar_customer/core/service/services.dart';
import 'package:qcar_customer/ui/mixins/feedback_fun.dart';
import 'package:qcar_customer/ui/notify/dialog.dart';
import 'package:qcar_customer/ui/notify/snackbars.dart';
import 'package:qcar_customer/ui/screens/cars/cars_page.dart';
import 'package:qcar_customer/ui/screens/cars/categories_page.dart';
import 'package:qcar_customer/ui/screens/home/home_page.dart';
import 'package:qcar_customer/ui/screens/qr_scan/qr_scan_page.dart';
import 'package:qcar_customer/ui/screens/settings/settings_page.dart';
import 'package:qcar_customer/ui/screens/video/favorites_page.dart';
import 'package:qcar_customer/ui/screens/video/video_overview_page.dart';
import 'package:qcar_customer/ui/screens/video/video_page.dart';
import 'package:qcar_shared/core/app_navigate.dart';
import 'package:qcar_shared/core/app_routing.dart';
import 'package:qcar_shared/core/app_theme.dart';
import 'package:qcar_shared/tuple.dart';
import 'package:qcar_shared/widgets/loading_overlay.dart';

const FEEDBACK_ROUTE = "FEEDBACK";

final naviBarData = <Triple<List<String>, String, IconData>>[
  Triple([HomePage.routeName], "Home", Icons.home_outlined),
  Triple(
    [
      CarsPage.routeName,
      CategoriesPage.routeName,
      VideoOverviewPage.routeName,
      VideoPage.routeName,
      FavoritesPage.routeName,
    ],
    "Videos",
    Icons.ondemand_video_sharp,
  ),
  Triple([QrScanPage.routeName], "QR", Icons.qr_code_scanner),
  Triple([FEEDBACK_ROUTE], "Feedback", Icons.feedback),
  Triple([SettingsPage.routeName], "Settings", Icons.settings),
];

class AppNavigation extends StatefulWidget {
  const AppNavigation(this.viewModel, this.routeName);

  final FeedbackViewModel viewModel;
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
  ) {
    return naviBarData
        .asMap()
        .map<int, BottomNavigationBarItem>(
          (i, data) => MapEntry(
            i,
            BottomNavigationBarItem(
              icon: _NaviIcon(_pageIndex, i, unselectedColor, data),
              label: data.middleOrThrow,
            ),
          ),
        )
        .values
        .toList();
  }

  Future<void> _onItemTapped(BuildContext context, int index) async {
    final isSame = index == _pageIndex;
    if (isSame) {
      showAlreadyHereSnackBar(context);
      return;
    }
    final routeName = naviBarData[index];
    final thisIsHome = _pageIndex == 0;
    RoutingSpec routeSpec;
    switch (routeName.firstOrThrow.first) {
      case FEEDBACK_ROUTE:
        await openFeedbackDialog(context, widget.viewModel);
        return;
      case HomePage.routeName:
        routeSpec = HomePage.poopToRoot();
        break;
      case CarsPage.routeName:
        final cars = await Services.of(context)!.infoService.getAllCars();
        if (cars.length == 1) {
          routeSpec = CategoriesPage.pushIt(cars.first);
        } else {
          routeSpec = thisIsHome ? CarsPage.pushIt() : CarsPage.popAndPush();
        }
        break;
      case QrScanPage.routeName:
        routeSpec = routeSpec =
            thisIsHome ? QrScanPage.pushIt() : QrScanPage.popAndPush();
        break;
      case SettingsPage.routeName:
        routeSpec = routeSpec =
            thisIsHome ? SettingsPage.pushIt() : SettingsPage.popAndPush();
        break;
      default:
        throw Exception("No route found");
    }
    Navigate.to(context, routeSpec);
  }
}

class _NaviIcon extends StatelessWidget {
  _NaviIcon(this._pageIndex, this._index, this._unselectedColor, this._data);

  final int _pageIndex;
  final int _index;
  final Color? _unselectedColor;
  final Triple<List<String>, String, IconData> _data;

  @override
  Widget build(BuildContext context) {
    return Container(
      //TODO no track 4 dev
      decoration: BoxDecoration(
        gradient: _pageIndex == _index
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
        color: _pageIndex == _index ? null : _unselectedColor,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(_data.lastOrThrow),
      ),
    );
  }
}

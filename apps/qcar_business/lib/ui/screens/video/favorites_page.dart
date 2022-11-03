import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/core/models/video_info.dart';
import 'package:qcar_business/ui/app_viewmodel.dart';
import 'package:qcar_business/ui/navigation/app_navigation.dart';
import 'package:qcar_business/ui/navigation/navi.dart';
import 'package:qcar_business/ui/screens/video/favorites_vm.dart';
import 'package:qcar_business/ui/screens/video/video_list_item.dart';
import 'package:qcar_business/ui/widgets/error_widget.dart';
import 'package:qcar_business/ui/widgets/scroll_list_view.dart';

class FavoritesPage extends View<FavoritesViewModel> {
  static const String routeName = "/favoritesPage";
  static const ARG_CAR = "cardInfo";

  static AppRouteSpec pushIt(CarInfo carInfo) => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
        arguments: {
          ARG_CAR: carInfo,
        },
      );

  FavoritesPage(FavoritesViewModel viewModel) : super.model(viewModel);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState(viewModel);
}

class _FavoritesPageState extends ViewState<FavoritesPage, FavoritesViewModel> {
  _FavoritesPageState(FavoritesViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoritesPageTitle)),
      body: _buildBody(context, l10n),
      bottomNavigationBar: AppNavigation(viewModel, FavoritesPage.routeName),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    return StreamBuilder<List<VideoInfo>>(
        stream: viewModel.watchVideos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorInfoWidget(snapshot.error!);
          }
          return ScrollListView<VideoInfo>(
            items: snapshot.data?..sort((a, b) => a.name.compareTo(b.name)),
            buildItemWidget: (int index, VideoInfo item) =>
                VideoInfoListItem(item),
          );
        });
  }
}
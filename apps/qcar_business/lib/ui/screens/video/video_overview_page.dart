import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_business/core/models/car_info.dart';
import 'package:qcar_business/core/models/category_info.dart';
import 'package:qcar_business/core/models/video_info.dart';
import 'package:qcar_business/ui/navigation/app_bar.dart';
import 'package:qcar_business/ui/navigation/app_navigation.dart';
import 'package:qcar_business/ui/screens/video/video_list_item.dart';
import 'package:qcar_business/ui/screens/video/video_overview_vm.dart';
import 'package:qcar_shared/core/app_navigate.dart';
import 'package:qcar_shared/core/app_view.dart';
import 'package:qcar_shared/widgets/error_widget.dart';
import 'package:qcar_shared/widgets/scroll_list_view.dart';

class VideoOverviewPage extends View<VideoOverViewModel> {
  static const String routeName = "/videoOverviewPage";
  static const ARG_CAR = "cardInfo";
  static const ARG_CATEGORY = "category";

  static AppRouteSpec pushIt(CarInfo carInfo, CategoryInfo category) =>
      AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
        arguments: {
          ARG_CAR: carInfo,
          ARG_CATEGORY: category,
        },
      );

  VideoOverviewPage(VideoOverViewModel viewModel) : super.model(viewModel);

  @override
  State<VideoOverviewPage> createState() => _VideoOverviewPageState(viewModel);
}

class _VideoOverviewPageState
    extends ViewState<VideoOverviewPage, VideoOverViewModel> {
  _VideoOverviewPageState(VideoOverViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: SearchAppBar(viewModel.selectedCategory.name, viewModel),
      body: _buildBody(context, l10n),
      bottomNavigationBar:
          AppNavigation(viewModel, VideoOverviewPage.routeName),
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

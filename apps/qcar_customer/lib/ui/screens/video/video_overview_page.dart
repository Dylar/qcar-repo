import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:qcar_customer/core/navigation/app_bar.dart';
import 'package:qcar_customer/core/navigation/app_navigation.dart';
import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/core/navigation/navi.dart';
import 'package:qcar_customer/models/car_info.dart';
import 'package:qcar_customer/models/category_info.dart';
import 'package:qcar_customer/models/video_info.dart';
import 'package:qcar_customer/ui/screens/video/video_list_item.dart';
import 'package:qcar_customer/ui/viewmodels/video_overview_vm.dart';
import 'package:qcar_customer/ui/widgets/error_widget.dart';
import 'package:qcar_customer/ui/widgets/scroll_list_view.dart';

class VideoOverviewPage extends View<VideoOverViewModel> {
  static const String routeName = "/videoOverviewPage";
  static const ARG_CAR = "cardInfo";
  static const ARG_DIR = "dir";

  static AppRouteSpec pushIt(CarInfo carInfo, CategoryInfo dir) => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
        arguments: {
          ARG_CAR: carInfo,
          ARG_DIR: dir,
        },
      );

  VideoOverviewPage.model(VideoOverViewModel viewModel)
      : super.model(viewModel);

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
      appBar: SearchAppBar(viewModel.selectedDir.name),
      body: _buildBody(context, l10n),
      bottomNavigationBar: AppNavigation(VideoOverviewPage.routeName),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    final viewModel = context.read<VideoOverViewProvider>().viewModel;
    return StreamBuilder<List<VideoInfo>>(
        stream: viewModel.watchVideos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorInfoWidget(snapshot.error!);
          }

          return ScrollListView<VideoInfo>(
            items: snapshot.data?..sort((a, b) => a.name.compareTo(b.name)),
            buildItemWidget: buildItemWidget,
          );
        });
  }

  Widget buildItemWidget(int index, VideoInfo item) => VideoInfoListItem(item);
}

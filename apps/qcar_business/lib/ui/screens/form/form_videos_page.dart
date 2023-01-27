import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:qcar_business/core/models/model_data.dart';
import 'package:qcar_business/core/models/video_info.dart';
import 'package:qcar_business/ui/screens/form/form_customer_page.dart';
import 'package:qcar_business/ui/screens/form/form_vm.dart';
import 'package:qcar_business/ui/widgets/app_bar.dart';
import 'package:qcar_business/ui/widgets/list/video_list_item.dart';
import 'package:qcar_business/ui/widgets/pic_widget.dart';
import 'package:qcar_shared/core/app_navigate.dart';
import 'package:qcar_shared/core/app_routing.dart';
import 'package:qcar_shared/core/app_view.dart';
import 'package:qcar_shared/tuple.dart';
import 'package:qcar_shared/widgets/deco.dart';
import 'package:qcar_shared/widgets/rounded_widget.dart';

class FormVideosPage extends View<FormViewModel> {
  static const String routeName = "/formVideos";

  static RoutingSpec pushIt(FormViewModel viewModel) => RoutingSpec(
        routeName: routeName,
        action: RouteAction.pushTo,
        transitionTime: const Duration(milliseconds: 200),
        transitionType: TransitionType.rightLeft,
        args: {ARGS_VIEW_MODEL: viewModel},
      );

  FormVideosPage(
    FormViewModel viewModel, {
    Key? key,
  }) : super.model(viewModel, key: key);

  @override
  State<FormVideosPage> createState() => _FormVideoPageState(viewModel);
}

class _FormVideoPageState extends ViewState<FormVideosPage, FormViewModel> {
  _FormVideoPageState(FormViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: buildAppBar(l10n.formVideoTitle),
      body: buildFormPage(context),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () =>
              Navigate.to(context, FormCustomerPage.pushIt(viewModel)),
          child: Text(l10n.continueButton),
        ),
      ),
    );
  }

  Widget buildFormPage(BuildContext context) {
    return GroupedListView<VideoInfo, Tuple<String, String>>(
      shrinkWrap: true,
      elements: viewModel.videos,
      itemBuilder: _buildVideoItem,
      itemComparator: (vid1, vid2) => vid1.name.compareTo(vid2.name),
      groupBy: (vid) => Tuple(vid.category, vid.categoryImageUrl),
      groupSeparatorBuilder: _buildCategoryItem,
      groupComparator: (tuple1, tuple2) =>
          tuple1.firstOrThrow.compareTo(tuple2.firstOrThrow),
    );
  }

  Widget _buildVideoItem(BuildContext context, VideoInfo video) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: viewModel.isVideoSelected(video.category, video),
            onChanged: (value) => viewModel.selectVideo(video.category, video),
          ),
          Flexible(
            child: SizedBox(
              height: 72,
              child: VideoListItem(video,
                  onTap: () => viewModel.selectVideo(video.category, video)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(Tuple<String, String> info) {
    final category = info.firstOrThrow;
    final imgUrl = info.secondOrThrow;
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: viewModel.isVideoSelected(category, null),
            onChanged: (value) => viewModel.selectVideo(category, null),
          ),
          inkTap(
            onTap: () => viewModel.selectVideo(category, null),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 48,
                      child: RoundedWidget(child: PicWidget(imgUrl)),
                    ),
                    Text(
                      category,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

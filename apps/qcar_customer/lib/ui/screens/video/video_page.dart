import 'package:flutter/material.dart';
import 'package:qcar_customer/core/navigation/app_navigation.dart';
import 'package:qcar_customer/core/navigation/app_viewmodel.dart';
import 'package:qcar_customer/core/navigation/navi.dart';
import 'package:qcar_customer/models/settings.dart';
import 'package:qcar_customer/models/video_info.dart';
import 'package:qcar_customer/ui/viewmodels/video_vm.dart';
import 'package:qcar_customer/ui/widgets/video_widget.dart';

class VideoPage extends View<VideoViewModel> {
  static const String routeName = "/VideoPage";
  static const ARG_VIDEO = "video";

  const VideoPage(
    VideoViewModel viewModel, {
    this.aspectRatio,
  }) : super.model(viewModel);

  static AppRouteSpec pushIt({VideoInfo? video}) => AppRouteSpec(
        name: routeName,
        action: AppRouteAction.pushTo,
        arguments: {ARG_VIDEO: video},
      );

  final double? aspectRatio;

  @override
  State<VideoPage> createState() => _VideoPageState(viewModel);
}

class _VideoPageState extends ViewState<VideoPage, VideoViewModel> {
  _VideoPageState(VideoViewModel viewModel) : super(viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(viewModel.title)),
      body: Column(
        children: [
          Flexible(
              child: StreamBuilder<Settings>(
                  stream: viewModel.watchSettings(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || viewModel.videoInfo == null) {
                      return VideoDownload();
                    }
                    return VideoWidget(
                      url: viewModel.videoInfo!.vidUrl,
                      settings: snapshot.data!,
                    );
                  })),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      viewModel.videoInfo!.description,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppNavigation(VideoPage.routeName),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qcar_customer/core/models/video_info.dart';
import 'package:qcar_customer/ui/app_viewmodel.dart';
import 'package:qcar_customer/ui/navigation/app_navigation.dart';
import 'package:qcar_customer/ui/navigation/navi.dart';
import 'package:qcar_customer/ui/screens/video/video_vm.dart';
import 'package:qcar_customer/ui/widgets/rounded_widget.dart';
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
          Expanded(
            flex: 40,
            child: RoundedWidget(child: VideoWidget(viewModel: viewModel)),
          ),
          Spacer(flex: 10),
          Flexible(
            flex: 40,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    viewModel.description,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
            ),
          ),
          Spacer(flex: 10),
        ],
      ),
      bottomNavigationBar: AppNavigation(viewModel, VideoPage.routeName),
    );
  }
}

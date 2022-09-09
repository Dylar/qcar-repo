import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:qcar_customer/core/misc/helper/logger.dart';
import 'package:qcar_customer/core/misc/helper/player_config.dart';
import 'package:qcar_customer/core/service/services.dart';

import 'loading_overlay.dart';

const VIDEO_START = Duration(seconds: 0, minutes: 0, hours: 0);

//TODO make this anders...
bool isTest = false;

abstract class VideoWidgetViewModel {
  String get url;

  Future get isInitialized;

  void onVideoStart();

  void onVideoEnd();
}

class VideoWidget extends StatefulWidget {
  final VideoWidgetViewModel viewModel;

  VideoWidget({required this.viewModel});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  BetterPlayerController? controller;

  bool onStartTriggered = false;

  @override
  void dispose() {
    controller?.videoPlayerController?.removeListener(_checkVideo);
    controller?.videoPlayerController?.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isTest) {
      //TODO make this anders...
      return Container();
    }
    return FutureBuilder<void>(
        future: _initVideoWidget(),
        builder: (context, snapshot) {
          return snapshot.connectionState != ConnectionState.done
              ? VideoDownload()
              : Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.all(8.0),
                  child: BetterPlayer(controller: controller!),
                );
        });
  }

  Future _initVideoWidget() async {
    if (controller != null) {
      return;
    }

    await widget.viewModel.isInitialized;

    final settings = await Services.of(context)!.settingsService.getSettings();
    Logger.logI("Load video: ${widget.viewModel.url}");
    final config = playerConfigFromMap(settings.videos);
    controller = BetterPlayerController(
      config,
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.viewModel.url,
      ),
    )..videoPlayerController!.addListener(_checkVideo);
  }

  void _checkVideo() {
    if (controller == null ||
        !controller!.isVideoInitialized()! && !controller!.isPlaying()!) {
      return;
    }
    final playerValue = controller!.videoPlayerController!.value;
    final position = playerValue.position.inMicroseconds;
    if (!onStartTriggered && position <= VIDEO_START.inMicroseconds) {
      Logger.logI("onVideoStart");
      onStartTriggered = true;
      widget.viewModel.onVideoStart.call();
    }

    final endPosition = playerValue.duration?.inMicroseconds ?? 0;

    if (onStartTriggered && position >= endPosition) {
      Logger.logI("onVideoEnd");
      onStartTriggered = false;
      widget.viewModel.onVideoEnd.call();
    }
  }
}

class VideoDownload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      opacity: OPACITY_20,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.35,
        child: Center(child: Icon(Icons.cloud_download)),
      ),
    );
  }
}

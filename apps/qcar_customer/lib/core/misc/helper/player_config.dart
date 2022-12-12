import 'package:better_player/better_player.dart';
import 'package:qcar_shared/widgets/error_widget.dart';

BetterPlayerConfiguration playerConfigFromMap(Map<String, bool> map) {
  return BetterPlayerConfiguration(
    autoDispose: false,
    // aspectRatio: widget.aspectRatio,
    fullScreenByDefault: false,
    autoPlay: map["autoPlay"]!,
    looping: map["looping"]!,
    errorBuilder: (context, error) =>
        ErrorInfoWidget(error ?? "Unknown player error"),
    controlsConfiguration: BetterPlayerControlsConfiguration(
      showControls: map["showControlsOnInitialize"]!,
      showControlsOnInitialize: map["showControls"]!,
    ),
  );
}

Map<String, bool> initPlayerSettings() {
  final Map<String, bool> map = {};
  map["autoPlay"] = true;
  map["looping"] = false;
  map["showControlsOnInitialize"] = true;
  map["showControls"] = false;
  return map;
}

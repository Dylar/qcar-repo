import 'package:flutter/material.dart';
import 'package:qcar_customer/core/navigation/navi.dart';
import 'package:qcar_customer/models/video_info.dart';
import 'package:qcar_customer/ui/screens/video/video_page.dart';
import 'package:qcar_customer/ui/widgets/error_widget.dart';
import 'package:qcar_customer/ui/widgets/highlight_text.dart';

class VideoInfoListItem extends StatelessWidget {
  const VideoInfoListItem(this.video, {this.highlight = ""});

  final VideoInfo video;
  final String highlight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: CarInfoPic(video.picUrl),
              ),
              Spacer(flex: 5),
              Expanded(
                flex: 95,
                child: HighlightText(
                  text: video.name,
                  term: highlight,
                  textStyle: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () => Navigate.to(
        context,
        VideoPage.pushIt(video: video),
      ),
    );
  }
}

class CarInfoPic extends StatelessWidget {
  const CarInfoPic(this.url);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 80,
      child: Image.network(
        url,
        loadingBuilder: loadingWidget,
        errorBuilder: (
          BuildContext context,
          Object error,
          StackTrace? stackTrace,
        ) =>
            ErrorInfoWidget("Error"),
      ),
    );
  }

  Widget loadingWidget(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
            : null,
      ),
    );
  }
}

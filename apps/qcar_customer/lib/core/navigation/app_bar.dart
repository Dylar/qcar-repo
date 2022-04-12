import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_customer/models/video_info.dart';
import 'package:qcar_customer/service/car_info_service.dart';
import 'package:qcar_customer/service/services.dart';
import 'package:qcar_customer/ui/screens/video/video_list_item.dart';
import 'package:qcar_customer/ui/widgets/scroll_list_view.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  SearchAppBar(this.title, {Key? key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  final String title;

  @override
  _AppBarState createState() => _AppBarState();
}

class _AppBarState extends State<SearchAppBar> {
  @override
  Widget build(BuildContext context) {
    final service = Services.of(context)!.carInfoService;
    return AppBar(
      title: Text(widget.title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () async => await showSearch(
            context: context,
            delegate: VideoSearchDelegate(service),
          ),
        )
      ],
    );
  }
}

class VideoSearchDelegate extends SearchDelegate {
  VideoSearchDelegate(this.carService);

  final CarInfoService carService;

  @override
  List<Widget>? buildActions(BuildContext context) => <Widget>[];

  @override
  Widget? buildLeading(BuildContext context) =>
      BackButton(onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => _buildSearch(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearch(context);

  Widget _buildSearch(BuildContext context) => query.isEmpty
      ? _buildFullScreenText(
          context,
          AppLocalizations.of(context)!.searchStartText,
        )
      : _buildResult();

  Widget _buildFullScreenText(BuildContext context, String text) => Container(
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      );

  Widget _buildResult() => FutureBuilder<List<VideoInfo>>(
        future: _doSearch(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return ScrollListView<VideoInfo>(
            items: snapshot.data,
            emptyWidget: _buildFullScreenText(
              context,
              AppLocalizations.of(context)!.searchEmptyText,
            ),
            buildItemWidget: (int index, item) =>
                VideoInfoListItem(item, highlight: query),
          );
        },
      );

  Future<List<VideoInfo>> _doSearch() async => carService.searchVideo(query);
}

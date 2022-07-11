import 'package:flutter/material.dart';
import 'package:qcar_customer/core/app_theme.dart';
import 'package:qcar_customer/core/tracking.dart';
import 'package:qcar_customer/models/category_info.dart';
import 'package:qcar_customer/ui/widgets/error_builder.dart';

class CategoryListItem extends StatelessWidget {
  const CategoryListItem(this.category);

  final CategoryInfo category;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: Border.all(color: BaseColors.babyBlue),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: CarInfoPic(category.picUrl)),
          Spacer(flex: 5),
          Expanded(
            flex: 95,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${category.name}',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Divider(color: BaseColors.zergPurple),
                Text(
                  '${category.description}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CarInfoPic extends StatelessWidget {
  const CarInfoPic(this.url);

  final String url;

  @override
  Widget build(BuildContext context) {
    Logger.logI("Load pic: $url");
    return Container(
      width: 60,
      height: 80,
      child: Image.network(
        url,
        loadingBuilder: loadingWidget,
        errorBuilder: buildImageError,
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

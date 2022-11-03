import 'package:flutter/material.dart';
import 'package:qcar_business/core/models/category_info.dart';
import 'package:qcar_business/ui/app_theme.dart';
import 'package:qcar_business/ui/widgets/pic_widget.dart';
import 'package:qcar_business/ui/widgets/rounded_widget.dart';

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
          RoundedWidget(child: PicWidget(category.picUrl)),
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

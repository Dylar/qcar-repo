import 'package:flutter/material.dart';
import 'package:qcar_business/core/models/sell_info.dart';
import 'package:qcar_business/ui/widgets/pic_widget.dart';
import 'package:qcar_shared/widgets/deco.dart';
import 'package:qcar_shared/widgets/rounded_widget.dart';

class SellInfoListItem extends StatelessWidget {
  const SellInfoListItem(this.sell, {required this.onTap});

  final SellInfo sell;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: inkTap(
        onTap: onTap,
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(2.0),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RoundedWidget(
                    child:
                        PicWidget(sell.car.picUrl)), //PicWidget(video.picUrl)),
                Spacer(flex: 5),
                Expanded(
                  flex: 95,
                  child: Text(
                    sell.text,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

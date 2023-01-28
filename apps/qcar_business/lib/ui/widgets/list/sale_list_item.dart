import 'package:flutter/material.dart';
import 'package:qcar_business/core/models/sale_info.dart';
import 'package:qcar_business/ui/widgets/pic_widget.dart';
import 'package:qcar_shared/widgets/deco.dart';
import 'package:qcar_shared/widgets/rounded_widget.dart';

class SaleListItem extends StatelessWidget {
  const SaleListItem(this.sale, {this.onTap});

  final SaleInfo sale;
  final void Function()? onTap;

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
                Hero(
                  tag: sale.car.model,
                  child: RoundedWidget(child: PicWidget(sale.car.picUrl)),
                ),
                Spacer(flex: 5),
                Expanded(
                  flex: 95,
                  child: Text(
                    sale.text,
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

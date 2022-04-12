import 'package:flutter/material.dart';

class ScrollListView<T> extends StatelessWidget {
  ScrollListView({
    required this.items,
    required this.buildItemWidget,
    this.headerWidget,
    this.footerWidget,
    this.emptyWidget,
    this.hideScrollBar = false,
    EdgeInsets? padding,
    ScrollController? scrollController,
  })  : scrollController = scrollController ?? ScrollController(),
        padding = padding ?? const EdgeInsets.all(4.0);

  final ScrollController scrollController;

  final bool hideScrollBar;
  final EdgeInsets padding;
  final List<T>? items;
  final Widget? footerWidget, headerWidget, emptyWidget;
  final Widget Function(int index, T item) buildItemWidget;

  Widget get _loadingIndicator =>
      const Center(child: CircularProgressIndicator());

  int get itemCount =>
      (items?.length ?? 0) +
      (headerWidget == null ? 0 : 1) +
      (footerWidget == null ? 0 : 1);

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      return _loadingIndicator;
    }

    if (items!.isEmpty && emptyWidget != null) {
      return emptyWidget!;
    }

    return Scrollbar(
      isAlwaysShown: !hideScrollBar,
      controller: scrollController,
      child: Padding(
        padding: padding,
        child: ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            itemCount: itemCount,
            itemBuilder: (BuildContext context, int position) {
              if (headerWidget != null && position == 0) {
                return headerWidget!;
              }
              if (footerWidget != null && position == itemCount - 1) {
                return footerWidget!;
              } else {
                final itemPosition = position - (headerWidget != null ? 1 : 0);
                return buildItemWidget(itemPosition, items![itemPosition]);
              }
            }),
      ),
    );
  }
}

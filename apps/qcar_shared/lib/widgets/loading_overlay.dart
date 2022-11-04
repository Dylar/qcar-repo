import 'package:flutter/material.dart';
import 'package:qcar_shared/core/app_theme.dart';

const OPACITY_2 = .02;
const OPACITY_20 = .2;
const OPACITY_100 = 1.0;

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    this.backgroundColor = BaseColors.primary,
    this.opacity = OPACITY_100,
    this.child,
    this.loadingUnderChild = false,
  });

  final Color backgroundColor;
  final double opacity;
  final bool loadingUnderChild;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return loadingUnderChild ? _buildUnder() : _buildOver();
  }

  Widget _buildOver() {
    return Stack(
      children: [
        if (child != null) child!,
        Positioned.fill(
          child: Container(
            color: backgroundColor.withOpacity(opacity),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }

  Widget _buildUnder() {
    return Column(
      children: [
        if (child != null) Flexible(flex: 3, child: child!),
        Flexible(
          child: Container(
            alignment: Alignment.topCenter,
            color: backgroundColor.withOpacity(opacity),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
        // if (child != null) Container(child: child!),
      ],
    );
  }
}

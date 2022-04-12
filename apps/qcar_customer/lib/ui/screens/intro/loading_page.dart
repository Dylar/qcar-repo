import 'package:flutter/material.dart';
import 'package:qcar_customer/core/app_theme.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/ui/widgets/gradient_text.dart';

class LoadingStartPage extends StatelessWidget {
  const LoadingStartPage(this.progressValue);

  final ValueNotifier<Tuple<double, double>> progressValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              BaseColors.primary,
              BaseColors.accent,
            ],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(child: AppLoadingIndicator(progressValue)),
      ),
    );
  }
}

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator(this.progressValue);

  final ValueNotifier<Tuple<double, double>> progressValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(flex: 2),
        Flexible(
          flex: 3,
          child: GradientText(
            'qCar',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontWeight: FontWeight.w400),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  BaseColors.babyBlue,
                  BaseColors.zergPurple,
                ]),
          ),
        ),
        Spacer(flex: 1),
        Flexible(child: CircularProgressIndicator()),
        Spacer(flex: 1),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _buildLoadingProgress(),
          ),
        ),
        Spacer(flex: 1),
      ],
    );
  }

  Widget _buildLoadingProgress() {
    return ValueListenableBuilder<Tuple<double, double>>(
      valueListenable: progressValue,
      builder: (
        BuildContext context,
        Tuple<double, double> tuple,
        Widget? child,
      ) {
        final max = tuple.firstOrThrow;
        final progress = tuple.secondOrThrow;
        final value = progress == 0 ? 0.0 : progress / max;
        return LinearProgressIndicator(
          color: BaseColors.babyBlue,
          backgroundColor: BaseColors.zergPurple,
          value: value,
        );
      },
    );
  }
}

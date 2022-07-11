import 'package:flutter/material.dart';
import 'package:qcar_customer/core/app_theme.dart';
import 'package:qcar_customer/core/helper/tuple.dart';
import 'package:qcar_customer/ui/widgets/gradient_text.dart';

class LoadingStartPage extends StatelessWidget {
  const LoadingStartPage({this.progressValue});

  final ValueNotifier<Tuple<double, double>>? progressValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: qcarGradientBox,
        child: Center(
          child: AppLoadingIndicator(
            progressValue ?? ValueNotifier(Tuple(100.0, 1.0)),
          ),
        ),
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
          child: qcarGradientText(
            context,
            'qCar',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontWeight: FontWeight.w400),
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

BoxDecoration get qcarGradientBox => BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          BaseColors.primary,
          BaseColors.accent,
        ],
        tileMode: TileMode.clamp,
      ),
    );

GradientText qcarGradientText(
  BuildContext context,
  String text, {
  TextStyle? style,
}) {
  return GradientText(
    text,
    style: style,
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          BaseColors.babyBlue,
          BaseColors.zergPurple,
        ]),
  );
}

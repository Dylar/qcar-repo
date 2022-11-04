import 'package:flutter/material.dart';
import 'package:qcar_business/core/environment_config.dart';
import 'package:qcar_shared/core/app_theme.dart';
import 'package:qcar_shared/tuple.dart';
import 'package:qcar_shared/widgets/deco.dart';

class LoadingStartPage extends StatelessWidget {
  const LoadingStartPage({this.progressValue});

  final ValueNotifier<Tuple<double, double>>? progressValue;

  @override
  Widget build(BuildContext context) {
    final progress = progressValue ?? ValueNotifier(Tuple(100.0, 1.0));
    return SizedBox.expand(
      child: Container(
        decoration: qcarGradientBox,
        alignment: Alignment.center,
        child: AppLoadingIndicator(progress),
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
            EnvironmentConfig.APP_NAME,
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

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_customer/ui/notify/dialog.dart';
import 'package:qcar_shared/widgets/rounded_widget.dart';

abstract class FavoritesButtonViewModel {
  bool get hasFavorites;

  void naviToFavorites();
}

class FavoritesButton extends StatelessWidget {
  FavoritesButton(this.viewModel);

  final FavoritesButtonViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () {
        if (viewModel.hasFavorites) {
          viewModel.naviToFavorites();
        } else {
          openNoFavoritesDialog(context);
        }
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(2.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: RoundedWidget(child: Icon(Icons.star)),
            ),
            Spacer(flex: 5),
            Expanded(
              flex: 95,
              child: Text(
                l10n.favoritesButton,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

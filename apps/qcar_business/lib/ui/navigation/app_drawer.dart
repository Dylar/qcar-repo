import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_business/ui/screens/login/login_page.dart';
import 'package:qcar_business/ui/screens/settings/settings_page.dart';
import 'package:qcar_shared/core/app_navigate.dart';
import 'package:qcar_shared/widgets/deco.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            child: Center(
              child: qcarGradientText(
                context,
                l10n.drawerAppTitle,
                textScaling: 2.0,
              ),
            ),
          ),
          ListTile(
            title: Text(l10n.drawerLogout),
            onTap: () => Navigate.to(context, LoginPage.onLogout()),
          ),
          ListTile(
            title: Text(l10n.drawerSettings),
            onTap: () => Navigate.to(context, SettingsPage.pushIt()),
          ),
        ],
      ),
    );
  }
}

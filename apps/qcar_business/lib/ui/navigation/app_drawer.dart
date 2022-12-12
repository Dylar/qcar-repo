import 'package:flutter/material.dart';
import 'package:qcar_business/ui/notify/snackbars.dart';
import 'package:qcar_business/ui/screens/login/login_page.dart';
import 'package:qcar_shared/core/app_navigate.dart';
import 'package:qcar_shared/widgets/deco.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            child: Center(
              child: qcarGradientText(
                context,
                'QCar-Business',
                textScaling: 2.0,
              ),
            ),
          ),
          ListTile(
            title: const Text('Ausloggen'),
            onTap: () => Navigate.to(context, LoginPage.onLogout()),
          ),
          ListTile(
            title: const Text('Information'),
            onTap: () => showNothingToSeeSnackBar(context),
          ),
        ],
      ),
    );
  }
}

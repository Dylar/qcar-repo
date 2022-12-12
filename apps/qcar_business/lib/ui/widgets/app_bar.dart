import 'package:flutter/material.dart';
import 'package:qcar_business/core/misc/constants/asset_paths.dart';

AppBar buildAppBar(String title) {
  return AppBar(
    title: Row(
      children: [
        Expanded(child: Text(title)),
        SizedBox(
            height: 48,
            width: 48,
            //TODO load from car path
            child: Image.asset(homePageCarLogoImagePath)),
      ],
    ),
  );
}

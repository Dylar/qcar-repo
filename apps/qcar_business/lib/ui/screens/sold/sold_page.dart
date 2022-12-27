import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_business/core/models/model_data.dart';
import 'package:qcar_business/core/models/sell_info.dart';
import 'package:qcar_business/ui/screens/sold/sold_vm.dart';
import 'package:qcar_business/ui/widgets/app_bar.dart';
import 'package:qcar_business/ui/widgets/pic_widget.dart';
import 'package:qcar_shared/core/app_routing.dart';
import 'package:qcar_shared/core/app_theme.dart';
import 'package:qcar_shared/core/app_view.dart';
import 'package:qcar_shared/widgets/rounded_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SoldPage extends View<SoldViewModel> {
  static const String routeName = "/sold";

  static RoutingSpec pushIt(SellInfo item) => RoutingSpec(
        routeName: routeName,
        action: RouteAction.pushTo,
        transitionTime: const Duration(milliseconds: 200),
        transitionType: TransitionType.fading,
        args: {ARGS_SELL_INFO: item},
      );

  SoldPage(
    SoldViewModel viewModel, {
    Key? key,
  }) : super.model(viewModel, key: key);

  @override
  State<SoldPage> createState() => _SoldPageState(viewModel);
}

class _SoldPageState extends ViewState<SoldPage, SoldViewModel> {
  _SoldPageState(SoldViewModel viewModel) : super(viewModel);

  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: buildAppBar(l10n.soldTitle),
      body: HeaderWidget(child: _buildInfos),
    );
  }

  Widget _buildInfos(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final customer = viewModel.sellInfo.customer;
    return Scrollbar(
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Hero(
                tag: viewModel.sellInfo.car.model,
                child: RoundedWidget(
                    child: PicWidget(viewModel.sellInfo.car.picUrl)),
              ),
              SizedBox(height: 20),
              Text(
                customer.fullName,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  children: <Widget>[
                    Card(
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                ...ListTile.divideTiles(
                                  color: Colors.grey,
                                  tiles: [
                                    ListTile(
                                      leading: Icon(Icons.email),
                                      title: Text(l10n.customerEmail),
                                      subtitle: Text(customer.email),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.phone),
                                      title: Text(l10n.customerPhone),
                                      subtitle: Text(customer.phone),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.person),
                                      title: Text(l10n.customerBirthday),
                                      subtitle: Text(customer.birthday),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.person),
                                      title: Text(l10n.customerGender),
                                      subtitle: Text(customer.gender.name),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(32.0),
                color: BaseColors.veryLightGrey,
                child: QrImage(
                  data:
                      "https://google.gprivate.com/search.php?search?q=DickButt",
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({required this.child, Key? key}) : super(key: key);

  final Widget Function(BuildContext) child;

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  final double _height = 100;

  _HeaderWidgetState();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final primaryColor = BaseColors.babyBlue;
    final accentColor = BaseColors.zergPurple;
    return Stack(
      children: [
        ClipPath(
          child: Container(
            height: _height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.2),
                    accentColor.withOpacity(0.2),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          clipper: ShapeClipper([
            Offset(width / 5, _height),
            Offset(width / 10 * 5, _height - 60),
            Offset(width / 5 * 4, _height + 20),
            Offset(width, _height - 18)
          ]),
        ),
        ClipPath(
          child: Container(
            height: _height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.5),
                    accentColor.withOpacity(0.5),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          clipper: ShapeClipper([
            Offset(width / 3, _height + 20),
            Offset(width / 10 * 8, _height - 60),
            Offset(width / 5 * 4, _height - 60),
            Offset(width, _height - 20)
          ]),
        ),
        widget.child(context),
        ClipPath(
          child: Container(
            height: _height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(1),
                    accentColor.withOpacity(1),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          clipper: ShapeClipper([
            Offset(width / 5, _height),
            Offset(width / 2, _height - 40),
            Offset(width / 5 * 4, _height - 80),
            Offset(width, _height - 20)
          ]),
        ),
      ],
    );
  }
}

class ShapeClipper extends CustomClipper<Path> {
  List<Offset> _offsets = [];

  ShapeClipper(this._offsets);

  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0.0, size.height - 20);

    // path.quadraticBezierTo(size.width/5, size.height, size.width/2, size.height-40);
    // path.quadraticBezierTo(size.width/5*4, size.height-80, size.width, size.height-20);

    path.quadraticBezierTo(
        _offsets[0].dx, _offsets[0].dy, _offsets[1].dx, _offsets[1].dy);
    path.quadraticBezierTo(
        _offsets[2].dx, _offsets[2].dy, _offsets[3].dx, _offsets[3].dy);

    // path.lineTo(size.width, size.height-20);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

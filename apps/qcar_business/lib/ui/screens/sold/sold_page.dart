import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_business/core/models/model_data.dart';
import 'package:qcar_business/core/models/sell_info.dart';
import 'package:qcar_business/ui/screens/sold/car_detail_widget.dart';
import 'package:qcar_business/ui/screens/sold/customer_detail_widget.dart';
import 'package:qcar_business/ui/screens/sold/sold_vm.dart';
import 'package:qcar_business/ui/widgets/app_bar.dart';
import 'package:qcar_business/ui/widgets/pic_widget.dart';
import 'package:qcar_shared/core/app_routing.dart';
import 'package:qcar_shared/core/app_theme.dart';
import 'package:qcar_shared/core/app_view.dart';
import 'package:qcar_shared/widgets/deco.dart';
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

  @override
  Widget build(BuildContext context) {
    final title = AppLocalizations.of(context)!.homoPageTitle;
    return Scaffold(
      appBar: buildAppBar("Der Verkauf"),
      body: buildBla(),
    );
  }

  Widget buildSoldPage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: qcarGradientBox,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
            tag: viewModel.sellInfo.car.model,
            child: CarDetailWidget(viewModel.sellInfo.car),
          ),
          CustomerDetailWidget(viewModel.sellInfo.customer),
          Flexible(
            child: Container(
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
          ),
        ],
      ),
    );
  }

  Widget buildBla() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            height: 100,
            child: HeaderWidget(100, false, Icons.house_rounded),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 5, color: Colors.white),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                  child: Hero(
                    tag: viewModel.sellInfo.car.model,
                    child: RoundedWidget(
                        child: PicWidget(viewModel.sellInfo.car.picUrl)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Mr. Donald Trump',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Former President',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                        alignment: Alignment.topLeft,
                        child: Text(
                          "User Information",
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
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
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        leading: Icon(Icons.my_location),
                                        title: Text("Location"),
                                        subtitle: Text("USA"),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.email),
                                        title: Text("Email"),
                                        subtitle: Text("donaldtrump@gmail.com"),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.phone),
                                        title: Text("Phone"),
                                        subtitle: Text("99--99876-56"),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.person),
                                        title: Text("About Me"),
                                        subtitle: Text(
                                            "This is a about me link and you can khow about me in this section."),
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HeaderWidget extends StatefulWidget {
  final double _height;
  final bool _showIcon;
  final IconData _icon;

  const HeaderWidget(this._height, this._showIcon, this._icon, {Key? key})
      : super(key: key);

  @override
  _HeaderWidgetState createState() =>
      _HeaderWidgetState(_height, _showIcon, _icon);
}

class _HeaderWidgetState extends State<HeaderWidget> {
  double _height;
  bool _showIcon;
  IconData _icon;

  _HeaderWidgetState(this._height, this._showIcon, this._icon);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      child: Stack(
        children: [
          ClipPath(
            child: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.4),
                      Theme.of(context).accentColor.withOpacity(0.4),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            clipper: new ShapeClipper([
              Offset(width / 5, _height),
              Offset(width / 10 * 5, _height - 60),
              Offset(width / 5 * 4, _height + 20),
              Offset(width, _height - 18)
            ]),
          ),
          ClipPath(
            child: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.4),
                      Theme.of(context).accentColor.withOpacity(0.4),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            clipper: new ShapeClipper([
              Offset(width / 3, _height + 20),
              Offset(width / 10 * 8, _height - 60),
              Offset(width / 5 * 4, _height - 60),
              Offset(width, _height - 20)
            ]),
          ),
          ClipPath(
            child: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).accentColor,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            clipper: new ShapeClipper([
              Offset(width / 5, _height),
              Offset(width / 2, _height - 40),
              Offset(width / 5 * 4, _height - 80),
              Offset(width, _height - 20)
            ]),
          ),
          Visibility(
            visible: _showIcon,
            child: Container(
              height: _height - 40,
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.only(
                    left: 5.0,
                    top: 20.0,
                    right: 5.0,
                    bottom: 20.0,
                  ),
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(20),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                    border: Border.all(width: 5, color: Colors.white),
                  ),
                  child: Icon(
                    _icon,
                    color: Colors.white,
                    size: 40.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShapeClipper extends CustomClipper<Path> {
  List<Offset> _offsets = [];

  ShapeClipper(this._offsets);

  @override
  Path getClip(Size size) {
    var path = new Path();

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

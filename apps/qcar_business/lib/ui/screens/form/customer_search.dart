import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_business/core/models/customer_info.dart';
import 'package:qcar_business/core/service/info_service.dart';
import 'package:qcar_business/ui/widgets/list/customer_list_item.dart';
import 'package:qcar_shared/core/app_navigate.dart';
import 'package:qcar_shared/widgets/scroll_list_view.dart';

class CustomerSearchDelegate extends SearchDelegate<CustomerInfo?> {
  CustomerSearchDelegate(this.infoService);

  final InfoService infoService;

  @override
  List<Widget>? buildActions(BuildContext context) => <Widget>[];

  @override
  Widget? buildLeading(BuildContext context) =>
      BackButton(onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => _buildSearch(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearch(context);

  Widget _buildSearch(BuildContext context) => query.isEmpty
      ? _buildFullScreenText(
          context,
          AppLocalizations.of(context)!.searchStartText,
        )
      : _buildResult();

  Widget _buildFullScreenText(BuildContext context, String text) => Container(
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      );

  Widget _buildResult() => FutureBuilder<List<CustomerInfo>>(
        future: _doSearch(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          final l10n = AppLocalizations.of(context)!;
          return ScrollListView<CustomerInfo>(
            items: snapshot.data,
            emptyWidget: _buildFullScreenText(
              context,
              l10n.searchStartText,
            ),
            buildItemWidget: (int index, item) => CustomerListItem(
              item,
              onTap: () => Navigate.pop(context, item),
            ),
          );
        },
      );

  Future<List<CustomerInfo>> _doSearch() async =>
      infoService.searchCustomer(query);
}

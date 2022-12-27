import 'package:flutter/material.dart';
import 'package:qcar_business/core/models/customer_info.dart';
import 'package:qcar_shared/widgets/deco.dart';

class CustomerListItem extends StatelessWidget {
  const CustomerListItem(this.customer, {required this.onTap});

  final CustomerInfo customer;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: inkTap(
        onTap: onTap,
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(2.0),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: ${customer.fullName} ',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text('Email: ${customer.email}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

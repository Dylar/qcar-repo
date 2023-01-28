import 'package:flutter/material.dart';
import 'package:qcar_business/core/models/customer_info.dart';
import 'package:qcar_shared/widgets/rounded_widget.dart';

class CustomerDetailWidget extends StatelessWidget {
  CustomerDetailWidget(this.customer);

  final CustomerInfo customer;

  @override
  Widget build(BuildContext context) {
    return RoundedWidget(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(customer.name),
          Text(customer.lastName),
          Text(customer.email),
        ],
      ),
    );
  }
}

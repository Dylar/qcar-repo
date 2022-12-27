import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qcar_business/core/models/customer_info.dart';
import 'package:qcar_business/core/models/model_data.dart';
import 'package:qcar_business/core/service/services.dart';
import 'package:qcar_business/ui/screens/form/customer_search.dart';
import 'package:qcar_business/ui/screens/form/form_vm.dart';
import 'package:qcar_business/ui/widgets/app_bar.dart';
import 'package:qcar_shared/core/app_routing.dart';
import 'package:qcar_shared/core/app_theme.dart';
import 'package:qcar_shared/core/app_view.dart';
import 'package:qcar_shared/utils/time_utils.dart';
import 'package:qcar_shared/widgets/rounded_widget.dart';

class FormCustomerPage extends View<FormViewModel> {
  static const String routeName = "/formCustomer";

  static RoutingSpec pushIt(FormViewModel viewModel) => RoutingSpec(
        routeName: routeName,
        action: RouteAction.pushTo,
        transitionTime: const Duration(milliseconds: 200),
        transitionType: TransitionType.rightLeft,
        args: {ARGS_VIEW_MODEL: viewModel},
      );

  FormCustomerPage(
    FormViewModel viewModel, {
    Key? key,
  }) : super.model(viewModel, key: key);

  @override
  State<FormCustomerPage> createState() => _FormCustomerPageState(viewModel);
}

class _FormCustomerPageState
    extends ViewState<FormCustomerPage, FormViewModel> {
  _FormCustomerPageState(FormViewModel viewModel) : super(viewModel);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  Gender selectedGender = Gender.DIVERS;
  DateTime? selectedBirthday;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2001, 9, 11),
        firstDate: DateTime(1900, 1, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedBirthday) {
      setState(() => selectedBirthday = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: buildAppBar("Kunde"),
      body: buildFormPage(context),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _selectCustomer(context),
            _saveButton(),
          ],
        ),
      ),
    );
  }

  Widget _selectCustomer(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final customer = await showSearch<CustomerInfo?>(
          context: context,
          delegate: CustomerSearchDelegate(Services.of(context)!.infoService),
        );
        if (customer != null) {
          setState(() {
            nameController.text = customer.name;
            lastNameController.text = customer.lastName;
            emailController.text = customer.email;
            phoneController.text = customer.phone;
            selectedBirthday = parseDate(customer.birthday);
            selectedGender = customer.gender;
          });
        }
      },
      child: Text("Kunde auswählen"),
    );
  }

  Widget _saveButton() {
    return ElevatedButton(
      onPressed: () {
        final customer = CustomerInfo(
          name: nameController.text,
          lastName: lastNameController.text,
          gender: selectedGender,
          birthday:
              selectedBirthday == null ? "" : formatDate(selectedBirthday!),
          email: emailController.text,
          phone: phoneController.text,
        );
        viewModel.saveSellInfo(customer);
      },
      child: Text("Speichern"),
    );
  }

  Widget buildFormPage(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...[
              buildTextField(nameController, Icons.person, "Name"),
              buildTextField(lastNameController, null, "Familienname"),
              buildTextField(emailController, Icons.email, "Email"),
              buildTextField(phoneController, Icons.phone, "Telefon"),
            ].map((child) => Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                  child: child,
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundedWidget(
                      color: viewModel.validateError && selectedBirthday == null
                          ? BaseColors.red
                          : null,
                      child: Row(
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            child: Icon(
                              Icons.date_range,
                              color: Colors.white70,
                              size: 22,
                            ),
                          ),
                          selectedBirthday != null
                              ? Text(formatBirthday(selectedBirthday!))
                              : Text("Geburstag auswählen"),
                        ],
                      ),
                    ),
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _genderButton(Gender.MALE, "Mann"),
                _genderButton(Gender.FEMALE, "Frau"),
                _genderButton(Gender.DIVERS, "Freak"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextField buildTextField(
      TextEditingController controller, IconData? icon, String hint) {
    return TextField(
      controller: controller,
      keyboardType: controller == emailController
          ? TextInputType.emailAddress
          : controller == phoneController
              ? TextInputType.phone
              : TextInputType.name,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        errorStyle: TextStyle(height: 0),
        errorText:
            viewModel.validateError && controller.text.isEmpty ? "" : null,
        prefixIconConstraints: BoxConstraints(minWidth: 45),
        prefixIcon: Icon(
          icon,
          color: Colors.white70,
          size: 22,
        ),
        labelText: hint,
      ),
    );
  }

  Widget _genderButton(Gender gender, String label) {
    return GestureDetector(
      onTap: () => setState(() => selectedGender = gender),
      child: RoundedWidget(
        child: Row(
          children: [
            Radio<Gender>(
              value: gender,
              groupValue: selectedGender,
              onChanged: (Gender? value) =>
                  setState(() => selectedGender = value!),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(label),
            )
          ],
        ),
      ),
    );
  }
}

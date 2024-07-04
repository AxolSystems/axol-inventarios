import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/providers.dart';
import '../../../user/model/user_model.dart';
import '../model/customer_model.dart';

class CustomerDrawerDetails extends StatelessWidget {
  final CustomerModel customer;
  final UserModel user;

  const CustomerDrawerDetails(
      {super.key, required this.customer, required this.user});

  @override
  Widget build(BuildContext context) {
    final bool editable;

    if (user.rol == UserModel.rolAdmin) {
      editable = true;
    } else {
      editable = false;
    }

    return DrawerBox(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      header: const Text(
        'Cliente',
        style: Typo.subtitleDark,
      ),
      actions: [
        SecondaryButtonDialog(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Visibility(
          visible: editable,
          child: AlertButtonDialog(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) =>
                    ProviderCustomerDelete(customer: customer),
              );
            },
          ),
        ),
      ],
      children: [
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                'Id: ',
                style: Typo.bodyDark,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                customer.id.toString(),
                style: Typo.bodyDark,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                'Nombre: ',
                style: Typo.bodyDark,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                customer.name,
                style: Typo.bodyDark,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                'Telefono: ',
                style: Typo.bodyDark,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                customer.phoneNumber ?? '',
                style: Typo.bodyDark,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                'RFC: ',
                style: Typo.bodyDark,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                customer.rfc ?? '',
                style: Typo.bodyDark,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                'Código postal: ',
                style: Typo.bodyDark,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                customer.postalCode ?? '',
                style: Typo.bodyDark,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                'Número interno: ',
                style: Typo.bodyDark,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                customer.intNumber ?? '',
                style: Typo.bodyDark,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                'Número externo: ',
                style: Typo.bodyDark,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                customer.outNumber ?? '',
                style: Typo.bodyDark,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                'Calle: ',
                style: Typo.bodyDark,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                customer.street ?? '',
                style: Typo.bodyDark,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                'Colonia: ',
                style: Typo.bodyDark,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                customer.hood ?? '',
                style: Typo.bodyDark,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                'Ciudad: ',
                style: Typo.bodyDark,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                customer.town ?? '',
                style: Typo.bodyDark,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                'Estado: ',
                style: Typo.bodyDark,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                customer.country ?? '',
                style: Typo.bodyDark,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/providers.dart';
import '../model/vendor_model.dart';

class VendorDrawerDetails extends StatelessWidget {
  final VendorModel vendor;

  const VendorDrawerDetails({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) {
    return DrawerBox(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      header: const Text(
        'Vendedor',
        style: Typo.subtitleDark,
      ),
      actions: [
        SecondaryButtonDialog(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        AlertButtonDialog(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ProviderVendorDelete(vendor: vendor),
            );
          },
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
                vendor.id.toString(),
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
                vendor.name,
                style: Typo.bodyDark,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../../models/textfield_model.dart';
import '../../../../../../utilities/theme/theme.dart';
import '../../../../../sale/vendor/model/vendor_model.dart';
import 'finder_vendor.dart';

class DrawerSelectVendor extends StatelessWidget {
  final bool isLoading;
  final List<VendorModel> listData;
  final TextfieldModel finder;

  const DrawerSelectVendor({
    super.key,
    required this.isLoading,
    required this.listData,
    required this.finder,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          color: Colors.black26,
        )),
        Drawer(
          width: 400,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      const Center(
                        child: Text('Vendedores'),
                      ),
                      FinderVendor(
                        currentFinder: finder,
                        isLoading: isLoading,
                      ),
                      Visibility(
                          visible: isLoading,
                          child: const LinearProgressIndicator()),
                      Visibility(
                          visible: !isLoading,
                          child: const SizedBox(
                            height: 5,
                          )),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Center(
                                child: Text(
                              'Id',
                            )),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                                child: Text(
                              'Nombre',
                            )),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: listData.length,
                          itemBuilder: (context, index) {
                            final vendorRow = listData[index];
                            return OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context, vendorRow.name);
                              },
                              child: Container(
                                height: 30,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.black12),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      //1) ID
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          vendorRow.id.toString(),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      // 2) Nombre
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          vendorRow.name,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text('Cancelar'),
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
      ],
    );
  }
}

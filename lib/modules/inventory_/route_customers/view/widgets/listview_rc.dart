import 'package:axol_inventarios/modules/inventory_/route_customers/cubit/rc_details_cubit/rc_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/textfield_model.dart';
import '../../../../../utilities/theme/theme.dart';
import '../../cubit/routcustomer cubit/routcustomer_cubit.dart';
import '../../model/routcustomer_model.dart';
import '../controller/drawer_details_rc_controller.dart';
import 'finder_rc.dart';
import 'toolbar_rc.dart';

class ListviewRc extends StatelessWidget {
  final List<RoutcustomerModel> listData;
  final TextfieldModel finder;

  const ListviewRc({super.key, required this.finder, required this.listData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              FinderRc(
                currentFinder: finder,
                isLoading: false,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(
                      'Id',
                      style: Typo.bodyText5,
                    )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                        child: Text(
                      'Nombre',
                      style: Typo.bodyText5,
                    )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                        child: Text(
                      'Ubicación',
                      style: Typo.bodyText5,
                    )),
                  ),
                  Expanded(
                    flex: 4,
                    child: Center(
                        child: Text(
                      'Direción',
                      style: Typo.bodyText5,
                    )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                        child: Text(
                      'Vendedor',
                      style: Typo.bodyText5,
                    )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(
                      'Estado',
                      style: Typo.bodyText5,
                    )),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: listData.length,
                  itemBuilder: (context, index) {
                    final rcRow = listData[index];

                    return Container(
                      height: 30,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45)),
                      child: OutlinedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider(create: (_) => RcDetailsCubit()),
                                ],
                                child: DrawerDetailsRcController(
                                  rc: rcRow,
                                )),
                          ).then((value) {
                            if (value == true) {
                              context
                                  .read<RoutcustomerCubit>()
                                  .load(TextfieldModel.empty());
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Expanded(
                              //1) ID
                              flex: 1,
                              child: Center(
                                child: Text(
                                  rcRow.id.toString(),
                                  style: Typo.labelText1,
                                ),
                              ),
                            ),
                            Expanded(
                              // 2) Nombre
                              flex: 2,
                              child: Center(
                                child: Text(
                                  rcRow.name,
                                  style: Typo.labelText1,
                                ),
                              ),
                            ),
                            Expanded(
                              // 3) Ubicación
                              flex: 2,
                              child: Center(
                                child: Text(
                                  rcRow.location,
                                  style: Typo.labelText1,
                                ),
                              ),
                            ),
                            Expanded(
                              // 4) Dirección
                              flex: 4,
                              child: Center(
                                child: Text(
                                  '${rcRow.address[RoutcustomerModel.pAddress]}, ${rcRow.address[RoutcustomerModel.pHood]}, ${rcRow.address[RoutcustomerModel.pTown]}, ${rcRow.address[RoutcustomerModel.pCountry]}',
                                  style: Typo.labelText1,
                                ),
                              ),
                            ),
                            Expanded(
                              // 5) Vendedor
                              flex: 2,
                              child: Center(
                                child: Text(
                                  rcRow.vendor.toString(),
                                  style: Typo.labelText1,
                                ),
                              ),
                            ),
                            Expanded(
                              // 6) Estado
                              flex: 1,
                              child: Center(
                                  child: rcRow.validation[
                                              RoutcustomerModel.pStatus] ==
                                          true
                                      ? const Icon(
                                          Icons.check_box_outlined,
                                          color: ColorPalette.primary,
                                        )
                                      : const Icon(
                                          Icons
                                              .check_box_outline_blank_outlined,
                                          color: ColorPalette.primary,
                                        )),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const ToolbarRc(
          isLoading: false,
        ),
      ],
    );
  }
}

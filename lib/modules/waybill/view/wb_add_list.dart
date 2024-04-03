import 'package:axol_inventarios/modules/waybill/view/wb_add_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../global_widgets/appbar/iconbutton_return.dart';
import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../utilities/widgets/appbar_axol.dart';
import '../../../utilities/widgets/button.dart';
import '../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../../inventory_/inventory/model/warehouse_model.dart';
import '../cubit/wb_add/wb_add_cubit.dart';
import '../cubit/wb_add/wb_add_state.dart';
import '../model/wb_add_form_model.dart';

class WbAddList extends StatelessWidget {
  final WarehouseModel warehouse;
  const WbAddList({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WbAddCubit()),
        BlocProvider(create: (_) => WbAddForm()),
      ],
      child: WbAddListBuild(
        warehouse: warehouse,
      ),
    );
  }
}

class WbAddListBuild extends StatelessWidget {
  final WarehouseModel warehouse;
  const WbAddListBuild({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    WbAddFormModel form = context.read<WbAddForm>().state;
    return BlocConsumer<WbAddCubit, WbAddState>(
      bloc: context.read<WbAddCubit>()..initLoad(warehouse, form),
      builder: (context, state) {
        if (state is LoadingWbAddState) {
          return wbAdd(context, true, form);
        } else if (state is LoadedWbAddState) {
          return wbAdd(context, false, form);
        } else {
          return wbAdd(context, false, form);
        }
      },
      listener: (context, state) {
        if (state is ErrorWbAddState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                    text: state.error,
                  ));
        }
      },
    );
  }

  Widget wbAdd(BuildContext context, bool isLoading, WbAddFormModel form) {
    return Scaffold(
      backgroundColor: ColorPalette.darkBackground,
      appBar: AppBarAxol(
        title: 'Nueva lista para carta parte',
        isLoading: isLoading,
        iconButton: const IconButtonReturn(iconName: 'return'),
      ).appBarAxol(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Visibility(
            visible: !isLoading,
            replacement: const Expanded(child: SizedBox()),
            child: Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: form.waybillList.length,
                itemBuilder: (context, index) {
                  final waybill = form.waybillList[index];
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: ColorPalette.darkItems),
                      ),
                    ),
                    child: ButtonRowTable(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            waybill.product.code,
                            style: Typo.subtitleLight,
                          ),
                          const Icon(
                            Icons.navigate_next,
                            color: ColorPalette.lightBackground,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: ColorPalette.lightItems10),
                        ),
                        onPressed: () {},
                        child: const Icon(
                          Icons.save,
                          color: ColorPalette.lightItems10,
                          size: 26,
                        )),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: ColorPalette.primary,
                        side: const BorderSide(
                          color: ColorPalette.primary,
                          width: 1,
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12))
                          ),
                          context: context,
                          builder: (context) => const WbAddBottomSheet(),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.add,
                              color: ColorPalette.lightBackground,
                              size: 30,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Agregar',
                              style: Typo.mobileLigth20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

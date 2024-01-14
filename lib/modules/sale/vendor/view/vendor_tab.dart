import 'package:axol_inventarios/utilities/widgets/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/textfield_model.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/finder_bar.dart';
import '../../../../utilities/widgets/progress_indicator.dart';
import '../cubit/vendor_tab/vendor_tab_cubit.dart';
import '../cubit/vendor_tab/vendor_tab_form.dart';
import '../cubit/vendor_tab/vendor_tab_state.dart';
import '../model/vendor_model.dart';
import 'vendor_drawer_details.dart';
import 'vendor_drawer_add.dart';

class VendorTab extends StatelessWidget {
  const VendorTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VendorTabCubit, VendorTabState>(
      bloc: context.read<VendorTabCubit>()..load(''),
      listener: (context, state) {
        if (state is ErrorVendorTabState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(text: state.error));
        }
      },
      builder: (context, state) {
        if (state is LoadingVendorTabState) {
          return vendorTab(context, [], true);
        } else if (state is LoadedVendorTabState) {
          return vendorTab(context, state.vendorList, false);
        } else {
          return vendorTab(context, [], false);
        }
      },
    );
  }

  Widget vendorTab(
      BuildContext context, List<VendorModel> vendorList, bool isLoading) {
    TextfieldModel form = context.read<VendorTabForm>().state;
    TextfieldModel upForm;
    TextEditingController textController = TextEditingController();
    textController.value = TextEditingValue(
        text: form.text,
        selection: TextSelection.collapsed(offset: form.position));
    return Column(
      children: [
        Container(
          height: 50,
          color: ColorPalette.lightBackground,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: FinderBar(
                  padding: const EdgeInsets.only(left: 12),
                  textController: textController,
                  txtForm: form,
                  enabled: !isLoading,
                  autoFocus: true,
                  isTxtExpand: true,
                  onSubmitted: (value) {
                    context.read<VendorTabCubit>().load(value);
                  },
                  onChanged: (value) {
                    upForm = TextfieldModel(
                        text: value,
                        position: textController.selection.base.offset);
                    context.read<VendorTabForm>().setForm(upForm);
                  },
                  onPressed: () {
                    if (isLoading == false) {
                      context
                          .read<VendorTabForm>()
                          .setForm(TextfieldModel.empty());
                      context.read<VendorTabCubit>().load('');
                    }
                  },
                ),
              ),
              const VerticalDivider(
                thickness: 1,
                width: 1,
                color: ColorPalette.lightItems,
                indent: 4,
                endIndent: 4,
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        const ProviderVendorAdd(), //Sustituir por ProviderVendorAdd
                  ).then((value) {
                    context.read<VendorTabCubit>().load(form.text);
                  });
                },
                icon: const Icon(
                  Icons.add_outlined,
                  color: ColorPalette.darkItems,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecorationTheme.headerTable(),
          child: const Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'Id',
                      style: Typo.subtitleLight,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    'Nombre',
                    style: Typo.subtitleLight,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: isLoading
              ? const Column(
                  children: [
                    LinearProgressIndicatorAxol(),
                    Expanded(child: SizedBox())
                  ],
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: vendorList.length,
                  itemBuilder: (context, index) {
                    final vendor = vendorList[index];
                    return Container(
                      decoration: BoxDecorationTheme.rowTable(),
                      child: ButtonRowTable(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  vendor.id.toString(),
                                  style: Typo.bodyLight,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                vendor.name.toString(),
                                style: Typo.bodyLight,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => VendorDrawerDetails(
                                    vendor: vendor,
                                  )).then((value) {
                            context.read<VendorTabCubit>().load(form.text);
                          });
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

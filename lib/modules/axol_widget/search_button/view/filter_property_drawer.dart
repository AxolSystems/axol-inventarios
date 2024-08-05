import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:axol_inventarios/modules/axol_widget/search_button/cubit/filter_property/filter_property_cubit.dart';
import 'package:axol_inventarios/utilities/widgets/buttons/button.dart';
import 'package:axol_inventarios/utilities/widgets/dialog.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/textfield.dart';
import '../cubit/filter_property/filter_property_state.dart';
import '../model/filter_property_form_model.dart';

class FilterPropDrawer extends AxolWidget {
  final List<PropChecked> propCheckedList;
  const FilterPropDrawer({
    super.key,
    super.theme,
    required this.propCheckedList,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FilterPropCubit()),
        BlocProvider(create: (context) => FilterPropForm()),
      ],
      child: FilterPropDrawerBuild(
        theme: theme,
        propCheckedList: propCheckedList,
      ),
    );
  }
}

class FilterPropDrawerBuild extends AxolWidget {
  final List<PropChecked> propCheckedList;
  const FilterPropDrawerBuild({
    super.key,
    super.theme,
    required this.propCheckedList,
  });

  @override
  Widget build(BuildContext context) {
    final int theme_ = theme ?? 0;
    final FilterPropFormModel form = context.read<FilterPropForm>().state;
    return BlocConsumer<FilterPropCubit, FilterPropState>(
      bloc: context.read<FilterPropCubit>()..initLoad(form, propCheckedList),
      listener: (context, state) {
        if (state is ErrorFilterPropState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialogAxol(text: state.error),
          );
        }
      },
      builder: (context, state) => DrawerBox(
        theme: theme,
        header: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(color: ColorTheme.item30(theme_)),
                    )),
                    child: Text(
                      'Propiedades a mostrar',
                      style: Typo.titleH2(theme_),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: PrimaryTextField(
                    controller: form.finderController,
                    theme: theme_,
                    margin: const EdgeInsets.all(12),
                    prefixIcon: Icon(
                      Icons.search,
                      color: ColorTheme.item10(theme_),
                    ),
                    onChanged: (value) {
                      context.read<FilterPropCubit>().find(form);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          PrimaryButton(
            theme: theme,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            text: 'Aplicar',
            onPressed: () {
              Navigator.pop(context, form.propCheckedList);
            },
          )
        ],
        child: Expanded(
            child: ListView.builder(
          itemCount: form.propCheckedView.length,
          itemBuilder: (context, index) {
            final PropChecked propChecked = form.propCheckedView[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Checkbox(
                    activeColor: ColorTheme.item20(theme_),
                    side:
                        BorderSide(color: ColorTheme.item20(theme_), width: 2),
                    value: propChecked.checked,
                    onChanged: (value) {
                      context.read<FilterPropCubit>().check(form, index, value);
                    },
                  ),
                  Text(
                    propChecked.property.name,
                    style: Typo.body(theme_),
                  ),
                ],
              ),
            );
          },
        )),
      ),
    );
  }
}

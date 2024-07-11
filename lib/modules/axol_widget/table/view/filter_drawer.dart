import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:axol_inventarios/utilities/widgets/dialog.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../block/model/property_model.dart';
import '../cubit/filter/filter_cubit.dart';
import '../cubit/filter/filter_state.dart';
import '../model/filter_form_model.dart';

class FilterDrawer extends AxolWidget {
  const FilterDrawer({super.key, super.theme});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FilterCubit()),
        BlocProvider(create: (_) => FilterForm())
      ],
      child: FilterDrawerBuild(
        theme: theme,
      ),
    );
  }
}

class FilterDrawerBuild extends AxolWidget {
  const FilterDrawerBuild({super.key, super.theme});

  @override
  Widget build(BuildContext context) {
    final int theme_ = theme ?? 0;
    final FilterFormModel form = context.read<FilterForm>().state;
    return BlocConsumer<FilterCubit, FilterState>(
      bloc: context.read<FilterCubit>()..initLoad(form),
      listener: (context, state) {
        if (state is ErrorFilterState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(text: state.error));
        }
      },
      builder: (context, state) {
        return DrawerBox(
          header: Row(
            children: [
              Expanded(
                  child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: ColorTheme.item30(theme_))),
                ),
                child: Text(
                  'Filtros',
                  style: Typo.titleH2(theme_),
                  textAlign: TextAlign.center,
                ),
              ))
            ],
          ),
          child: Expanded(
              child: ListView.builder(
            itemCount: form.filterList.length,
            itemBuilder: (context, index) {
              final FilterModel filter = form.filterList[index];
              if (filter is AddFilterModel) {
                return addFilter();
              } else {
                return const SizedBox();
              }
            },
          )),
        );
      },
    );
  }

  Widget addFilter() {
    final int theme_ = theme ?? 0;
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: ColorTheme.item30(theme_)),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(side: BorderSide.none),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Agregar filtro',
                style: Typo.body(theme_),
              ),
              Icon(
                Icons.add,
                color: ColorTheme.text(theme_),
              )
            ],
          )),
    );
  }

  Widget textFilter(BuildContext context, FilterFormModel form, int index) {
    final int theme_ = theme ?? 0;
    final TextFilterModel filter = form.filterList[index] as TextFilterModel;
    String valueDrop = filter.value;
    List<DropdownMenuItem<String>> items = [];

    for (PropertyModel prop in form.block.propertyList) {
      items.add(DropdownMenuItem(
        value: prop.key,
        child: Text(
          prop.name,
          style: Typo.body(theme_),
        ),
      ));
    }

    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: ColorTheme.item30(theme_)),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(side: BorderSide.none),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField(
              value: valueDrop,
              items: items,
              onChanged: (value) {
                if (value != null) {
                  form.filterList[index] = TextFilterModel(
                      ctrlValue: filter.ctrlValue, value: value);
                  context.read<FilterCubit>().load();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

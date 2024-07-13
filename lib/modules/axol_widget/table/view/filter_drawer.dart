import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:axol_inventarios/modules/block/model/block_model.dart';
import 'package:axol_inventarios/utilities/widgets/dialog.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/dropdown_button.dart';
import '../../../block/model/property_model.dart';
import '../cubit/filter/filter_cubit.dart';
import '../cubit/filter/filter_state.dart';
import '../model/filter_form_model.dart';

class FilterDrawer extends AxolWidget {
  final BlockModel block;
  const FilterDrawer({super.key, super.theme, required this.block});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FilterCubit()),
        BlocProvider(create: (_) => FilterForm())
      ],
      child: FilterDrawerBuild(
        theme: theme,
        block: block,
      ),
    );
  }
}

class FilterDrawerBuild extends AxolWidget {
  final BlockModel block;
  const FilterDrawerBuild({super.key, super.theme, required this.block});

  @override
  Widget build(BuildContext context) {
    final int theme_ = theme ?? 0;
    final FilterFormModel form = context.read<FilterForm>().state;
    return BlocConsumer<FilterCubit, FilterState>(
      bloc: context.read<FilterCubit>()..initLoad(form, block),
      listener: (context, state) {
        if (state is ErrorFilterState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(text: state.error));
        }
      },
      builder: (context, state) {
        return DrawerBox(
          theme: theme_,
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
                ),
              ),
            ],
          ),
          child: Expanded(
              child: ListView.builder(
            itemCount: form.filterList.length,
            itemBuilder: (context, index) {
              final FilterModel filter = form.filterList[index];
              if (filter is AddFilterModel) {
                return addFilter(context, form);
              } else {
                return filterWidget(context, state, form, index);
              }
            },
          )),
        );
      },
    );
  }

  Widget addFilter(BuildContext context, FilterFormModel form) {
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
          onPressed: () {
            context.read<FilterCubit>().add(form);
          },
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

  Widget filterWidget(BuildContext context, FilterState state,
      FilterFormModel form, int index) {
    final int theme_ = theme ?? 0;
    List<DropdownMenuItem<String>> items = [];
    Widget widget = const SizedBox();

    for (PropertyModel prop in form.block.propertyList) {
      items.add(DropdownMenuItem(
        value: prop.key,
        child: Text(
          prop.name,
          style: Typo.body(theme_),
          overflow: TextOverflow.ellipsis,
        ),
      ));
    }

    if (state is EmptyFilterModel) {
      const SizedBox(width: 100);
    }

    return Container(
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: ColorTheme.item30(theme_)),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) => Row(
            children: [
              PrimaryDropDownButton(
                theme: theme_,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: (constraints.minWidth - 16) / 2,
                value: form.filterList[index].value,
                items: items,
                onChanged: (value) {
                  if (value != null) {
                    form.filterList[index].value = value;
                  }
                },
              ),
              /*SizedBox(
            width: 100,
            child: DropdownButtonFormField(
              isExpanded: true,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: ColorTheme.fill(theme ?? 0),
                contentPadding: const EdgeInsets.all(12),
                enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    borderSide:
                        BorderSide(color: ColorTheme.item20(theme ?? 0))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide:
                        BorderSide(color: ColorTheme.item10(theme ?? 0))),
              ),
              dropdownColor: ColorTheme.background(theme ?? 0),
              value: form.filterList[index].value,
              items: items,
              onChanged: (value) {
                if (value != null) {
                  form.filterList[index].value = value;
                }
              },
            ),
          ),*/
            ],
          ),
        ));
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

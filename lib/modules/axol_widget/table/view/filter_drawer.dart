import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:axol_inventarios/modules/object/model/filter_obj_model.dart';
import 'package:axol_inventarios/utilities/widgets/dialog.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/format.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/dropdown_button.dart';
import '../../../../utilities/widgets/textfield.dart';
import '../../../entity/model/entity_model.dart';
import '../../../entity/model/property_model.dart';
import '../cubit/filter/filter_cubit.dart';
import '../cubit/filter/filter_state.dart';
import '../model/filter_form_model.dart';

class FilterDrawer extends AxolWidget {
  final EntityModel entity;
  final List<FilterObjModel> filters;
  const FilterDrawer({
    super.key,
    super.theme,
    required this.entity,
    required this.filters,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FilterCubit()),
        BlocProvider(create: (_) => FilterForm())
      ],
      child: FilterDrawerBuild(
        theme: theme,
        entity: entity,
        filters: filters,
      ),
    );
  }
}

class FilterDrawerBuild extends AxolWidget {
  final EntityModel entity;
  final List<FilterObjModel> filters;
  const FilterDrawerBuild(
      {super.key, super.theme, required this.entity, required this.filters});

  @override
  Widget build(BuildContext context) {
    final int theme_ = theme ?? 0;
    final FilterFormModel form = context.read<FilterForm>().state;
    return BlocConsumer<FilterCubit, FilterState>(
      bloc: context.read<FilterCubit>()..initLoad(form, entity, filters),
      listener: (context, state) {
        if (state is ErrorFilterState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                    text: state.error,
                    theme: theme_,
                  ));
        }
        if (state is ApplyFilterState) {
          Navigator.pop(context, state.filters);
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
          actions: [
            SecondaryButton(
              theme: theme_,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              text: 'Regresar',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            PrimaryButton(
              //isLoading: state is SavingRowDetailsState,
              theme: theme_,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              text: 'Aplicar',
              onPressed: () {
                context.read<FilterCubit>().apply(form);
              },
            ),
          ],
          child: Expanded(
              child: ListView.builder(
            itemCount: form.filterList.length,
            itemBuilder: (context, index) {
              final FilterModel filter = form.filterList[index];
              if (filter is AddFilterModel) {
                return addFilter(context, form);
              } else {
                return LayoutBuilder(
                  builder: (context, constraints) => filterWidget(
                      context, state, form, index, constraints.minWidth),
                );
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
                'Agregar filtro  ',
                style: Typo.hint(theme_),
              ),
              Icon(
                Icons.add,
                color: ColorTheme.item10(theme_),
              )
            ],
          )),
    );
  }

  Widget filterWidget(BuildContext context, FilterState state,
      FilterFormModel form, int index, double constraintWidth) {
    final int theme_ = theme ?? 0;
    final ScrollController scrollController = ScrollController();
    List<DropdownMenuItem<String>> items = [];
    Widget widget = const SizedBox();

    for (PropertyModel prop in form.entity.propertyList) {
      items.add(DropdownMenuItem(
        value: prop.key,
        child: Text(
          prop.name,
          style: Typo.body(theme_),
          overflow: TextOverflow.ellipsis,
        ),
      ));
    }

    widget = filterController(context, form, index, theme_, constraintWidth);

    final Widget rowWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PrimaryDropDownButton(
          theme: theme_,
          margin: const EdgeInsets.fromLTRB(8, 8, 4, 8),
          width: ((constraintWidth - 50) / 2) - 65,
          value: form.filterList[index].property.key,
          items: items,
          onChanged: (value) {
            context
                .read<FilterCubit>()
                .changeDropdownProp(form, entity, value, index);
          },
        ),
        widget is SizedBox ? const Expanded(child: SizedBox()) : widget,
        IconButton(
          onPressed: () {
            context.read<FilterCubit>().remove(form, index);
          },
          icon: const Icon(Icons.clear),
          color: ColorTheme.item10(theme_),
          iconSize: 30,
        )
      ],
    );

    return Container(
        height: 60,
        width: constraintWidth,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: ColorTheme.item30(theme_)),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: form.filterList[index] is DateFilterModel
            ? RawScrollbar(
                controller: scrollController,
                child: SingleChildScrollView(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  child: rowWidget,
                ),
              )
            : rowWidget);
  }

  Widget filterController(BuildContext context, FilterFormModel form, int index,
      int theme, double constraintWidth) {
    Widget widget = const SizedBox();
    Widget subWidget = const SizedBox();
    FilterOperator operatorValue = FilterOperator.eq;
    List<DropdownMenuItem> items = [];

    if (form.filterList[index] is TextFilterModel) {
      final TextFilterModel textFilterModel =
          form.filterList[index] as TextFilterModel;

      for (FilterOperator oper in textFilterModel.operatorList) {
        items.add(
          DropdownMenuItem(
            value: oper,
            child: Text(
              FilterObjModel.operatorToText(oper),
              style: Typo.body(theme),
            ),
          ),
        );
      }

      operatorValue = textFilterModel.operator;

      subWidget = SizedBox(
        height: 56,
        width: ((constraintWidth - 50) / 2) - 65,
        child: PrimaryTextField(
          isDense: false,
          theme: theme,
          controller: textFilterModel.ctrlValue,
          margin: const EdgeInsets.fromLTRB(4, 8, 8, 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          hintText: 'Ingrese el valor',
        ),
      );
    } else if (form.filterList[index] is NumberFilterModel) {
      final NumberFilterModel numberFilter =
          form.filterList[index] as NumberFilterModel;

      for (FilterOperator oper in numberFilter.operatorList) {
        items.add(
          DropdownMenuItem(
            value: oper,
            child: Text(
              FilterObjModel.operatorToText(oper),
              style: Typo.body(theme),
            ),
          ),
        );
      }

      operatorValue = numberFilter.operator;

      subWidget = SizedBox(
        height: 56,
        width: ((constraintWidth - 50) / 2) - 65,
        child: PrimaryTextField(
          isDense: false,
          theme: theme,
          controller: numberFilter.ctrlValue,
          margin: const EdgeInsets.fromLTRB(4, 8, 8, 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          inputFormatters: [DecimalTextInputFormatter()],
          hintText: 'Ingrese el número',
        ),
      );
    } else if (form.filterList[index] is BooleanFilterModel) {
      final BooleanFilterModel booleanFilter =
          form.filterList[index] as BooleanFilterModel;
      List<DropdownMenuItem<bool>> boolItems = [
        DropdownMenuItem(
          value: true,
          child: Text('TRUE', style: Typo.body(theme)),
        ),
        DropdownMenuItem(
          value: false,
          child: Text('FALSE', style: Typo.body(theme)),
        ),
      ];

      for (FilterOperator oper in booleanFilter.operatorList) {
        items.add(
          DropdownMenuItem(
            value: oper,
            child: Text(
              FilterObjModel.operatorToText(oper),
              style: Typo.body(theme),
            ),
          ),
        );
      }

      operatorValue = booleanFilter.operator;

      subWidget = PrimaryDropDownButton(
        theme: theme,
        margin: const EdgeInsets.fromLTRB(4, 8, 8, 8),
        width: ((constraintWidth - 50) / 2) - 77,
        value: booleanFilter.value,
        items: boolItems,
        onChanged: (value) {
          context
              .read<FilterCubit>()
              .changeDropdownBool(form, index, booleanFilter, value);
        },
      );
    } else if (form.filterList[index] is DateFilterModel) {
      final DateFilterModel dateFilter =
          form.filterList[index] as DateFilterModel;

      for (FilterOperator oper in dateFilter.operatorList) {
        items.add(
          DropdownMenuItem(
            value: oper,
            child: Text(
              FilterObjModel.operatorToText(oper),
              style: Typo.body(theme),
            ),
          ),
        );
      }

      subWidget = Row(
        children: [
          const SizedBox(width: 4),
          OutlinedButton(
            style: ButtonStyle(
              alignment: Alignment.centerLeft,
              side: WidgetStatePropertyAll(
                  BorderSide(color: ColorTheme.item20(theme))),
              shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)))),
              backgroundColor: WidgetStatePropertyAll(ColorTheme.fill(theme)),
            ),
            onPressed: () {
              showDatePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              ).then(
                (value) {
                  context.read<FilterCubit>().thenDateTimePick(
                        form: form,
                        index: index,
                        date: value,
                      );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text(
                    FormatDate.dmy(dateFilter.dateTime),
                    style: Typo.body(theme),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.calendar_month,
                    color: ColorTheme.item10(theme),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            style: ButtonStyle(
              alignment: Alignment.centerLeft,
              side: WidgetStatePropertyAll(
                  BorderSide(color: ColorTheme.item20(theme))),
              shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)))),
              backgroundColor: WidgetStatePropertyAll(ColorTheme.fill(theme)),
            ),
            onPressed: () {
              showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              ).then(
                (value) {
                  context.read<FilterCubit>().thenDateTimePick(
                        form: form,
                        index: index,
                        time: value,
                      );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text(
                    FormatDate.hm(TimeOfDay.fromDateTime(dateFilter.dateTime)),
                    style: Typo.body(theme),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.watch_later_outlined,
                    color: ColorTheme.item10(theme),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (form.filterList[index] is! AddFilterModel &&
        form.filterList[index] is! EmptyFilterModel) {
      widget = Row(
        children: [
          PrimaryDropDownButton(
            theme: theme,
            margin: const EdgeInsets.fromLTRB(4, 8, 4, 8),
            width: 80,
            value: operatorValue,
            items: items,
            onChanged: (value) {
              if (value != null) {
                context
                    .read<FilterCubit>()
                    .changeDropdownOper(form, value, index);
              }
            },
          ),
          subWidget,
        ],
      );
    }

    return widget;
  }
}

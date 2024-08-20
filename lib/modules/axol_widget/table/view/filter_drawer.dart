import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:axol_inventarios/modules/object/model/filter_obj_model.dart';
import 'package:axol_inventarios/utilities/widgets/dialog.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/format.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/buttons/button.dart';
import '../../../../utilities/widgets/buttons/date_time_button.dart';
import '../../../../utilities/widgets/buttons/dropdown_button.dart';
import '../../../../utilities/widgets/textfield.dart';
import '../../../entity/model/entity_model.dart';
import '../../../entity/model/property_model.dart';
import '../../../widget_link/model/widgetlink_model.dart';
import '../cubit/filter/filter_cubit.dart';
import '../cubit/filter/filter_state.dart';
import '../model/filter_form_model.dart';

class FilterDrawer extends AxolWidget {
  final EntityModel entity;
  final List<FilterObjModel> filters;
  final List<WidgetLinkModel> referenceLink;
  const FilterDrawer({
    super.key,
    super.theme,
    required this.entity,
    required this.filters,
    required this.referenceLink,
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
        referenceLink: referenceLink,
      ),
    );
  }
}

class FilterDrawerBuild extends AxolWidget {
  final EntityModel entity;
  final List<FilterObjModel> filters;
  final List<WidgetLinkModel> referenceLink;
  const FilterDrawerBuild({
    super.key,
    super.theme,
    required this.entity,
    required this.filters,
    required this.referenceLink,
  });

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
      FilterFormModel form, int index, double constraint) {
    final int theme_ = theme ?? 0;
    final ScrollController scrollController = ScrollController();
    final double constraintWidth;
    List<DropdownMenuItem<String>> items = [];
    Widget widget = const SizedBox();

    if (constraint < 545) {
      constraintWidth = 545;
    } else {
      constraintWidth = constraint;
    }

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
            context.read<FilterCubit>().changeDropdownProp(
                  form,
                  entity,
                  value,
                  index,
                  referenceLink,
                );
          },
        ),
        widget is SizedBox
            ? SizedBox(
                width:
                    constraintWidth - (((constraintWidth - 50) / 2) - 65) - 92,
              )
            : widget,
        IconButton(
          onPressed: () {
            context.read<FilterCubit>().remove(form, index);
          },
          icon: const Icon(Icons.clear),
          color: ColorTheme.item10(theme_),
          iconSize: 30,
        ),
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
        child: constraint < 545 //form.filterList[index] is DateFilterModel
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
    final FilterModel filter = form.filterList[index];
    if (filter is TextFilterModel ||
        filter is NumberFilterModel ||
        filter is BooleanFilterModel ||
        filter is DateFilterModel) {
      subWidget = primaryControllers(
          context, form, index, theme, constraintWidth, form.filterList[index]);
    } else if (form.filterList[index] is RefObjFilterModel) {
      final RefObjFilterModel refObjFilter =
          form.filterList[index] as RefObjFilterModel;
      final FilterModel refFilter = refObjFilter.referenceFilter;

      if (refFilter is TextFilterModel ||
          refFilter is NumberFilterModel ||
          refFilter is BooleanFilterModel ||
          refFilter is DateFilterModel) {
        subWidget = primaryControllers(
            context, form, index, theme, constraintWidth, refFilter);
      }
    }
    if (form.filterList[index] is! AddFilterModel &&
        form.filterList[index] is! EmptyFilterModel) {
      widget = Row(
        children: [
          PrimaryDropDownButton(
            theme: theme,
            margin: const EdgeInsets.fromLTRB(4, 8, 4, 8),
            width: 80,
            value: form.filterList[index].operator,
            items: form.getMenuItem(index, theme),
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

  Widget primaryControllers(BuildContext context, FilterFormModel form,
      int index, int theme, double constraintWidth, FilterModel filter) {
    final Widget subWidget;

    if (filter is TextFilterModel) {
      subWidget = SizedBox(
        height: 56,
        width: ((constraintWidth - 50) / 2) - 65,
        child: PrimaryTextField(
          isDense: false,
          theme: theme,
          controller: filter.ctrlValue,
          margin: const EdgeInsets.fromLTRB(4, 8, 8, 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          hintText: 'Ingrese el valor',
          hintStyle: Typo.hint(theme),
        ),
      );
    } else if (filter is NumberFilterModel) {
      subWidget = SizedBox(
        height: 56,
        width: ((constraintWidth - 50) / 2) - 65,
        child: PrimaryTextField(
          isDense: false,
          theme: theme,
          controller: filter.ctrlValue,
          margin: const EdgeInsets.fromLTRB(4, 8, 8, 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          inputFormatters: [DecimalTextInputFormatter()],
          hintText: 'Ingrese el número',
          hintStyle: Typo.hint(theme),
        ),
      );
    } else if (filter is BooleanFilterModel) {
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

      subWidget = PrimaryDropDownButton(
        theme: theme,
        margin: const EdgeInsets.fromLTRB(4, 8, 8, 8),
        width: ((constraintWidth - 50) / 2) - 77,
        value: filter.value,
        items: boolItems,
        onChanged: (value) {
          context
              .read<FilterCubit>()
              .changeDropdownBool(form, index, filter, value);
        },
      );
    } else if (filter is DateFilterModel) {
      subWidget = DateTimeButton(
        dateTime: filter.dateTime,
        theme: theme,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: ((constraintWidth - 50) / 2) - 73,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => DateTimeDialog(
              dateTime: filter.dateTime,
              theme: theme,
            ),
          ).then(
            (value) {
              if (value is DateTime) {
                context.read<FilterCubit>().thenDateTimePick(
                    dateTime: value, form: form, index: index);
              }
            },
          );
        },
      );
    } else {
      subWidget = const SizedBox();
    }

    return subWidget;
  }
}

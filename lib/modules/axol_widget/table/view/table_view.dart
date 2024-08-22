import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:axol_inventarios/modules/axol_widget/table/model/table_cell_model.dart';
import 'package:axol_inventarios/utilities/widgets/buttons/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/checkbox_view.dart';
import '../../../../utilities/widgets/dialog.dart';
import '../../../../utilities/widgets/scroll_view_axol.dart';
import '../../../../utilities/widgets/textfield.dart';
import '../../../entity/model/property_model.dart';
import '../../../main_/cubit/main_view/mainview_cubit.dart';
import '../../../main_/cubit/main_view/mainview_state.dart';
import '../../../widget_link/model/widgetlink_model.dart';
import '../../form/view/form_drawer.dart';
import '../cubit/table/table_cubit.dart';
import '../cubit/table/table_state.dart';
import '../model/table_form_model.dart';
import 'filter_drawer.dart';
import '../../object_details/view/object_details_drawer.dart';

/// Vista que contiene el widget de tabla. Las tablas son el medio donde
/// se presentan en pantalla los objetos de un bloque consultado. Permitiendo
/// herramientas de UI para filtrar o editar su contenido.
class TableView extends AxolWidget {
  final Color? color;
  final WidgetLinkModel link;
  final String viewId;
  const TableView({
    super.key,
    this.color,
    required this.link,
    required this.viewId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TableCubit()),
        BlocProvider(create: (_) => TableForm()),
      ],
      child: TableViewBuild(
        color: color,
        link: link,
        viewId: viewId,
      ),
    );
  }
}

class TableViewBuild extends AxolWidget {
  final Color? color;
  //final TableModel table;
  //final UserModel user;
  final WidgetLinkModel link;
  final String viewId;
  const TableViewBuild({
    super.key,
    //required this.user,
    this.color,
    //required this.table,
    required this.link,
    required this.viewId,
  });

  /// Devuelve en un blocConsumer el estado actual de la vista de tabla.
  /// Escucha si hay un cambio en [MainViewCubit] para el cambio de tema.
  @override
  Widget build(BuildContext context) {
    TableFormModel form = context.read<TableForm>().state;
    return BlocListener<MainViewCubit, MainViewState>(
      listener: (context, state) {
        if (state is SetThemeMainViewState) {
          form.theme = state.theme;
          context.read<TableCubit>().load();
        }
      },
      child: BlocConsumer<TableCubit, TableState>(
        bloc: context.read<TableCubit>()..initLoad(form, link, viewId),
        listener: (context, state) {
          if (state is ErrorTableState) {
            showDialog(
                context: context,
                builder: (context) => AlertDialogAxol(text: state.error));
          }
          if (state is SavedTableState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.text,
                  style: Typo.body(form.theme),
                ),
                showCloseIcon: true,
                behavior: SnackBarBehavior.floating,
                closeIconColor: ColorTheme.text(form.theme),
                backgroundColor: ColorTheme.item30(form.theme),
              ),
            );
          }
        },
        builder: (context, state) {
          return Expanded(
              child: Scaffold(
            body: Container(
              color: ColorTheme.background(form.theme),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: ColorTheme.item30(form.theme)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: SizedBox(
                            height: 32,
                            width: 300,
                            child: PrimaryTextField(
                              controller: form.ctrlSearch,
                              padding: const EdgeInsets.all(8),
                              theme: form.theme,
                              prefixIcon: Icon(Icons.search,
                                  color: ColorTheme.item10(form.theme)),
                              hintText: "Buscar",
                              hintStyle: Typo.hint(form.theme),
                              onSubmitted: (value) {
                                context.read<TableCubit>().search(form, link);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: PrimaryButton(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            theme: form.theme,
                            icon: Icons.add,
                            text: 'Nuevo',
                            onPressed: (state is SavingTableState) ||
                                    (state is LoadingTableState)
                                ? null
                                : () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => FormDrawer(
                                              theme: form.theme,
                                              link: link,
                                            )).then(
                                      (value) {
                                        if (value == true) {
                                          context
                                              .read<TableCubit>()
                                              .initLoad(form, link, viewId);
                                        }
                                      },
                                    );
                                  },
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Visibility(
                          visible: form.edit,
                          child: Row(
                            children: [
                              Text('Ordenar: ', style: Typo.body(form.theme)),
                              Switch(
                                value: form.keyAscending != null,
                                onChanged: (value) {
                                  context
                                      .read<TableCubit>()
                                      .switchSort(form, link);
                                },
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => FilterDrawer(
                                theme: form.theme,
                                entity: link.entity,
                                filters: form.filters,
                                referenceLink: form.referenceLinks,
                              ),
                            ).then(
                              (value) {
                                context
                                    .read<TableCubit>()
                                    .thenFilter(form, link, value);
                              },
                            );
                          },
                          icon: const Icon(Icons.filter_alt_outlined),
                          color: ColorTheme.item10(form.theme),
                        ),
                        Visibility(
                          visible: (state is SavingTableState) ||
                              (state is LoadingTableState),
                          replacement: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: form.edit
                                ? () {
                                    context
                                        .read<TableCubit>()
                                        .closeEdit(form, link, viewId);
                                  }
                                : () {
                                    context.read<TableCubit>().openEdit(form);
                                  },
                            icon: Icon(
                              form.edit
                                  ? Icons.lock_open_outlined
                                  : Icons.lock_outline,
                              color: ColorTheme.item10(form.theme),
                              size: 20,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: SizedBox.square(
                              dimension: 15,
                              child: CircularProgressIndicator(
                                  color: ColorTheme.item10(form.theme)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ScrollViewAxol(
                      child: Column(
                        children: [
                          Row(
                            children: headerWidget(
                                context, form.table.header, form, state),
                          ),
                          SizedBox(
                            height: (form.table.rowList.length * 30) + 30,
                            width: form.sum(),
                            child: ListView.builder(
                              itemCount: form.table.rowList.length,
                              itemBuilder: (context, index) {
                                final row = form.table.rowList[index];
                                return OutlinedButton(
                                    style: ButtonStyle(
                                      side: WidgetStateProperty.all(
                                          BorderSide.none),
                                      padding: const WidgetStatePropertyAll(
                                          EdgeInsets.zero),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) =>
                                            ObjectDetailsDrawer(
                                          theme: form.theme,
                                          link: link,
                                          object: form.table.objects[index],
                                        ),
                                      ).then(
                                        (value) {
                                          if (value == true) {
                                            context
                                                .read<TableCubit>()
                                                .initLoad(form, link, viewId);
                                          }
                                        },
                                      );
                                    },
                                    child: Row(
                                      children: rowWidget(context, form, row,
                                          form.table.header),
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: ColorTheme.item30(form.theme)),
                      ),
                    ),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Row(
                          children: [
                            SecondaryButton(
                              icon: Icons.chevron_left,
                              theme: form.theme,
                              onPressed: () {
                                context.read<TableCubit>().prevPage(form, link);
                              },
                            ),
                            const SizedBox(width: 8),
                            Text('${form.currentPage} de ${form.totalPage}',
                                style: Typo.body(form.theme)),
                            const SizedBox(width: 8),
                            SecondaryButton(
                              icon: Icons.chevron_right,
                              theme: form.theme,
                              onPressed: () {
                                context.read<TableCubit>().nextPage(form, link);
                              },
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                Visibility(
                                  visible: form.edit,
                                  replacement: Text('${form.limitRows}',
                                      style: Typo.body(form.theme)),
                                  child: SizedBox(
                                    height: 28,
                                    width: 60,
                                    child: PrimaryTextField(
                                      controller: form.ctrlLimitRow,
                                      theme: form.theme,
                                      padding: const EdgeInsets.all(8),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                    ),
                                  ),
                                ),
                                Text(' filas', style: Typo.body(form.theme)),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Text('${form.totalReg} registros',
                                style: Typo.body(form.theme)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
        },
      ),
    );
  }

  /// Contiene los widgets que conforman encabezados de las columnas.
  List<Widget> headerWidget(BuildContext context,
      List<PropertyModel> headerTitles, TableFormModel form, TableState state) {
    List<Widget> widgetList = [];
    Widget widget;
    for (int i = 0; i < headerTitles.length; i++) {
      PropertyModel prop = headerTitles[i];
      widget = Container(
        decoration: BoxDecoration(
          border: Border.all(color: ColorTheme.item30(form.theme)),
        ),
        height: 30,
        width: form.columnWidth[prop.key] ?? 150,
        child: Stack(
          children: [
            Padding(
                padding: form.edit
                    ? const EdgeInsets.fromLTRB(4, 4, 24, 4)
                    : const EdgeInsets.all(4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text(
                      prop.name,
                      style: Typo.subtitle(form.theme),
                      overflow: TextOverflow.ellipsis,
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        PropertyModel.iconProp(prop.propertyType),
                        color: ColorTheme.item10(form.theme),
                        size: 20,
                      ),
                    ),
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: SizedBox()),
                Visibility(
                    visible: form.edit,
                    child: IconButton(
                      constraints:
                          const BoxConstraints(maxWidth: 32, maxHeight: 20),
                      onPressed: (state is SavingTableState) ||
                              (state is LoadingTableState)
                          ? () {}
                          : () {
                              context
                                  .read<TableCubit>()
                                  .sort(form, prop.key, link);
                            },
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.filter_list,
                        color: form.keyAscending == prop.key
                            ? ColorPalette.primary
                            : ColorTheme.item20(form.theme),
                        size: 20,
                      ),
                    )),
                Visibility(
                  visible: form.edit,
                  replacement: const SizedBox(),
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      final double value =
                          (form.columnWidth[prop.key] ?? 0) + details.delta.dx;
                      if (value > 100 && form.hover) {
                        form.columnWidth[prop.key] = value;
                        context.read<TableCubit>().load();
                      } else {
                        form.hover = false;
                      }
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.resizeColumn,
                      onEnter: (event) {
                        form.hover = true;
                      },
                      child: Container(
                        height: 30,
                        width: 4,
                        decoration: BoxDecoration(
                          color: ColorTheme.item30(form.theme),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
      widgetList.add(widget);
    }
    return widgetList;
  }

  /// Lista de widgets que conforman las filas de la tabla.
  List<Widget> rowWidget(BuildContext context, TableFormModel form,
      Map<String, TableCellModel> tableRow, List<PropertyModel> header) {
    List<Widget> widgetList = [];
    Widget widget;
    for (var i = 0; i < header.length; i++) {
      var prop = header[i];
      if (tableRow.keys.contains(prop.key)) {
        final cell = tableRow[prop.key]!;
        if (cell is CellText) {
          widget = Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                border: Border.all(color: ColorTheme.item30(form.theme))),
            height: 30,
            width: form.columnWidth[prop.key],
            child: Text(
              cell.text,
              style: Typo.body(form.theme),
              overflow: TextOverflow.ellipsis,
            ),
          );
        } else if (cell is CellCheck) {
          widget = Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  border: Border.all(color: ColorTheme.item30(form.theme))),
              height: 30,
              width: form.columnWidth[prop.key],
              child: CheckboxView(
                value: cell.value,
                theme: form.theme,
              ));
        } else if (cell is CellReference) {
          final Widget elementWidget;
          if (cell.text != null) {
            elementWidget = Text(
              cell.text!,
              style: Typo.body(form.theme),
              overflow: TextOverflow.ellipsis,
            );
          } else if (cell.valueBool != null) {
            elementWidget = CheckboxView(
              value: cell.valueBool!,
              theme: form.theme,
            );
          } else {
            elementWidget = const SizedBox();
          }
          widget = Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  border: Border.all(color: ColorTheme.item30(form.theme))),
              height: 30,
              width: form.columnWidth[prop.key],
              child: Row(
                children: [
                  elementWidget,
                ],
              ));
        } else if (cell is CellAtomicObject) {
          widget = Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                border: Border.all(color: ColorTheme.item30(form.theme))),
            height: 30,
            width: form.columnWidth[prop.key],
            child: Text(
              cell.atomicObject.id,
              style: Typo.body(form.theme),
              overflow: TextOverflow.ellipsis,
            ),
          );
        } else {
          widget = Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                border: Border.all(color: ColorTheme.item30(form.theme))),
            height: 30,
            width: form.columnWidth[prop.key],
          );
        }
      } else {
        widget = Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              border: Border.all(color: ColorTheme.item30(form.theme))),
          height: 30,
          width: form.columnWidth[prop.key],
        );
      }

      widgetList.add(widget);
    }
    return widgetList;
  }
}

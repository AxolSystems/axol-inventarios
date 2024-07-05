import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:axol_inventarios/modules/axol_widget/table/model/table_cell_model.dart';
import 'package:axol_inventarios/modules/axol_widget/table/model/table_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/dialog.dart';
import '../../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../../../../utilities/widgets/scroll_view_axol.dart';
import '../../../block/model/property_model.dart';
import '../../../main_/cubit/main_view/mainview_cubit.dart';
import '../../../main_/cubit/main_view/mainview_state.dart';
import '../../../user/model/user_model.dart';
import '../../../widget_link/model/widgetlink_model.dart';
import '../cubit/table_cubit.dart';
import '../cubit/table_state.dart';
import '../model/table_form_model.dart';

/// Vista que contiene el widget de tabla. Las tablas son el medio donde
/// se presentan en pantalla los objetos de un bloque consultado. Permitiendo
/// herramientas de UI para filtrar o editar su contenido.
class TableView extends AxolWidget {
  final Color? color;
  final TableModel table;
  final UserModel user;
  final WidgetLinkModel link;
  final String viewId;
  const TableView({
    super.key,
    required this.user,
    this.color,
    required this.table,
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
        table: table,
        color: color,
        user: user,
        link: link,
        viewId: viewId,
      ),
    );
  }
}

class TableViewBuild extends AxolWidget {
  final Color? color;
  final TableModel table;
  final UserModel user;
  final WidgetLinkModel link;
  final String viewId;
  const TableViewBuild({
    super.key,
    required this.user,
    this.color,
    required this.table,
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
        bloc: context.read<TableCubit>()
          ..initLoad(form, table, user, link, viewId),
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
                  'Cambios en tabla guardados.',
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
          if (state is LoadingTableState) {
            return tableView(context, state, form);
          } else if (state is LoadedTableState) {
            return tableView(context, state, form);
          } else {
            return tableView(context, state, form);
          }
        },
      ),
    );
  }

  /// Devuelve el widget de tabla general de la vista. Esta compuesto
  /// por otros widgets que conforman la vista de tabla.
  Widget tableView(
      BuildContext context, TableState state, TableFormModel form) {
    return Expanded(
        child: Scaffold(
      body: Container(
        color: ColorTheme.background(form.theme),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 30,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: ColorTheme.item30(form.theme)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: state is SavingTableState,
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
                    child: SizedBox.square(
                      dimension: 15,
                      child: CircularProgressIndicator(
                          color: ColorTheme.item10(form.theme)),
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
                      children: headerWidget(context, table.header, form),
                    ),
                    SizedBox(
                      height: (table.rowList.length * 30) + 30,
                      width: form.sum(),
                      child: ListView.builder(
                        itemCount: table.rowList.length,
                        itemBuilder: (context, index) {
                          final row = table.rowList[index];
                          return Row(
                            children:
                                rowWidget(context, form, row, table.header),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  /// Contiene los widgets que conforman encabezados de las columnas.
  List<Widget> headerWidget(BuildContext context,
      List<PropertyModel> headerTitles, TableFormModel form) {
    List<Widget> widgetList = [];
    Widget widget;
    for (int i = 0; i < headerTitles.length; i++) {
      var prop = headerTitles[i];
      widget = Container(
        decoration: BoxDecoration(
          border: Border.all(color: ColorTheme.item30(form.theme)),
        ),
        height: 30,
        width: form.columnWidth[prop.key] ?? 150,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                prop.name,
                style: Typo.subtitle(form.theme),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: SizedBox()),
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

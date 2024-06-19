import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:axol_inventarios/modules/axol_widget/table/model/table_cell_model.dart';
import 'package:axol_inventarios/modules/axol_widget/table/model/table_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../main_/cubit/main_view/mainview_cubit.dart';
import '../../../main_/cubit/main_view/mainview_state.dart';
import '../cubit/table_cubit.dart';
import '../cubit/table_state.dart';
import '../model/table_form_model.dart';

/// Vista que contiene el widget de tabla. Las tablas son el medio donde 
/// se presentan en pantalla los objetos de un bloque consultado. Permitiendo 
/// herramientas de UI para filtrar o editar su contenido.
class TableView extends AxolWidget {
  final Color? color;
  final TableModel table;
  final int themes;
  const TableView(
      {super.key, required this.themes, this.color, required this.table});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TableCubit()),
        BlocProvider(create: (_) => TableForm()),
      ],
      child: TableViewBuild(table: table, color: color, themes: themes),
    );
  }
}

class TableViewBuild extends AxolWidget {
  final Color? color;
  final TableModel table;
  final int themes;
  const TableViewBuild(
      {super.key, required this.themes, this.color, required this.table});

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
        bloc: context.read<TableCubit>()..initLoad(form, themes),
        listener: (context, state) {},
        builder: (context, state) {
          if (state is LoadingTableState) {
            return tableView(context, true, form);
          } else if (state is LoadedTableState) {
            return tableView(context, false, form);
          } else {
            return tableView(context, false, form);
          }
        },
      ),
    );
  }

  /// Devuelve el widget de tabla general de la vista. Esta compuesto 
  /// por otros widgets que conforman la vista de tabla.
  Widget tableView(BuildContext context, isLoading, TableFormModel form) {
    return Expanded(
        child: Container(
      color: color ?? Colors.amber,
      child: Column(
        children: [
          Row(
            children: headerWidget(table.header, form),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: table.rowList.length,
              itemBuilder: (context, index) {
                final row = table.rowList[index];
                return Row(
                  children: rowWidget(context, form, row, table.header),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }

  /// Contiene los widgets que conforman encabezados de las columnas.
  List<Widget> headerWidget(List<String> headerTitles, TableFormModel form) {
    List<Widget> widgetList = [];
    Widget widget;
    for (var element in headerTitles) {
      widget = SizedBox(
        height: 30,
        width: 100,
        child: Text(element, style: Typo.subtitle(form.theme)),
      );
      widgetList.add(widget);
    }
    return widgetList;
  }

  /// Lista de widgets que conforman las filas de la tabla.
  List<Widget> rowWidget(BuildContext context, TableFormModel form,
      Map<String, TableCellModel> tableRow, List<String> header) {
    List<Widget> widgetList = [];
    Widget widget;

    for (var element in header) {
      if (tableRow.keys.contains(element)) {
        final cell = tableRow[element]!;
        if (cell is CellText) { 
          widget = SizedBox(
            height: 30,
            width: 100,
            child: Text(cell.text, style: Typo.body(form.theme)),
          );
        } else {
          widget = const SizedBox(
            height: 30,
            width: 100,
          );
        }
      } else {
        widget = const SizedBox(
          height: 30,
          width: 100,
        );
      }

      widgetList.add(widget);
    }
    return widgetList;
  }
}

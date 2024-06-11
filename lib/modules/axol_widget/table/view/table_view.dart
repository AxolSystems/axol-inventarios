import 'package:axol_inventarios/modules/axol_widget/axol_widget.dart';
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

class TableView extends AxolWidget {
  final Color? color;
  final TableModel table;
  const TableView({super.key, super.theme, this.color, required this.table});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TableCubit()),
        BlocProvider(create: (_) => TableForm()),
        BlocProvider(create: (_) => MainViewCubit()),
      ],
      child: TableViewBuild(table: table, color: color, theme: theme),
    );
  }
}

class TableViewBuild extends AxolWidget {
  final Color? color;
  final TableModel table;
  const TableViewBuild(
      {super.key, super.theme, this.color, required this.table});

  @override
  Widget build(BuildContext context) {
    TableFormModel form = context.read<TableForm>().state;
    return BlocListener<MainViewCubit, MainViewState>(
      listener: (context, state) {
        if (state is SetThemeMainViewState) {
          form.theme = state.theme;
          context.read<TableCubit>().load();
          print('state: ${state.theme}');
        }
      },
      child: BlocConsumer<TableCubit, TableState>(
        bloc: context.read<TableCubit>()..initLoad(form, theme ?? 0),
        listener: (context, state) {},
        builder: (context, state) {
          if (state is LoadingTableState) {
            return tableView(true, form.theme);
          } else if (state is LoadedTableState) {
            return tableView(false, form.theme);
          } else {
            return tableView(false, form.theme);
          }
        },
      ),
    );
  }

  Widget tableView(bool isLoading, int theme_) {
    print('Tema: $theme_');
    return Expanded(
        child: Container(
      color: color ?? Colors.amber,
      child: Column(
        children: [
          Row(
            children: headerWidget(table.header, theme_),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: table.rowList.length,
              itemBuilder: (context, index) {
                final row = table.rowList[index];
                return Row(
                  children: rowWidget(theme_, row, table.header),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }

  List<Widget> headerWidget(List<String> headerTitles, int theme_) {
    List<Widget> widgetList = [];
    Widget widget;
    for (var element in headerTitles) {
      widget = SizedBox(
        height: 30,
        width: 100,
        child: Text(element, style: Typo.subtitle(theme_)),
      );
      widgetList.add(widget);
    }
    return widgetList;
  }

  List<Widget> rowWidget(
      int theme_, Map<String, TableCellModel> tableRow, List<String> header) {
    List<Widget> widgetList = [];
    Widget widget;

    for (var element in header) {
      if (tableRow.keys.contains(element)) {
        final cell = tableRow[element]!;
        if (cell is CellText) {
          widget = SizedBox(
            height: 30,
            width: 100,
            child: Text(cell.text, style: Typo.body(theme_)),
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

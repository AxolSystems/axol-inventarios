import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:axol_inventarios/modules/block/model/property_model.dart';
import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../widget_link/model/widgetlink_model.dart';
import '../cubit/row_details/row_details_cubit.dart';
import '../cubit/row_details/row_details_state.dart';
import '../model/row_details_form_model.dart';
import '../model/table_cell_model.dart';

class RowDetailsDrawer extends AxolWidget {
  final WidgetLinkModel link;
  final Map<String, TableCellModel> object;
  const RowDetailsDrawer({
    super.key,
    super.theme,
    required this.link,
    required this.object,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RowDetailsCubit()),
        BlocProvider(create: (_) => RowDetailsForm()),
      ],
      child: RowDetailsDrawerBuild(
        theme: theme,
        link: link,
        object: object,
      ),
    );
  }
}

class RowDetailsDrawerBuild extends AxolWidget {
  final WidgetLinkModel link;
  final Map<String, TableCellModel> object;
  const RowDetailsDrawerBuild({
    super.key,
    super.theme,
    required this.link,
    required this.object,
  });

  @override
  Widget build(BuildContext context) {
    int theme_ = theme ?? 0;
    RowDetailsFormModel form = context.read<RowDetailsForm>().state;
    return BlocConsumer<RowDetailsCubit, RowDetailsState>(
        bloc: context.read<RowDetailsCubit>()..initLoad(form, link),
        listener: (context, state) {},
        builder: (context, state) {
          return DrawerBox(
            theme: theme_,
            header: Row(
              children: [
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: ColorTheme.item30(theme_)),
                  )),
                  child: Text(
                    'Detalles',
                    style: Typo.titleH2(theme_),
                    textAlign: TextAlign.center,
                  ),
                ))
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
              )
            ],
            child: Expanded(
              child: ListView.builder(
                itemCount: link.block.propertyList.length,
                itemBuilder: (context, index) {
                  final PropertyModel prop = link.block.propertyList[index];
                  final CellText cell;
                  if (object[prop.key] is CellText) {
                    cell = object[prop.key] as CellText;
                  } else {
                    cell = CellText.empty();
                  }
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text('${prop.name}: ',
                              style: Typo.system(theme_)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            cell.text,
                            style: Typo.body(theme_),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}

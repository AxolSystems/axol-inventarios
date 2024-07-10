import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:axol_inventarios/modules/block/model/property_model.dart';
import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:axol_inventarios/utilities/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/dialog.dart';
import '../../../object/model/object_model.dart';
import '../../../widget_link/model/widgetlink_model.dart';
import '../cubit/row_details/row_details_cubit.dart';
import '../cubit/row_details/row_details_state.dart';
import '../model/row_details_form_model.dart';

/// Un drawer que se abre para mostrar los detalles
/// de los parámetros seleccionados. Se da la opción
/// para entrar a un modo de edición de los parámetros,
/// y eliminar el objeto.
class RowDetailsDrawer extends AxolWidget {
  final WidgetLinkModel link;
  final ObjectModel object;
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
  final ObjectModel object;
  const RowDetailsDrawerBuild({
    super.key,
    super.theme,
    required this.link,
    required this.object,
  });

  /// Construcción de drawer con el resto de su contenido.
  @override
  Widget build(BuildContext context) {
    int theme_ = theme ?? 0;
    RowDetailsFormModel form = context.read<RowDetailsForm>().state;
    return BlocConsumer<RowDetailsCubit, RowDetailsState>(
        bloc: context.read<RowDetailsCubit>()..initLoad(form, link, object),
        listener: (context, state) {
          if (state is ErrorRowDetailsState) {
            showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(text: state.error),
            );
          }
          if (state is SavedRowDetailsState) {
            context.read<RowDetailsCubit>().edit(form);
          }
        },
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
            actions: form.edit
                ? [
                    SecondaryButton(
                      theme: theme_,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      text: 'Cancelar',
                      onPressed: () {
                        context.read<RowDetailsCubit>().edit(form);
                      },
                    ),
                    PrimaryButton(
                      isLoading: state is SavingRowDetailsState,
                      theme: theme_,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      text: 'Guardar',
                      onPressed: () {
                        context.read<RowDetailsCubit>().save(form, link);
                      },
                    ),
                  ]
                : [
                    AlertButton(
                      text: 'Eliminar',
                      theme: theme_,
                      onPressed: () {},
                    ),
                    SecondaryButton(
                      theme: theme_,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      text: 'Editar',
                      onPressed: () {
                        context.read<RowDetailsCubit>().edit(form);
                      },
                    ),
                    SecondaryButton(
                      theme: theme_,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      text: 'Regresar',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
            child: Expanded(
              child: ListView.builder(
                itemCount: link.block.propertyList.length,
                itemBuilder: (context, index) {
                  final PropertyModel prop = link.block.propertyList[index];
                  final String cell;
                  if (form.object.map[prop.key] is String) {
                    cell = form.object.map[prop.key] as String;
                  } else {
                    cell = '';
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
                          child: Visibility(
                            visible: form.edit,
                            replacement: Text(
                              cell,
                              style: Typo.body(theme_),
                            ),
                            child: PrimaryTextField(
                              theme: theme_,
                              controller: form.controllers[prop.key],
                            ),
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

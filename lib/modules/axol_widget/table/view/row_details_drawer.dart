import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/dialog.dart';
import '../../../../utilities/widgets/textfield.dart';
import '../../../block/model/property_model.dart';
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
              builder: (context) => AlertDialogAxol(
                text: state.error,
              ),
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
                        context.read<RowDetailsCubit>().save(
                              form,
                              link,
                            );
                      },
                    ),
                  ]
                : [
                    AlertButton(
                      text: 'Eliminar',
                      theme: theme_,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => BlocProvider(
                            create: (_) => RowDetailsCubit(),
                            child: AlertDialogObjectDelete(
                              form: form,
                              link: link,
                              theme: theme_,
                            ),
                          ),
                        );
                      },
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
                  final List<TextInputFormatter> inputFormatters;

                  if (form.object.map[prop.key] is String) {
                    cell = form.object.map[prop.key] as String;
                  } else if (form.object.map[prop.key] is int ||
                      form.object.map[prop.key] is double) {
                    cell = form.object.map[prop.key].toString();
                  } else {
                    cell = '';
                  }

                  if (prop.propertyType == Prop.int ||
                      prop.propertyType == Prop.double) {
                    inputFormatters = [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
                    ];
                  } else {
                    inputFormatters = [];
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
                              inputFormatters: inputFormatters,
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

/// Clase que contiene widget dialogo de alerta para confirmación de eliminación de objeto.
class AlertDialogObjectDelete extends AxolWidget {
  final RowDetailsFormModel form;
  final WidgetLinkModel link;
  const AlertDialogObjectDelete({
    super.key,
    super.theme,
    required this.form,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    int theme_ = theme ?? 0;
    return BlocConsumer<RowDetailsCubit, RowDetailsState>(
      listener: (context, state) {
        if (state is DeletedRowDetailsState) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
      builder: (context, state) => AlertDialogAxol(
        theme: theme_,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 4, 0),
                child: SecondaryButton(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  theme: theme_,
                  height: 40,
                  text: 'Regresar',
                  textAlign: TextAlign.center,
                  onPressed: () {
                    if (state is LoadedRowDetailsState) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
                child: AlertButton(
                  theme: theme_,
                  height: 40,
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 8, vertical: 8),
                  text: 'Eliminar',
                  isLoading: state is DeletingRowDetailsState,
                  onPressed: () {
                    if (state is LoadedRowDetailsState) {
                      context.read<RowDetailsCubit>().delete(form, link);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
        text:
            'Seguro desea eliminar este objeto. \nEsta acción no se podrá deshacer.',
      ),
    );
  }
}

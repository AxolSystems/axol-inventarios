import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:axol_inventarios/utilities/widgets/checkbox_view.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/format.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/dialog.dart';
import '../../../../utilities/widgets/textfield.dart';
import '../../../entity/model/property_model.dart';
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
                itemCount: link.entity.propertyList.length,
                itemBuilder: (context, index) {
                  final PropertyModel prop = link.entity.propertyList[index];
                  final Widget widgetRead;
                  final Widget widgetWrite;
                  final List<TextInputFormatter> inputFormatters;

                  if (prop.propertyType == Prop.text) {
                    widgetRead = Text(
                      form.object.map[prop.key] ?? '',
                      style: Typo.body(theme_),
                    );
                  } else if ((form.object.map[prop.key] is int ||
                          form.object.map[prop.key] is double ||
                          form.object.map[prop.key] == null) &&
                      (prop.propertyType == Prop.int ||
                          prop.propertyType == Prop.double)) {
                    widgetRead = Text(
                      '${form.object.map[prop.key] ?? ''}',
                      style: Typo.body(theme_),
                    );
                  } else if ((form.object.map[prop.key] is bool ||
                          form.object.map[prop.key] == null) &&
                      prop.propertyType == Prop.bool) {
                    widgetRead = Align(
                      alignment: Alignment.centerLeft,
                      child: CheckboxView(
                        value: form.object.map[prop.key] ?? false,
                        theme: theme_,
                      ),
                    );
                  } else if ((form.object.map[prop.key] is int ||
                          form.object.map[prop.key] == null) &&
                      prop.propertyType == Prop.time) {
                    widgetRead = Text(
                      FormatDate.dmyHm(DateTime.fromMillisecondsSinceEpoch(
                          form.object.map[prop.key] ?? 0)),
                      style: Typo.body(theme_),
                    );
                  } else {
                    widgetRead = const SizedBox();
                  }

                  if (prop.propertyType == Prop.int ||
                      prop.propertyType == Prop.double) {
                    inputFormatters = [
                      DecimalTextInputFormatter(),
                    ];
                  } else {
                    inputFormatters = [];
                  }

                  if ((form.object.map[prop.key] is String ||
                          form.object.map[prop.key] == null) &&
                      prop.propertyType == Prop.text) {
                    final RDTextEditingController textController =
                        form.controllers[prop.key] as RDTextEditingController;
                    widgetWrite = PrimaryTextField(
                      theme: theme_,
                      controller: textController.controller,
                      inputFormatters: inputFormatters,
                    );
                  } else if ((form.object.map[prop.key] is int ||
                          form.object.map[prop.key] is double ||
                          form.object.map[prop.key] == null) &&
                      (prop.propertyType == Prop.int ||
                          prop.propertyType == Prop.double)) {
                    final RDTextEditingController textController =
                        form.controllers[prop.key] as RDTextEditingController;
                    widgetWrite = PrimaryTextField(
                      theme: theme_,
                      controller: textController.controller,
                      inputFormatters: inputFormatters,
                    );
                  } else if ((form.object.map[prop.key] is bool ||
                          form.object.map[prop.key] == null) &&
                      prop.propertyType == Prop.bool) {
                    final RDBoolController boolController =
                        form.controllers[prop.key] as RDBoolController;
                    widgetWrite = Align(
                      alignment: Alignment.centerLeft,
                      child: Checkbox(
                        activeColor: ColorTheme.item20(theme_),
                        side: BorderSide(
                            color: ColorTheme.item20(theme_), width: 2),
                        value: boolController.controller,
                        onChanged: (value) {
                          if (value != null) {
                            form.controllers[prop.key] =
                                RDBoolController(controller: value);
                          }
                          context.read<RowDetailsCubit>().load();
                        },
                      ),
                    );
                  } else if ((form.object.map[prop.key] is int ||
                          form.object.map[prop.key] == null) &&
                      prop.propertyType == Prop.time) {
                    final RDDateController dateController =
                        form.controllers[prop.key] as RDDateController;
                    ScrollController scrollController = ScrollController();
                    widgetWrite = RawScrollbar(
                        controller: scrollController,
                        scrollbarOrientation: ScrollbarOrientation.bottom,
                        child: SizedBox(
                          height: 40,
                          child: ListView(
                            controller: scrollController,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              OutlinedButton(
                                style: ButtonStyle(
                                  alignment: Alignment.centerLeft,
                                  side: WidgetStatePropertyAll(BorderSide(
                                      color: ColorTheme.item20(theme_))),
                                  shape: const WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6)))),
                                  backgroundColor: WidgetStatePropertyAll(
                                      ColorTheme.fill(theme_)),
                                ),
                                onPressed: () {
                                  showDatePicker(
                                    context: context,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now(),
                                  ).then(
                                    (value) {
                                      context
                                          .read<RowDetailsCubit>()
                                          .thenDateTimePick(
                                              form: form,
                                              prop: prop,
                                              date: value);
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Text(
                                        FormatDate.dmy(
                                            dateController.controller),
                                        style: Typo.body(theme_),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(
                                      Icons.calendar_month,
                                      color: ColorTheme.item10(theme_),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton(
                                style: ButtonStyle(
                                  alignment: Alignment.centerLeft,
                                  side: WidgetStatePropertyAll(BorderSide(
                                      color: ColorTheme.item20(theme_))),
                                  shape: const WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6)))),
                                  backgroundColor: WidgetStatePropertyAll(
                                      ColorTheme.fill(theme_)),
                                ),
                                onPressed: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then(
                                    (value) {
                                      context
                                          .read<RowDetailsCubit>()
                                          .thenDateTimePick(
                                              form: form,
                                              prop: prop,
                                              time: value);
                                    },
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    children: [
                                      Text(
                                        FormatDate.hm(TimeOfDay.fromDateTime(
                                            dateController.controller)),
                                        style: Typo.body(theme_),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(
                                        Icons.watch_later_outlined,
                                        color: ColorTheme.item10(theme_),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ));
                  } else {
                    widgetWrite = const SizedBox();
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
                            replacement: widgetRead,
                            child: widgetWrite,
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
      bloc: context.read<RowDetailsCubit>()..load(),
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

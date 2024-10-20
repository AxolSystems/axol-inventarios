import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:axol_inventarios/modules/object/model/atomic_object_model.dart';
import 'package:axol_inventarios/modules/object/model/reference_object_model.dart';
import 'package:axol_inventarios/utilities/widgets/buttons/button.dart';
import 'package:axol_inventarios/utilities/widgets/buttons/dropdown_button.dart';
import 'package:axol_inventarios/utilities/widgets/checkbox_view.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/format.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/buttons/date_time_button.dart';
import '../../../../utilities/widgets/label_field.dart';
import '../../../../utilities/widgets/object_card.dart';
import '../../search_button/view/search_button.dart';
import '../../search_button/view/search_reference_object.dart';
import '../../../../utilities/widgets/dialog.dart';
import '../../../../utilities/widgets/textfield.dart';
import '../../../entity/model/property_model.dart';
import '../../../object/model/object_model.dart';
import '../../../widget_link/model/widgetlink_model.dart';
import '../cubit/object_details_cubit.dart';
import '../cubit/object_details_state.dart';
import '../model/object_details_form_model.dart';

/// Un drawer que se abre para mostrar los detalles
/// de los parámetros seleccionados. Se da la opción
/// para entrar a un modo de edición de los parámetros,
/// y eliminar el objeto.
class ObjectDetailsDrawer extends AxolWidget {
  final WidgetLinkModel link;
  final ObjectModel object;
  final ReferenceObjectModel? referenceObject;
  final List<PropertyModel>? propsAtmObj;
  const ObjectDetailsDrawer({
    super.key,
    super.theme,
    required this.link,
    required this.object,
    this.referenceObject,
    this.propsAtmObj,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ObjectDetailsCubit()),
        BlocProvider(create: (_) => RowDetailsForm()),
      ],
      child: ObjectDetailsDrawerBuild(
        theme: theme,
        link: link,
        object: object,
        referenceObject: referenceObject,
        propsAtmObj: propsAtmObj,
      ),
    );
  }
}

class ObjectDetailsDrawerBuild extends AxolWidget {
  final WidgetLinkModel link;
  final ObjectModel object;
  final ReferenceObjectModel? referenceObject;
  final List<PropertyModel>? propsAtmObj;
  const ObjectDetailsDrawerBuild({
    super.key,
    super.theme,
    required this.link,
    required this.object,
    this.referenceObject,
    this.propsAtmObj,
  });

  /// Construcción de drawer con el resto de su contenido.
  @override
  Widget build(BuildContext context) {
    int theme_ = theme ?? 0;
    ObjectDetailsFormModel form = context.read<RowDetailsForm>().state;
    return BlocConsumer<ObjectDetailsCubit, ObjectDetailsState>(
        bloc: context.read<ObjectDetailsCubit>()
          ..initLoad(form, link, object, referenceObject, propsAtmObj),
        listener: (context, state) {
          if (state is ErrorRowDetailsState) {
            showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                theme: theme_,
                text: state.error,
              ),
            );
          }
          if (state is SavedObjectDetailsState) {
            context.read<ObjectDetailsCubit>().edit(form);
            if (propsAtmObj != null) {
              Navigator.pop(context, form.object);
            }
          }
        },
        builder: (context, state) {
          return DrawerBox(
            onPressedOutside: () {
              Navigator.pop(context, form.isEdited);
            },
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
                        context.read<ObjectDetailsCubit>().edit(form);
                      },
                    ),
                    PrimaryButton(
                      isLoading: state is SavingObjectDetailsState,
                      theme: theme_,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      text: 'Guardar',
                      onPressed: () {
                        if (propsAtmObj == null) {
                          context.read<ObjectDetailsCubit>().save(
                                form,
                                link,
                                object,
                              );
                        } else {
                          context
                              .read<ObjectDetailsCubit>()
                              .saveAtmObj(form, propsAtmObj!);
                        }
                      },
                    ),
                  ]
                : [
                    Visibility(
                      visible: referenceObject == null,
                      child: AlertButton(
                        text: 'Eliminar',
                        theme: theme_,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => BlocProvider(
                              create: (_) => ObjectDetailsCubit(),
                              child: AlertDialogObjectDelete(
                                form: form,
                                link: link,
                                theme: theme_,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: referenceObject == null,
                      child: SecondaryButton(
                        theme: theme_,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        text: 'Editar',
                        onPressed: () {
                          context.read<ObjectDetailsCubit>().edit(form);
                        },
                      ),
                    ),
                    SecondaryButton(
                      theme: theme_,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      text: 'Regresar',
                      onPressed: () {
                        Navigator.pop(context, form.isEdited);
                      },
                    ),
                  ],
            child: Expanded(
              child: ListView.builder(
                itemCount: referenceObject != null
                    ? referenceObject!.referenceLink.entity.propertyList.length
                    : propsAtmObj != null
                        ? propsAtmObj!.length
                        : link.entity.propertyList.length,
                itemBuilder: (context, index) {
                  final PropertyModel prop = referenceObject != null
                      ? referenceObject!
                          .referenceLink.entity.propertyList[index]
                      : propsAtmObj != null
                          ? propsAtmObj![index]
                          : link.entity.propertyList[index];
                  final Widget widgetRead;
                  final Widget widgetWrite;
                  final List<TextInputFormatter> inputFormatters;
                  final Widget refWidget;
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
                  } else if ((form.object.map[prop.key] is DateTime ||
                          form.object.map[prop.key] == null) &&
                      prop.propertyType == Prop.time) {
                    widgetRead = Text(
                      form.object.map[prop.key] == null
                          ? ''
                          : FormatDate.dmyHm(form.object.map[prop.key]),
                      style: Typo.body(theme_),
                    );
                  } else if (prop.propertyType == Prop.referenceObject) {
                    final ReferenceObjectModel refObj =
                        form.object.map[prop.key];
                    if (refObj.getPropView().propertyType == Prop.double ||
                        refObj.getPropView().propertyType == Prop.int) {
                      refWidget = Text(
                        '${refObj.referenceObject.map[refObj.getPropView().key] ?? ''}',
                        style: Typo.body(theme_),
                      );
                    } else if (refObj.getPropView().propertyType == Prop.text) {
                      refWidget = Text(
                        refObj.referenceObject.map[refObj.getPropView().key] ??
                            '',
                        style: Typo.body(theme_),
                      );
                    } else if (refObj.getPropView().propertyType == Prop.bool) {
                      refWidget = Align(
                        alignment: Alignment.centerLeft,
                        child: CheckboxView(
                          value: refObj.referenceObject
                                  .map[refObj.getPropView().key] ??
                              false,
                          theme: theme_,
                        ),
                      );
                    } else if (refObj.getPropView().propertyType == Prop.time) {
                      refWidget = Text(
                        FormatDate.dmyHm(DateTime.fromMillisecondsSinceEpoch(
                            refObj.referenceObject
                                    .map[refObj.getPropView().key] ??
                                0)),
                        style: Typo.body(theme_),
                      );
                    } else {
                      refWidget = const SizedBox();
                    }

                    widgetRead = Row(
                      children: [
                        refWidget,
                        const Expanded(child: SizedBox()),
                        SizedBox(
                          height: 20,
                          child: IconButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => ObjectDetailsDrawer(
                                    link: WidgetLinkModel.empty(),
                                    object: refObj.referenceObject,
                                    referenceObject: refObj,
                                    theme: theme_,
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.arrow_outward,
                                color: ColorTheme.item10(theme_),
                                size: 20,
                              )),
                        ),
                      ],
                    );
                  } else if (prop.propertyType == Prop.atomicObject &&
                      form.object.map[prop.key] is AtomicObjectModel) {
                    final AtomicObjectModel atmObj = form.object.map[prop.key];
                    widgetRead = ObjectCard(
                      theme: theme_,
                      object: ObjectModel(
                          createAt: DateTime(0),
                          id: atmObj.id,
                          map: atmObj.values),
                      propertyList: PropertyModel.mapToProperty(
                          prop.dynamicValues[PropertyModel.dvPropsAtomObj]),
                    );
                  } else if (prop.propertyType == Prop.array &&
                      form.controllers[prop.key] is RDArray) {
                    final RDArray arrayController =
                        form.controllers[prop.key] as RDArray;
                    widgetRead = Text(
                      arrayController.array.value,
                      style: Typo.body(theme_),
                    );
                  } else if (prop.propertyType == Prop.formula) {
                    final RDFormula formulaController;
                    if (form.controllers[prop.key] is RDFormula) {
                      formulaController =
                          form.controllers[prop.key] as RDFormula;
                    } else {
                      formulaController = RDFormula.empty();
                    }
                    widgetRead = Text(
                      formulaController.value,
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
                      onSubmitted: (value) {
                        context.read<ObjectDetailsCubit>().load();
                        nextFocus(context, index);
                      },
                      onChanged: (value) {
                        context
                            .read<ObjectDetailsCubit>()
                            .updateObjectForm(form, link.entity.propertyList);
                      },
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
                      onSubmitted: (value) {
                        nextFocus(context, index);
                        context.read<ObjectDetailsCubit>().load();
                      },
                      onChanged: (value) {
                        context
                            .read<ObjectDetailsCubit>()
                            .updateObjectForm(form, link.entity.propertyList);
                      },
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
                          context.read<ObjectDetailsCubit>().load();
                        },
                      ),
                    );
                  } else if ((form.object.map[prop.key] is DateTime ||
                          form.object.map[prop.key] == null) &&
                      prop.propertyType == Prop.time) {
                    final RDDateController dateController =
                        form.controllers[prop.key] as RDDateController;
                    widgetWrite = DateTimeButton(
                      theme: theme_,
                      dateTime: dateController.controller,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => DateTimeDialog(
                                  dateTime: dateController.controller ??
                                      DateTime.now(),
                                  theme: theme_,
                                  isBlank: dateController.controller == null,
                                )).then(
                          (value) {
                            if (value is DateTimeDialogFormModel) {
                              if (value.isBlank == true) {
                                context
                                    .read<ObjectDetailsCubit>()
                                    .thenDateTimePick(
                                        form: form,
                                        prop: prop,
                                        dateTime: null,
                                        index: index);
                                nextFocus(context, index);
                              } else {
                                context
                                    .read<ObjectDetailsCubit>()
                                    .thenDateTimePick(
                                        form: form,
                                        prop: prop,
                                        dateTime: value.dateTime,
                                        index: index);
                                nextFocus(context, index);
                              }
                            }
                          },
                        );
                      },
                    );
                  } else if (prop.propertyType == Prop.referenceObject) {
                    final ReferenceObjectModel refObj =
                        form.object.map[prop.key];
                    widgetWrite = SearchButton(
                      referenceObject: refObj,
                      theme: theme_,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => SearchReferenceObject(
                            theme: theme_,
                            idRefLink: refObj.referenceLink.id,
                            initIdRefObject: refObj.referenceObject.id,
                            idRefPropView: refObj.idPropertyView,
                          ),
                        ).then(
                          (value) {
                            if (value is ReferenceObjectModel) {
                              form.object.map[prop.key] = value;
                              form.controllers[prop.key] = RDReferenceObject(
                                  refObject: value,
                                  oldIdRefObject: refObj.referenceObject.id);
                              context.read<ObjectDetailsCubit>().load();
                            }
                          },
                        );
                      },
                    );
                  } else if (prop.propertyType == Prop.atomicObject &&
                      form.object.map[prop.key] is AtomicObjectModel) {
                    final AtomicObjectModel atmObj = form.object.map[prop.key];
                    widgetWrite = ObjectCard(
                      theme: theme_,
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => ObjectDetailsDrawer(
                            theme: theme_,
                            link: link,
                            object: ObjectModel(
                              createAt: DateTime(0),
                              id: atmObj.id,
                              map: atmObj.values,
                            ),
                            propsAtmObj: PropertyModel.mapToProperty(link
                                .entity.propertyList
                                .firstWhere((x) => x.key == prop.key)
                                .dynamicValues[PropertyModel.dvPropsAtomObj]),
                          ),
                        ).then(
                          (value) {
                            if (value is ObjectModel) {
                              final AtomicObjectModel thenAtmObj =
                                  AtomicObjectModel(
                                id: value.id,
                                values: value.map,
                              );
                              form.controllers[prop.key] = RDAtomicObject(
                                atmObject: thenAtmObj,
                              );
                              form.object.map[prop.key] = thenAtmObj;
                              context.read<ObjectDetailsCubit>().load();
                            }
                          },
                        );
                      },
                      object: ObjectModel(
                          createAt: DateTime(0),
                          id: atmObj.id,
                          map: atmObj.values),
                      propertyList: PropertyModel.mapToProperty(
                          prop.dynamicValues[PropertyModel.dvPropsAtomObj]),
                    );
                  } else if (prop.propertyType == Prop.array &&
                      form.controllers[prop.key] is RDArray) {
                    final RDArray arrayController =
                        form.controllers[prop.key] as RDArray;
                    widgetWrite = PrimaryDropDownButton(
                      theme: theme_,
                      value: arrayController.array.list
                              .contains(arrayController.array.value)
                          ? arrayController.array.value
                          : arrayController.array.list.first,
                      items: arrayController.array.getItems(theme_),
                      onChanged: (value) {
                        if (value is String) {
                          context.read<ObjectDetailsCubit>().changeArray(
                                form: form,
                                prop: prop,
                                value: value,
                                array: arrayController.array,
                                index: index,
                              );
                          nextFocus(context, index);
                        }
                      },
                      width: 200,
                    );
                  } else if (prop.propertyType == Prop.formula) {
                    final RDFormula formulaController;
                    if (form.controllers[prop.key] is RDFormula) {
                      formulaController =
                          form.controllers[prop.key] as RDFormula;
                    } else {
                      formulaController = RDFormula.empty();
                    }
                    widgetWrite = LabelField(
                      theme: theme_,
                      text: formulaController.value,
                    );
                  } else {
                    widgetWrite = const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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

  void nextFocus(BuildContext context, int index) {
    if (FocusScope.of(context).focusedChild == null) {
      for (int i = 0; i <= index + 1; i++) {
        FocusScope.of(context).nextFocus();
      }
    } else {
      FocusScope.of(context).nextFocus();
    }
  }
}

/// Clase que contiene widget dialogo de alerta para confirmación de eliminación de objeto.
class AlertDialogObjectDelete extends AxolWidget {
  final ObjectDetailsFormModel form;
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
    return BlocConsumer<ObjectDetailsCubit, ObjectDetailsState>(
      bloc: context.read<ObjectDetailsCubit>()..load(),
      listener: (context, state) {
        if (state is DeletedObjectDetailsState) {
          Navigator.pop(context);
          Navigator.pop(context, true);
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
                    if (state is LoadedObjectDetailsState) {
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
                  isLoading: state is DeletingObjectDetailsState,
                  onPressed: () {
                    if (state is LoadedObjectDetailsState) {
                      context.read<ObjectDetailsCubit>().delete(form, link);
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

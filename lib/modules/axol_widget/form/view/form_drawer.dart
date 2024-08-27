import 'package:axol_inventarios/modules/object/model/object_model.dart';
import 'package:axol_inventarios/modules/widget_link/model/widgetlink_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/format.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/buttons/button.dart';
import '../../../../utilities/widgets/buttons/date_time_button.dart';
import '../../../../utilities/widgets/dialog.dart';
import '../../../../utilities/widgets/drawer_box.dart';
import '../../../../utilities/widgets/object_card.dart';
import '../../../../utilities/widgets/textfield.dart';
import '../../../entity/model/property_model.dart';
import '../../../object/model/reference_object_model.dart';
import '../../generic/view/axol_widget.dart';
import '../../search_button/view/search_button.dart';
import '../../search_button/view/search_reference_object.dart';
import '../cubit/form_cubit.dart';
import '../cubit/form_state.dart';
import '../model/form_form_model.dart';

class FormDrawer extends AxolWidget {
  final WidgetLinkModel link;
  const FormDrawer({super.key, super.theme, required this.link});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FormCubit()),
        BlocProvider(create: (_) => FormForm()),
      ],
      child: FormDrawerBuild(
        theme: theme,
        link: link,
      ),
    );
  }
}

class FormDrawerBuild extends AxolWidget {
  final WidgetLinkModel link;
  const FormDrawerBuild({super.key, super.theme, required this.link});

  @override
  Widget build(BuildContext context) {
    final int theme_ = theme ?? 0;
    FormFormModel form = context.read<FormForm>().state;
    return BlocConsumer<FormCubit, FormDrawerState>(
      bloc: context.read<FormCubit>()..initLoad(form, link.entity),
      listener: (context, state) {
        if (state is ErrorFormState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialogAxol(
              text: state.error,
              theme: theme_,
            ),
          );
        }
        if (state is SavedFormState) {
          Navigator.pop(context, true);
        }
      },
      builder: (context, state) {
        List<Widget> widgetList = [];

        for (int i = 0; i < form.fields.length; i++) {
          final FormFieldModel field = form.fields[i];
          if (field is TextFieldModel) {
            widgetList.add(PrimaryTextField(
              isDense: false,
              theme: theme,
              controller: field.ctrlText,
              margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              labelText: field.property.name,
              labelStyle: Typo.hint(theme_),
            ));
          } else if (field is NumberFieldModel) {
            widgetList.add(PrimaryTextField(
              isDense: false,
              theme: theme,
              controller: field.ctrlNum,
              margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              labelText: field.property.name,
              labelStyle: Typo.hint(theme_),
              inputFormatters: [DecimalTextInputFormatter()],
            ));
          } else if (field is BooleanFieldModel) {
            widgetList.add(Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Text(
                        field.property.name,
                        style: Typo.body(theme_),
                      )),
                  Expanded(
                      flex: 1,
                      child: Checkbox(
                        activeColor: ColorTheme.item20(theme_),
                        side: BorderSide(
                            color: ColorTheme.item20(theme_), width: 2),
                        value: field.value,
                        onChanged: (value) {
                          context
                              .read<FormCubit>()
                              .changeCheckbox(form, value, i);
                        },
                      ))
                ],
              ),
            ));
          } else if (field is DateFieldModel) {
            widgetList.add(DateTimeButton(
              theme: theme_,
              dateTime: field.dateTime,
              margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => DateTimeDialog(
                          dateTime: field.dateTime,
                          theme: theme_,
                        )).then(
                  (value) {
                    if (value is DateTime) {
                      context
                          .read<FormCubit>()
                          .thenDateTimePick(form, i, value);
                    }
                  },
                );
              },
            ));
          } else if (field is ReferenceObjectFieldModel) {
            widgetList.add(
              SearchButton(
                theme: theme_,
                referenceObject: field.refObj,
                margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => SearchReferenceObject(
                      theme: theme_,
                      idRefLink: field.refObj.referenceLink.id,
                      initIdRefObject: field.refObj.referenceObject.id,
                      idRefPropView: field.refObj.idPropertyView,
                    ),
                  ).then(
                    (value) {
                      if (value is ReferenceObjectModel) {
                        form.fields[i] = ReferenceObjectFieldModel(
                            refObj: value, property: field.property);
                        context.read<FormCubit>().load();
                      }
                    },
                  );
                },
              ),
            );
          } else if (field is AtmObjFieldModel) {
            widgetList.add(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ObjectCard(
                  theme: theme_,
                  object: ObjectModel(
                    createAt: DateTime(0),
                    id: field.atomicObject.id,
                    map: field.atomicObject.values,
                  ),
                  propertyList: PropertyModel.mapToProperty(link
                      .entity.propertyList
                      .firstWhere((x) => x.key == field.property.key)
                      .dynamicValues[PropertyModel.dvPropsAtomObj]),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => FormDrawer(
                        theme: theme_,
                        link: link,
                      ),
                    );
                  },
                ),
              ),
            );
          }
        }

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
                    'Nuevo objeto',
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
              isLoading: state is SavingFormState,
              theme: theme_,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              text: 'Guardar',
              onPressed: () {
                context.read<FormCubit>().save(form, link); //Seguir aquí...
              },
            ),
          ],
          children: widgetList,
        );
      },
    );
  }
}

import 'package:axol_inventarios/modules/object/model/object_model.dart';
import 'package:axol_inventarios/modules/widget_link/model/widgetlink_model.dart';
import 'package:axol_inventarios/utilities/widgets/buttons/dropdown_button.dart';
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
  final List<PropertyModel>? atmPropertyList;
  const FormDrawer(
      {super.key, super.theme, required this.link, this.atmPropertyList});

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
        atmPropertyList: atmPropertyList,
      ),
    );
  }
}

class FormDrawerBuild extends AxolWidget {
  final WidgetLinkModel link;
  final List<PropertyModel>? atmPropertyList;
  const FormDrawerBuild(
      {super.key, super.theme, required this.link, this.atmPropertyList});

  @override
  Widget build(BuildContext context) {
    final int theme_ = theme ?? 0;
    FormFormModel form = context.read<FormForm>().state;
    return BlocConsumer<FormCubit, FormDrawerState>(
      bloc: context.read<FormCubit>()
        ..initLoad(form, link.entity, atmPropertyList),
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
          Navigator.pop(context, state.object);
        }
      },
      builder: (context, state) {
        List<Widget> widgetList = [];

        for (int i = 0; i < form.fields.length; i++) {
          final FormFieldModel field = form.fields[i];
          if (field is TextFieldModel) {
            widgetList.add(PrimaryTextField(
              isFocus: form.focusIndex == i,
              isDense: false,
              theme: theme,
              controller: field.ctrlText,
              margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              labelText: field.property.name,
              labelStyle: Typo.hint(theme_),
              onSubmitted: (value) {
                form.focusIndex = i + 1;
                context.read<FormCubit>().load();
              },
            ));
          } else if (field is NumberFieldModel) {
            widgetList.add(PrimaryTextField(
              isFocus: form.focusIndex == i,
              isDense: false,
              theme: theme,
              controller: field.ctrlNum,
              margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              labelText: field.property.name,
              labelStyle: Typo.hint(theme_),
              inputFormatters: [DecimalTextInputFormatter()],
              onSubmitted: (value) {
                form.focusIndex = i + 1;
                context.read<FormCubit>().load();
              },
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
              isFocus: form.focusIndex == i,
              theme: theme_,
              dateTime: field.dateTime,
              margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => DateTimeDialog(
                          dateTime: field.dateTime ?? DateTime.now(),
                          theme: theme_,
                          isBlank: field.dateTime == null,
                        )).then(
                  (value) {
                    if (value is DateTimeDialogFormModel) {
                      if (value.isBlank == true) {
                        form.focusIndex = i + 1;
                        context
                            .read<FormCubit>()
                            .thenDateTimePick(form, i, null);
                      } else {
                        form.focusIndex = i + 1;
                        context
                            .read<FormCubit>()
                            .thenDateTimePick(form, i, value.dateTime);
                      }
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
            final List<PropertyModel> atmPropertyList =
                PropertyModel.mapToProperty(link.entity.propertyList
                    .firstWhere((x) => x.key == field.property.key)
                    .dynamicValues[PropertyModel.dvPropsAtomObj]);
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
                  propertyList: atmPropertyList,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => FormDrawer(
                        theme: theme_,
                        link: link,
                        atmPropertyList: atmPropertyList,
                      ),
                    ).then(
                      (value) {
                        if (value is ObjectModel) {
                          context.read<FormCubit>().thenAtmObj(form, i, value);
                        }
                      },
                    );
                  },
                ),
              ),
            );
          } else if (field is ArrayFieldModel) {
            widgetList.add(
              PrimaryDropDownButton(
                isFocus: form.focusIndex == i,
                theme: theme_,
                value: field.array.value,
                items: field.array.getItems(theme_),
                onChanged: (value) {
                  if (value is String) {
                    context
                        .read<FormCubit>()
                        .changeArray(form: form, value: value, index: i);
                    
                  }
                },
                width: 100,
                margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                isDense: false,
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
                context.read<FormCubit>().save(form, link, atmPropertyList);
              },
            ),
          ],
          children: widgetList,
        );
      },
    );
  }
}

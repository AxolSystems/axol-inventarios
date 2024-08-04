import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:axol_inventarios/modules/entity/model/property_model.dart';
import 'package:axol_inventarios/utilities/widgets/loading_indicator/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/dialog.dart';
import '../../../utilities/widgets/buttons/button.dart';
import '../../../utilities/widgets/textfield.dart';
import '../../main_/cubit/main_view/mainview_cubit.dart';
import '../../main_/cubit/main_view/mainview_state.dart';
import '../cubit/setentity_cubit.dart';
import '../cubit/setentity_state.dart';
import '../model/setentity_form_model.dart';

/// AxolWidget donde se muestran las opciones de configuración del sistema.
class SetEntityWidget extends AxolWidget {
  const SetEntityWidget({super.key, required super.theme});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SetEntityCubit()),
        BlocProvider(create: (_) => SetEntityForm()),
      ],
      child: SetEntityWidgetBuild(theme: theme ?? 0),
    );
  }
}

class SetEntityWidgetBuild extends StatelessWidget {
  final int theme;
  const SetEntityWidgetBuild({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    SetEntityFormModel form = context.read<SetEntityForm>().state;
    return BlocListener<MainViewCubit, MainViewState>(
      listener: (context, state) {},
      child: BlocConsumer<SetEntityCubit, SetEntityState>(
        bloc: context.read<SetEntityCubit>()..initLoad(form, theme),
        listener: (context, state) {
          if (state is ErrorSetEntityState) {
            showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(
                text: state.error,
              ),
            );
          }
          if (state is SavingSetEntityState) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) =>
                    const LoadingDialog(text: 'Guardando...'));
          }
          if (state is SavedSetEntityState) {
            form.isChanged = false;
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is LoadingSetEntityState) {
            return setEntityWidgetBuild(context, form, true);
          } else if (state is LoadedSetEntityState) {
            return setEntityWidgetBuild(context, form, false);
          } else {
            return setEntityWidgetBuild(context, form, false);
          }
        },
      ),
    );
  }

  /// Widget que contiene los elementos principales de la vista.
  Widget setEntityWidgetBuild(
      BuildContext context, SetEntityFormModel form, bool isLoading) {
    const double widthMenuEntity = 250;
    ScrollController scrollController = ScrollController();
    ScrollController scrollController2 = ScrollController();

    return isLoading
        ? Expanded(
            child: Container(
            color: ColorTheme.background(form.theme),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [LinearProgressIndicatorAxol()],
            ),
          ))
        : BlocListener<MainViewCubit, MainViewState>(
            listener: (context, state) {
            if (state is SetThemeMainViewState) {
              form.theme = state.theme;
              context.read<SetEntityCubit>().load();
            }
          }, child: Expanded(child: LayoutBuilder(
            builder: (context, constraints) {
              final double paddingBox;
              final double heightBox;
              bool isBoxNarrow = false;
              if (constraints.maxWidth > 1450) {
                paddingBox = 130;
                heightBox = 108;
              } else if (constraints.maxWidth > 1190) {
                paddingBox = 110;
                heightBox = 108;
              } else if (constraints.maxWidth > 940) {
                paddingBox = 50;
                heightBox = 108;
              } else {
                paddingBox = 16;
                heightBox = 150;
                isBoxNarrow = true;
              }
              //print('max: ${constraints.maxWidth}');
              return Container(
                color: ColorTheme.background(form.theme),
                child: RawScrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  radius: const Radius.circular(8),
                  thickness: 12,
                  child: ListView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        width: widthMenuEntity,
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                          color: ColorTheme.item30(form.theme),
                        ))),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                'Bloques disponibles',
                                style: Typo.subtitle(form.theme),
                              ),
                            ),
                            Expanded(
                                child: ListView.builder(
                              itemCount: form.entityList.length,
                              itemBuilder: (context, index) {
                                final entity = form.entityList[index];
                                final entityName = entity.entityName == ''
                                    ? 'Bloque ${entity.tableName.split('table_').last}'
                                    : entity.entityName;
                                return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(4, 4, 4, 0),
                                    child: MainNavButton(
                                      onPressed: () {
                                        if (index != form.select) {
                                          form.select = index;
                                          form.cEntity =
                                              form.entityList[form.select];
                                          context
                                              .read<SetEntityCubit>()
                                              .switchEntity(form);
                                        }
                                      },
                                      text: entityName,
                                      menuVisible: false,
                                      isHover: form.select == index,
                                      theme: form.theme,
                                    ));
                              },
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                          width: constraints.maxWidth > 750
                              ? constraints.maxWidth - widthMenuEntity
                              : 500,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: RawScrollbar(
                                      controller: scrollController2,
                                      thumbVisibility: true,
                                      radius: const Radius.circular(8),
                                      thickness: 12,
                                      child: SingleChildScrollView(
                                        controller: scrollController2,
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  paddingBox,
                                                  16,
                                                  paddingBox,
                                                  24),
                                              child: Container(
                                                width:
                                                    constraints.maxWidth > 750
                                                        ? constraints.maxWidth -
                                                            widthMenuEntity -
                                                            (paddingBox * 2)
                                                        : 500,
                                                height: heightBox,
                                                padding:
                                                    const EdgeInsets.all(24),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: ColorTheme.item30(
                                                          form.theme)),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(6)),
                                                  color: ColorTheme.item40(
                                                      form.theme),
                                                ),
                                                child:
                                                    constraints.maxWidth > 940
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children:
                                                                generalSettings(
                                                                    context,
                                                                    form,
                                                                    isBoxNarrow),
                                                          )
                                                        : Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children:
                                                                generalSettings(
                                                                    context,
                                                                    form,
                                                                    isBoxNarrow),
                                                          ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: paddingBox),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Propiedades',
                                                    style: Typo.subtitle(
                                                        form.theme),
                                                  ),
                                                  PrimaryButton(
                                                    theme: form.theme,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(8, 0, 12, 0),
                                                    text: 'Agregar',
                                                    icon: Icons.add,
                                                    onPressed: () {
                                                      context
                                                          .read<SetEntityCubit>()
                                                          .addProperty(form);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: (paddingBox)),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        24, 16, 24, 8),
                                                decoration: BoxDecoration(
                                                  color: ColorTheme.item40(
                                                      form.theme),
                                                  border: Border(
                                                    top: BorderSide(
                                                        color:
                                                            ColorTheme.item30(
                                                                form.theme)),
                                                    left: BorderSide(
                                                        color:
                                                            ColorTheme.item30(
                                                                form.theme)),
                                                    right: BorderSide(
                                                        color:
                                                            ColorTheme.item30(
                                                                form.theme)),
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius
                                                          .vertical(
                                                          top: Radius.circular(
                                                              6)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text('Nombre',
                                                            style: Typo.label(
                                                                form.theme))),
                                                    const SizedBox(width: 16),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Text('Propiedad',
                                                            style: Typo.label(
                                                                form.theme))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            propertySetting(form, paddingBox),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  paddingBox,
                                                  0,
                                                  paddingBox,
                                                  16),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                    color: ColorTheme.item40(
                                                        form.theme),
                                                    border: Border.all(
                                                        color:
                                                            ColorTheme.item30(
                                                                form.theme)),
                                                    borderRadius:
                                                        const BorderRadius
                                                            .vertical(
                                                            bottom:
                                                                Radius.circular(
                                                                    6))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    PrimaryButton(
                                                      theme: form.theme,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8),
                                                      text: 'Guardar',
                                                      onPressed: form.isChanged
                                                          ? () {
                                                              context
                                                                  .read<
                                                                      SetEntityCubit>()
                                                                  .save(form);
                                                            }
                                                          : null,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))),
                            ],
                          ))
                    ],
                  ),
                ),
              );
            },
          )));
  }

  /// Sección que contiene los widgets de ajustes generales del bloque seleccionado.
  List<Widget> generalSettings(
      BuildContext context, SetEntityFormModel form, bool isBoxNarrow) {
    return [
      SizedBox(
        width: 150,
        child: Text(
          'Ajustes generales',
          style: Typo.subtitle(form.theme),
        ),
      ),
      Visibility(
        visible: isBoxNarrow == false,
        replacement: const SizedBox(height: 16),
        child: const Expanded(
          flex: 1,
          child: SizedBox(),
        ),
      ),
      Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre del bloque', style: Typo.label(form.theme)),
            const SizedBox(height: 4),
            PrimaryTextField(
              theme: form.theme,
              onChanged: (value) {
                form.isChanged = true;
                context.read<SetEntityCubit>().load();
              },
              controller: form.ctrlEntityName,
            )
          ],
        ),
      ),
    ];
  }

  /// Sección que contiene los widgets y elementos del ajuste de propiedades 
  /// del bloque seleccionado.
  Widget propertySetting(SetEntityFormModel form, double paddingBox) =>
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: form.heightBoxProp),
        child: ListView.builder(
          itemCount: form.properties.length,
          itemBuilder: (context, index) {
            final SetEntityPropModel property = form.properties[index];
            List<DropdownMenuItem<Prop>> itemList = [];
            DropdownMenuItem<Prop> item;
            for (Prop prop in Prop.values) {
              item = DropdownMenuItem(
                value: prop,
                child: Text(
                  PropertyModel.getTextToProp(prop),
                ),
              );
              itemList.add(item);
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingBox),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorTheme.item40(form.theme),
                  border: Border.symmetric(
                    vertical: BorderSide(color: ColorTheme.item30(form.theme)),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: PrimaryTextField(
                          controller: property.ctrlProp,
                          theme: form.theme,
                          onChanged: (value) {
                            form.isChanged = true;
                            context.read<SetEntityCubit>().load();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 36,
                          child: DropdownButtonFormField(
                            dropdownColor: ColorTheme.background(form.theme),
                            icon: const SizedBox(),
                            style: Typo.system(form.theme),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              prefixIcon: Icon(
                                Icons.keyboard_arrow_down,
                                color: ColorTheme.text(form.theme),
                                size: 15,
                              ),
                              filled: true,
                              fillColor: ColorTheme.fill(form.theme),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6)),
                                  borderSide: BorderSide(
                                      color: ColorTheme.item20(form.theme))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  borderSide: BorderSide(
                                      color: ColorTheme.item10(form.theme))),
                            ),
                            items: itemList,
                            value: form.properties[index].property,
                            onChanged: (value) {
                              if (value != null) {
                                context
                                    .read<SetEntityCubit>()
                                    .selectProp(form, index, value);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
}

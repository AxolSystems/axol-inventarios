import 'package:axol_inventarios/modules/module/model/module_model.dart';
import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:axol_inventarios/utilities/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/drawer_box.dart';
import '../../../utilities/widgets/textfield.dart';
import '../../axol_widget/generic/view/axol_widget.dart';
import '../../widget_link/model/widgetlink_model.dart';
import '../../widget_link/view/widgetlink_drawer.dart';
import '../cubit/set_module_drawer/set_module_drawer_cubit.dart';
import '../cubit/set_module_drawer/set_module_drawer_state.dart';
import '../model/set_module_drawer_form_model.dart';

/// Widget de tipo [DrawerBox] que se utiliza para realizar ajustes en un
/// módulo o crear uno nuevo.
class SetModuleDrawer extends AxolWidget {
  final ModuleModel module;
  final EnumSetModuleAction action;
  const SetModuleDrawer(this.module, {super.key, super.theme, required this.action});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SetModuleDrawerCubit()),
        BlocProvider(create: (_) => SetModuleDrawerForm(module)),
      ],
      child: SetModuleDrawerBuild(module, theme: theme, action: action,),
    );
  }
}

class SetModuleDrawerBuild extends AxolWidget {
  final ModuleModel module;
  final EnumSetModuleAction action;
  const SetModuleDrawerBuild(this.module, {super.key, super.theme, required this.action});

  /// Crea el widget general del drawer de ajustes, retornando uno distinto
  /// según su estado.
  @override
  Widget build(BuildContext context) {
    SetModuleDrawerFormModel form = context.read<SetModuleDrawerForm>().state;
    return BlocConsumer<SetModuleDrawerCubit, SetModuleDrawerState>(
      bloc: context.read<SetModuleDrawerCubit>()..initLoad(form, module),
      builder: (context, state) {
        if (state is LoadingSetModuleDrawerState) {
          return setModuleDrawer(
              context, form, SetModuleStateEnum.loading, theme);
        } else if (state is LoadedSetModuleDrawerState) {
          return setModuleDrawer(
              context, form, SetModuleStateEnum.loaded, theme);
        } else if (state is SavingSetModuleDrawerState) {
          return setModuleDrawer(
              context, form, SetModuleStateEnum.saving, theme);
        } else {
          return setModuleDrawer(
              context, form, SetModuleStateEnum.loaded, theme);
        }
      },
      listener: (context, state) {
        if (state is ErrorSetModuleDrawerState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(text: state.error));
        }
        if (state is SavedSetModuleDrawerState) {
          Navigator.pop(context, true);
        }
      },
    );
  }

  /// Widget con los elementos de drawer, este widget es el que se toma para
  /// reconstruirlo cada vez que hay un cambio en el estado.
  Widget setModuleDrawer(BuildContext context, SetModuleDrawerFormModel form,
      SetModuleStateEnum state, int? theme_) {
    final int theme = theme_ ?? 0;
    const double heightLinkBox = 50;
    final String title;

    if (action == EnumSetModuleAction.add) {
      title = 'Nuevo módulo';
    } else if (action == EnumSetModuleAction.edit) {
      title = 'Editar módulo';
    } else {
      title = '';
    }
    return DrawerBox(
      theme: theme,
      header: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(title, style: Typo.titleH2(theme)),
          ),
          Divider(
            color: ColorTheme.item30(theme),
            height: 0,
          )
        ],
      ),
      actions: [
        SecondaryButton(
          text: 'Cancelar',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          theme: theme,
          onPressed: state == SetModuleStateEnum.loaded
              ? () {
                  Navigator.pop(context);
                }
              : null,
        ),
        PrimaryButton(
          text: 'Guardar',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          theme: theme,
          isLoading: state == SetModuleStateEnum.saving,
          onPressed: SetModuleDrawerFormModel.compareForms(form)
              ? null
              : () {
                  if (state == SetModuleStateEnum.loaded) {
                    context.read<SetModuleDrawerCubit>().save(form, module, action);
                  }
                },
        ),
      ],
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    'Nombre',
                    style: Typo.body(theme),
                  )),
              Expanded(
                flex: 3,
                child: PrimaryTextField(
                  controller: form.ctrlName,
                  theme: theme,
                  enabled: state == SetModuleStateEnum.loaded,
                  onChanged: (value) {
                    context.read<SetModuleDrawerCubit>().load();
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    'Icono',
                    style: Typo.body(theme),
                  )),
              Expanded(
                flex: 3,
                child: PrimaryTextField(
                  controller: form.ctrlIcon,
                  theme: theme,
                  enabled: state == SetModuleStateEnum.loaded,
                  onChanged: (value) {
                    context.read<SetModuleDrawerCubit>().load();
                  },
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: ColorTheme.item30(theme),
          height: 0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Text('WidgetLinks', style: Typo.subtitle(theme)),
                    const Expanded(child: SizedBox()),
                    SecondaryButton(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      text: 'Agregar link',
                      theme: theme,
                      onPressed: state != SetModuleStateEnum.loaded
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) => WidgetLinkDrawer(
                                    theme: theme, moduleLinks: form.links),
                              ).then(
                                (value) {
                                  context
                                      .read<SetModuleDrawerCubit>()
                                      .thenAddLink(value, form);
                                },
                              );
                            },
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    color: ColorTheme.item40(theme),
                    border: Border(
                      left: BorderSide(color: ColorTheme.item30(theme)),
                      right: BorderSide(color: ColorTheme.item30(theme)),
                      top: BorderSide(color: ColorTheme.item30(theme)),
                    ),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(6))),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: Text('Id', style: Typo.body(theme)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Text('Bloque', style: Typo.body(theme)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: Text('Widget', style: Typo.body(theme)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: Text('Número de vistas', style: Typo.body(theme)),
                    ),
                    const SizedBox(width: 56),
                  ],
                ),
              ),
              Visibility(
                visible: form.links.isNotEmpty,
                replacement: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: ColorTheme.item30(theme)),
                      left: BorderSide(color: ColorTheme.item30(theme)),
                      right: BorderSide(color: ColorTheme.item30(theme)),
                    ),
                    borderRadius:
                        const BorderRadius.vertical(bottom: Radius.circular(6)),
                  ),
                  child: Center(
                    child: Text('No hay links', style: Typo.body(theme)),
                  ),
                ),
                child: SizedBox(
                  height:
                      (form.links.length * heightLinkBox) + (form.links.length),
                  child: ListView.builder(
                    itemCount: form.links.length,
                    itemBuilder: (context, index) {
                      final WidgetLinkModel link = form.links[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: ColorTheme.item30(theme)),
                            left: BorderSide(color: ColorTheme.item30(theme)),
                            right: BorderSide(color: ColorTheme.item30(theme)),
                          ),
                          borderRadius: index < (form.links.length - 1)
                              ? null
                              : const BorderRadius.vertical(
                                  bottom: Radius.circular(6)),
                        ),
                        child: SizedBox(
                          height: heightLinkBox,
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 3,
                                child: Text(link.id, style: Typo.body(theme)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: Text(link.block.blockName,
                                    style: Typo.body(theme)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 1,
                                child: Text(link.widget.toString(),
                                    style: Typo.body(theme)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 1,
                                child: Text(link.views.length.toString(),
                                    style: Typo.body(theme)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: PopupMenuButton(
                                  enabled: state == SetModuleStateEnum.loaded,
                                  icon: Icon(Icons.more_horiz,
                                      color: ColorTheme.text(theme)),
                                  color: ColorTheme.item40(theme),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 0,
                                      child: Text('Eliminar',
                                          style: Typo.alert(theme)),
                                    ),
                                  ],
                                  onSelected: (value) {
                                    context
                                        .read<SetModuleDrawerCubit>()
                                        .onSelectPopupMenu(value, form, index);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

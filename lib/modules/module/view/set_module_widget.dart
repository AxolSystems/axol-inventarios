import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/button.dart';
import '../../../utilities/widgets/loading_indicator/progress_indicator.dart';
import '../../main_/cubit/main_view/mainview_cubit.dart';
import '../../main_/cubit/main_view/mainview_state.dart';
import '../cubit/set_module/set_module_cubit.dart';
import '../cubit/set_module/set_module_state.dart';
import '../model/module_model.dart';
import '../model/set_module_form_model.dart';

/// Widget para la configuración de módulos. Muestra un listado 
/// de módulos existentes y da la opción de editar cada uno o 
/// agregar un nuevo módulo.
class SetModuleWidget extends AxolWidget {
  const SetModuleWidget({super.key, super.theme});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SetModuleCubit()),
        BlocProvider(create: (_) => SetModuleForm()),
      ],
      child: SetModuleWidgetBuild(
        theme: theme,
      ),
    );
  }
}

class SetModuleWidgetBuild extends AxolWidget {
  const SetModuleWidgetBuild({super.key, super.theme});

  /// Construye el widget según el estado actual.
  @override
  Widget build(BuildContext context) {
    SetModuleFormModel form = context.read<SetModuleForm>().state;
    form.theme = theme ?? 0;
    return BlocConsumer<SetModuleCubit, SetModuleState>(
      bloc: context.read<SetModuleCubit>()..initLoad(form),
      builder: (context, state) {
        if (state is LoadingSetModuleState) {
          return setModuleWidget(context, form, true);
        } else if (state is LoadedSetModuleState) {
          return setModuleWidget(context, form, false);
        } else {
          return setModuleWidget(context, form, false);
        }
      },
      listener: (context, state) {},
    );
  }

  /// Devuelve la vista principal del widget para editar módulos.
  Widget setModuleWidget(
      BuildContext context, SetModuleFormModel form, bool isLoading) {
    ScrollController scrollCtrlHorizontal = ScrollController();
    ScrollController scrollCtrlVertical = ScrollController();
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
                context.read<SetModuleCubit>().load();
              }
            },
            child: Expanded(child: LayoutBuilder(
              builder: (context, constraints) {
                final double paddingBox;
                final double widthBox;
                if (constraints.maxWidth > 1450) {
                  paddingBox = 130;
                } else if (constraints.maxWidth > 1190) {
                  paddingBox = 110;
                } else if (constraints.maxWidth > 940) {
                  paddingBox = 50;
                } else {
                  paddingBox = 16;
                }

                if (constraints.maxWidth > 500) {
                  widthBox = constraints.maxWidth - (paddingBox * 2);
                } else {
                  widthBox = 500;
                }

                return Container(
                    color: ColorTheme.background(form.theme),
                    height: double.infinity,
                    child: RawScrollbar(
                      controller: scrollCtrlVertical,
                      thumbVisibility: true,
                      trackVisibility: true,
                      interactive: true,
                      radius: const Radius.circular(8),
                      thickness: 12,
                      scrollbarOrientation: ScrollbarOrientation.right,
                      child: RawScrollbar(
                        padding: const EdgeInsets.only(right: 12),
                        controller: scrollCtrlHorizontal,
                        thumbVisibility: true,
                        trackVisibility: true,
                        interactive: true,
                        scrollbarOrientation: ScrollbarOrientation.bottom,
                        radius: const Radius.circular(8),
                        notificationPredicate: (ScrollNotification notify) =>
                            notify.depth == 1,
                        thickness: 12,
                        child: SingleChildScrollView(
                          controller: scrollCtrlVertical,
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            primary: false,
                            controller: scrollCtrlHorizontal,
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: paddingBox, vertical: 24),
                              child: SizedBox(
                                width: widthBox,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        PrimaryButton(
                                          text: 'Nuevo módulo',
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          theme: form.theme,
                                          onPressed: () {},
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                ColorTheme.item30(form.theme)),
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(6)),
                                        color: ColorTheme.item40(form.theme),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text('Nombre',
                                                style: Typo.body(form.theme)),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text('Icono',
                                                style: Typo.body(form.theme)),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text('WidgetLinks',
                                                style: Typo.body(form.theme)),
                                          ),
                                          Expanded(
                                            child: Text('',
                                                style: Typo.body(form.theme)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    moduleList(form),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ));
              },
            )),
          );
  }

  /// Devuelve una lista con vista general de todos los módulos existentes.
  Widget moduleList(SetModuleFormModel form) {
    const double rowHeight = 40;
    return Container(
      height: (rowHeight * form.modules.length) + (form.modules.length * 2),
      decoration: BoxDecoration(
        border: Border.all(color: ColorTheme.item30(form.theme)),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(6)),
      ),
      child: Center(
        heightFactor: 12,
        child: form.modules.isEmpty
            ? Text(
                'Sin módulos',
                style: Typo.body(form.theme),
              )
            : ListView.builder(
                shrinkWrap: false,
                itemCount: form.modules.length,
                itemBuilder: (context, index) {
                  final ModuleModel model = form.modules[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: rowHeight,
                    decoration: BoxDecoration(
                      border: (index + 1) < form.modules.length
                          ? Border(
                              bottom: BorderSide(
                                  color: ColorTheme.item30(form.theme)))
                          : null,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(model.name, style: Typo.body(form.theme)),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(model.icon.toString(),
                              style: Typo.body(form.theme)),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(model.widgetLinks.length.toString(),
                              style: Typo.body(form.theme)),
                        ),
                        Flexible(
                          child: SecondaryButton(
                            text: 'Editar',
                            theme: form.theme,
                            width: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            onPressed: () {
                              context.read<SetModuleCubit>().edit(context, form);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

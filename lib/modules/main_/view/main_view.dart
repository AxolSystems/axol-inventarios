import 'package:axol_inventarios/modules/module/model/module_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/dialog.dart';
import '../../../utilities/widgets/buttons/button.dart';
import '../../../utilities/widgets/popup_menu_btn_axol.dart';
import '../../user/repository/user_repo.dart';
import '../../user/view/views/login_view.dart';
import '../../widget_link/model/widget_view_model.dart';
import '../../widget_link/model/widgetlink_model.dart';
import '../cubit/main_view/mainview_cubit.dart';
import '../cubit/main_view/mainview_state.dart';
import '../model/main_view_form_model.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MainViewCubit()),
        BlocProvider(create: (_) => MainViewForm()),
      ],
      child: const MainViewBuild(),
    );
  }
}

class MainViewBuild extends StatelessWidget {
  const MainViewBuild({super.key});

  /// Construye [MainView] según el estado actual.
  ///
  /// ### Estados
  /// - Loading: muestra ciertos elementos en estado de carga.
  /// - Loaded: vista con todos los elementos cargados.
  /// - Error: muestra una ventana emergente con el error.
  @override
  Widget build(BuildContext context) {
    MainViewFormModel form = context.read<MainViewForm>().state;
    return BlocConsumer<MainViewCubit, MainViewState>(
      bloc: context.read<MainViewCubit>()..initLoad(form),
      builder: (context, state) {
        if (state is LoadingMainViewState) {
          return mainView(context, true, form);
        } else if (state is LoadedMainViewState) {
          return mainView(context, false, form);
        } else {
          return mainView(context, false, form);
        }
      },
      listener: (context, state) {
        if (state is ErrorMainViewState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(text: state.error));
        }
      },
    );
  }

  /// Contiene la vista general de programa.
  Widget mainView(
      BuildContext context, bool isLoading, MainViewFormModel form) {
    return Material(
        child: Column(
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
              color: ColorTheme.background(form.user.theme),
              border: Border(
                  bottom:
                      BorderSide(color: ColorTheme.item30(form.user.theme)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox.square(
                dimension: 60,
                child: Material(
                  color: Colors.transparent,
                  type: MaterialType.circle,
                  child: IconButton(
                    splashRadius: 24,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      form.moduleBarVisible = !form.moduleBarVisible;
                      context.read<MainViewCubit>().load();
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: ColorPalette.middleItems,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Text(
                form.title,
                style: Typo.titleH2(form.user.theme),
              ),
              const Expanded(child: SizedBox()),
              Visibility(
                visible: isLoading,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
            child: Row(
          children: [
            Visibility(
              visible: form.moduleBarVisible,
              child: moduleBar(
                isLoading: isLoading,
                context: context,
                form: form,
                select: form.moduleSelect,
                moduleList: form.moduleList,
                menuVisible: form.menuVisible,
              ),
            ),
            form.body ??
                Expanded(
                    child: Container(
                  color: ColorTheme.background(form.user.theme),
                )),
          ],
        ))
      ],
    ));
  }

  /// Contiene barra de módulos.
  ///
  /// Antes de devolver el widget, obtiene de [ModuleModel.widgetLinks] el los widgetLinks
  /// que le pertenecen al modulo actual.
  ///
  /// - En fila:
  ///   - En Columna:
  ///     - ListView con módulos obtenidos de [MainViewFormModel.moduleList].
  ///     - Divider
  ///     - [MainNavButton] de configuración.
  ///     - [PopupMenuBtnAxol] de cuenta.
  ///   - Lista de menu de links y views. Las listas pueden ser [listMenu] o [listMenuSetting].
  ///
  /// TODO: Mover child de popUpMenu a una función aparte.

  Widget moduleBar({
    required BuildContext context,
    required MainViewFormModel form,
    required List<ModuleModel> moduleList,
    required int select,
    required bool menuVisible,
    required bool isLoading,
  }) {
    List<WidgetLinkModel> widgetLinks = [];
    if (select >= 0 && isLoading == false) {
      widgetLinks = moduleList[select].widgetLinks;
    } else if (select == -1) {
    } else {
      widgetLinks = [];
    }

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: ColorTheme.background(form.user.theme),
            border: Border(
                right: BorderSide(color: ColorTheme.item30(form.user.theme))),
          ),
          height: double.infinity,
          width: 200,
          child: Column(
            children: [
              Expanded(
                child: Visibility(
                  visible: form.moduleList.isNotEmpty,
                  replacement: const SizedBox(),
                  child: ListView.builder(
                    itemCount: moduleList.length,
                    itemBuilder: (context, index) {
                      final module = moduleList[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                        child: MainNavButton(
                          icon: module.icon,
                          isHover: select == index,
                          text: module.name,
                          onPressed: () {
                            if (form.moduleSelect == index) {
                              form.menuVisible = !form.menuVisible;
                              context.read<MainViewCubit>().load();
                            } else {
                              context
                                  .read<MainViewCubit>()
                                  .setModule(form, index);
                            }
                          },
                          menuVisible: menuVisible,
                          isModule: true,
                          theme: form.user.theme,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Divider(
                color: ColorTheme.item30(form.user.theme),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                child: MainNavButton(
                  icon: Icons.settings,
                  isHover: select == -1,
                  onPressed: () {
                    if (form.moduleSelect == -1) {
                      form.menuVisible = !form.menuVisible;
                      context.read<MainViewCubit>().load();
                    } else {
                      form.moduleSelect = -1;
                      context.read<MainViewCubit>().setSetting(form, 0);
                      form.title = 'Configuración';
                    }
                  },
                  text: 'Configuración',
                  menuVisible: menuVisible,
                  isModule: true,
                  theme: form.user.theme,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: PopupMenuBtnAxol(
                  theme: form.user.theme,
                  icon: Icons.person,
                  text: 'Cuenta',
                  entryList: <PopupMenuEntry<int>>[
                    PopupMenuItem(
                      value: 0,
                      enabled: false,
                      child: SizedBox(
                        width: 100,
                        child: Text(
                          "Usuario",
                          style: Typo.system(form.user.theme),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      enabled: false,
                      child: Text("Tema", style: Typo.system(form.user.theme)),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child:
                          Text("Oscuro", style: Typo.system(form.user.theme)),
                      onTap: () {
                        context
                            .read<MainViewCubit>()
                            .setTheme(form.user, 0, form);
                      },
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Text("Claro", style: Typo.system(form.user.theme)),
                      onTap: () {
                        context
                            .read<MainViewCubit>()
                            .setTheme(form.user, 1, form);
                      },
                    ),
                    const PopupMenuDivider(height: 16),
                    PopupMenuItem(
                      value: 3,
                      child: Text("Cerrar sesión",
                          style: Typo.system(form.user.theme)),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialogAxol(
                                  theme: form.user.theme,
                                  text: '¿Desea cerrar sesión?',
                                  actions: [
                                    PrimaryButtonDialog(
                                      text: 'Aceptar',
                                      onPressed: () {
                                        LocalUser()
                                            .setLocalUser('', '', -1, 0, []);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginView()));
                                      },
                                    ),
                                    SecondaryButtonDialog(
                                      text: 'Cancelar',
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ));
                      },
                    ),
                  ],
                ),
              ),
              Text('V1.1.0.6', style: Typo.label(form.user.theme))
            ],
          ),
        ),
        Visibility(
          visible: menuVisible,
          child: Container(
            width: 200,
            decoration: BoxDecoration(
                color: ColorTheme.background(form.user.theme),
                border: Border(
                    right:
                        BorderSide(color: ColorTheme.item30(form.user.theme)))),
            child: Column(
              children: [
                Expanded(
                    child: form.moduleSelect == -1
                        ? listMenuSetting(context, form)
                        : listMenu(widgetLinks, form))
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Lista de menú de módulos.
  /// - ListView de widgetLinks de módulo seleccionado.
  ///   - Nombre del widgetLink
  ///   - ListView de widgetViews de link. Contiene [MainNavButton] que abrirá
  /// view del link.
  Widget listMenu(List<WidgetLinkModel> widgetLinks, MainViewFormModel form) {
    ScrollController scrollController = ScrollController();

    return RawScrollbar(
      controller: scrollController,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        controller: scrollController,
        itemCount: widgetLinks.length,
        itemBuilder: (context, index) {
          final WidgetLinkModel wl = widgetLinks[index];
          final List<WidgetViewModel> viewList;
          if (wl.views.isEmpty) {
            viewList = [
              WidgetViewModel(
                name: wl.entity.entityName,
                filterList: [],
                key: '',
                properties: {},
              ),
            ];
          } else {
            viewList = wl.views;
          }

          return SizedBox(
            height: (viewList.length * 30) + 30,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                  child: Text(wl.entity.entityName,
                      style: Typo.system(form.user.theme)),
                ),
                SizedBox(
                  height: viewList.length * 30,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: viewList.length,
                    itemBuilder: (context, subIndex) {
                      final WidgetViewModel view = viewList[subIndex];
                      return SizedBox(
                        width: 30,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                          child: MainNavButton(
                            text: view.name,
                            theme: form.user.theme,
                            menuVisible: form.menuVisible,
                            isHover: form.linkSelect == index &&
                                form.viewSelect == subIndex,
                            onPressed: () {
                              context
                                  .read<MainViewCubit>()
                                  .setWidgetLink(form, index, subIndex);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Lista con [MainNavButton] para cada widget de configuración del sistema.
  Widget listMenuSetting(BuildContext context, MainViewFormModel form) {
    ScrollController scrollController = ScrollController();

    return RawScrollbar(
        controller: scrollController,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: scrollController,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                child: MainNavButton(
                  text: 'Bloques',
                  theme: form.user.theme,
                  menuVisible: form.menuVisible,
                  isHover: form.linkSelect == 0,
                  onPressed: () {
                    context.read<MainViewCubit>().setSetting(form, 0);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                child: MainNavButton(
                  text: 'Módulos',
                  theme: form.user.theme,
                  menuVisible: form.menuVisible,
                  isHover: form.linkSelect == 1,
                  onPressed: () {
                    context.read<MainViewCubit>().setSetting(form, 1);
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

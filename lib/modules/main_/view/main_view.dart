import 'package:axol_inventarios/modules/axol_widget/axol_widget.dart';
import 'package:axol_inventarios/modules/main_/model/entry_menu_model.dart';
import 'package:axol_inventarios/modules/main_/model/modul_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/dialog.dart';
import '../../../utilities/widgets/button.dart';
import '../../../utilities/widgets/popup_menu_btn_axol.dart';
import '../../block/view/setblock_widget.dart';
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
  @override
  Widget build(BuildContext context) {
    MainViewFormModel form = context.read<MainViewForm>().state;
    return BlocConsumer<MainViewCubit, MainViewState>(
      bloc: context.read<MainViewCubit>()..initLoad(context, form),
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
                      color: ColorPalette.midleItems,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Text(
                form.title,
                style: Typo.titleLightH2,
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
                context: context,
                form: form,
                select: form.moduleSelect,
                moduleList: form.moduleList,
                menuVisible: form.menuVisible,
                onPressedSetting: () {
                  if (form.moduleSelect == -1) {
                    form.menuVisible = !form.menuVisible;
                  }
                  form.moduleSelect = -1;
                  form.title = 'Configuración';
                  context.read<MainViewCubit>().load();
                },
              ),
            ),
            BlocBuilder<MainViewForm, MainViewFormModel>(
              builder: (context, state) =>
                  form.body ??
                  Expanded(
                      child: Container(
                    color: ColorTheme.background(form.user.theme),
                  )),
            ),
          ],
        ))
      ],
    ));
  }

  Widget moduleBar({
    required BuildContext context,
    required MainViewFormModel form,
    required List<ModuleModel> moduleList,
    required int select,
    required bool menuVisible,
    Function()? onPressedSetting,
  }) {
    final List<EntryMenuModel> entryList;

    if (select >= 0) {
      entryList = moduleList[select].menu;
    } else if (select == -1) {
      entryList = [
        EntryMenuModel(
          text: 'Bloques',
          value: 0,
          onPressed: () {
            form.body = const SetBlockWidget();
            form.menuSelect = 0;
            context.read<MainViewCubit>().load();
          },
        ),
        EntryMenuModel(
          text: 'Modulos',
          value: 1,
          onPressed: () {
            form.body = TextAW.textTest(form.user.theme, 'Prueba');
            form.menuSelect = 1;
            context.read<MainViewCubit>().load();
          },
        ),
      ];
    } else {
      entryList = [];
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
                child: ListView.builder(
                  itemCount: moduleList.length,
                  itemBuilder: (context, index) {
                    final module = moduleList[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                      child: MainNavButton(
                        icon: module.icon,
                        isHover: select == index,
                        text: module.text,
                        onPressed: module.onPressed,
                        menuVisible: menuVisible,
                        isModule: true,
                        theme: form.user.theme,
                      ),
                    );
                  },
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
                  onPressed: onPressedSetting,
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: menuVisible,
          child: Container(
            width: 200,
            decoration: BoxDecoration(
                color: ColorTheme.background(form.user.theme),
                border: const Border(
                    right: BorderSide(color: ColorPalette.darkItems20))),
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                  itemCount: entryList.length,
                  itemBuilder: (context, index) {
                    final EntryMenuModel entry = entryList[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                      child: MainNavButton(
                        text: entry.text,
                        isHover: form.menuSelect == index,
                        onPressed: entry.onPressed,
                        menuVisible: menuVisible,
                        theme: form.user.theme,
                      ),
                    );
                  },
                ))
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:axol_inventarios/utilities/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/drawer_box.dart';
import '../../../utilities/widgets/textfield.dart';
import '../../axol_widget/generic/view/axol_widget.dart';
import '../cubit/set_module_drawer/set_module_drawer_cubit.dart';
import '../cubit/set_module_drawer/set_module_drawer_state.dart';
import '../model/set_module_drawer_form_model.dart';

class SetModuleDrawer extends AxolWidget {
  const SetModuleDrawer({super.key, super.theme});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SetModuleDrawerCubit()),
        BlocProvider(create: (_) => SetModuleDrawerForm()),
      ],
      child: SetModuleDrawerBuild(theme: theme),
    );
  }
}

class SetModuleDrawerBuild extends AxolWidget {
  const SetModuleDrawerBuild({super.key, super.theme});

  @override
  Widget build(BuildContext context) {
    SetModuleDrawerFormModel form = context.read<SetModuleDrawerForm>().state;
    return BlocConsumer<SetModuleDrawerCubit, SetModuleDrawerState>(
      builder: (context, state) {
        if (state is LoadingSetModuleDrawerState) {
          return setModuleDrawer(context, form, true);
        } else if (state is LoadedSetModuleDrawerState) {
          return setModuleDrawer(context, form, false);
        } else {
          return setModuleDrawer(context, form, false);
        }
      },
      listener: (context, state) {},
    );
  }

  Widget setModuleDrawer(
      BuildContext context, SetModuleDrawerFormModel form, bool isLoading) {
    return DrawerBox(
      theme: theme,
      header: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text('Edición de módulo', style: Typo.subtitle(theme ?? 0)),
          ),
          Divider(
            color: ColorTheme.item30(theme ?? 0),
            height: 0,
          )
        ],
      ),
      actions: [
        SecondaryButton(
          text: 'Cancelar',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          theme: theme,
          onPressed: () {},
        ),
        PrimaryButton(
          text: 'Guardar',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          theme: theme,
          onPressed: () {},
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
                    style: Typo.body(theme ?? 0),
                  )),
              Expanded(
                flex: 3,
                child: PrimaryTextField(
                  controller: form.ctrlName,
                  theme: theme ?? 0,
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
                    style: Typo.body(theme ?? 0),
                  )),
              Expanded(
                flex: 3,
                child: PrimaryTextField(
                  controller: form.ctrlIcon,
                  theme: theme ?? 0,
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: ColorTheme.item30(theme ?? 0),
          height: 0,
        )
      ],
    );
  }
}

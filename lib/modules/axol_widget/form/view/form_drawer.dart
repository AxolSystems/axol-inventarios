import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/drawer_box.dart';
import '../../generic/view/axol_widget.dart';
import '../cubit/form_cubit.dart';

class FormDrawer extends AxolWidget {
  const FormDrawer({super.key, super.theme});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FormCubit()),
        BlocProvider(create: (_) => FormForm()),
      ],
      child: FormDrawerBuild(
        theme: theme,
      ),
    );
  }
}

class FormDrawerBuild extends AxolWidget {
  const FormDrawerBuild({super.key, super.theme});

  @override
  Widget build(BuildContext context) {
    final int theme_ = theme ?? 0;
    return BlocConsumer(
      listener: (context, state) {},
      builder: (context, state) {
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
              //isLoading: state is SavingRowDetailsState,
              theme: theme_,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              text: 'Aplicar',
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }
}

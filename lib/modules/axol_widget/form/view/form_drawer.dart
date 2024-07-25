import 'package:axol_inventarios/modules/widget_link/model/widgetlink_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/button.dart';
import '../../../../utilities/widgets/drawer_box.dart';
import '../../../../utilities/widgets/textfield.dart';
import '../../../entity/model/entity_model.dart';
import '../../generic/view/axol_widget.dart';
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
        if (state is ErrorFormState) {}
      },
      builder: (context, state) {
        List<Widget> widgetList = [];

        for (FormFieldModel field in form.fields) {
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
              //isLoading: state is SavingRowDetailsState,
              theme: theme_,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              text: 'Guardar',
              onPressed: () {},
            ),
          ],
          children: widgetList,
        );
      },
    );
  }
}

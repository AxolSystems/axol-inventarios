import 'package:axol_inventarios/modules/waybill/cubit/wb_add/wb_bottomsheet_find_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/theme/theme.dart';
import '../model/wb_bottomsheet_find_form_model.dart';

class WbAddBottomsheetFind extends StatelessWidget {
  const WbAddBottomsheetFind({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WbBottomSheetFindCubit()),
        BlocProvider(create: (_) => WbBottomSheetFindForm()),
      ],
      child: const WbAddBottomsheetFindBuild(),
    );
  }
}

class WbAddBottomsheetFindBuild extends StatelessWidget {
  const WbAddBottomsheetFindBuild({super.key});

  @override
  Widget build(BuildContext context) {
    WbBottomSheetFindFormModel form = context.read<WbBottomSheetFindForm>().state;
    return BlocConsumer<WbBottomSheetFindCubit, WbBottomSheetFindState>(
      bloc: context.read<WbBottomSheetFindCubit>()..load(form),
      builder: (context, state) {
        if (state == WbBottomSheetFindState.loading) {
          return wbAddBottomsheetFind(context, true, form);
        } else if (state == WbBottomSheetFindState.load) {
          return wbAddBottomsheetFind(context, false, form);
        } else {
          return wbAddBottomsheetFind(context, false, form);
        }
      },
      listener: (context, state) {
        if (state == WbBottomSheetFindState.error) {
          showDialog(context: context, builder: builder)
        }
      },
    );
  }

  Widget wbAddBottomsheetFind(
    BuildContext context,
    bool isLoading,
    WbBottomSheetFindFormModel form,
  ) {
    final double heightScreen = MediaQuery.of(context).size.height;
    return SizedBox(
      height: heightScreen * 0.7,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffix: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: ColorPalette.lightItems10,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

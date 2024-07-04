import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/textfield_form_model.dart';
import '../../../../utilities/widgets/drawer_find.dart';
import '../cubit/vendor_find/vendor_find_cubit.dart';

class VendorDrawerFind extends StatelessWidget {
  const VendorDrawerFind({super.key});

  @override
  Widget build(BuildContext context) {
    const String lblText = 'Vendedor';
    return BlocBuilder<VendorFindCubit, DrawerFindState>(
      bloc: context.read<VendorFindCubit>()..load(''),
      builder: (context, state) {
        if (state is LoadingDrawerFindState) {
          return const DrawerFind(
            lblText: lblText,
            listData: [],
            isLoading: true,
          );
        } else if (state is LoadedDrawerFindState) {
          return DrawerFind(
            lblText: lblText,
            onPressed: () {
              context.read<FinderForm>().setForm(TextfieldFormModel.empty());
              context.read<VendorFindCubit>().load('');
            },
            onSubmitted: (value) {
              context.read<VendorFindCubit>().load(value);
            },
            listData: state.dataList,
          );
        } else {
          return const DrawerFind(
            lblText: lblText,
            listData: [],
          );
        }
      },
    );
  }
}
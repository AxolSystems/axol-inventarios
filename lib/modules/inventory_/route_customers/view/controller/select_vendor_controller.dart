import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/textfield_model.dart';
import '../../../../../utilities/theme/theme.dart';
import '../../cubit/vendor_select_cubit/vendor_select_cubit.dart';
import '../../cubit/vendor_select_cubit/vendor_select_state.dart';
import '../widgets/drawer_select_vendor/drawer_select_vendor.dart';

class SelectVendorController extends StatelessWidget {
  const SelectVendorController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VendorSelectCubit, VendorSelectState>(
      bloc: context.read<VendorSelectCubit>()..load(TextfieldModel.empty()),
      builder: (context, state) {
        if (state is LoadingState) {
          return DrawerSelectVendor(
            finder: state.textfieldFinder,
            isLoading: true,
            listData: const [],
          );
        } else if (state is LoadedState) {
          return DrawerSelectVendor(
            finder: state.textfieldFinder,
            isLoading: false,
            listData: state.vendorList,
          );
        } else if (state is ErrorState) {
          return Text(
            state.error,
            style: Typo.labelText1,
          );
        }
        return Container();
      },
    );
  }
}

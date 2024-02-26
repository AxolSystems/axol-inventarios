import 'package:axol_inventarios/utilities/navigation_utilities.dart';
import 'package:axol_inventarios/utilities/widgets/appbar_axol.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/inventory_row_model.dart';
import '../../../../utilities/theme/theme.dart';
import '../../../../utilities/widgets/table_view/tableview_form.dart';
import '../cubit/inventory_list/inventory_list_cubit.dart';
import '../cubit/inventory_list/inventory_list_state.dart';

class InventoryList extends StatelessWidget {
  const InventoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => InventoryListCubit()),
        BlocProvider(create: (_) => TableViewFormCubit()),
      ],
      child: const InventoryListBuild(),
    );
  }
}

class InventoryListBuild extends StatelessWidget {
  const InventoryListBuild({super.key});

  @override
  Widget build(BuildContext context) {
    TableViewFormModel form = context.read<TableViewFormCubit>().state;
    return BlocConsumer<InventoryListCubit, InventoryListState>(
      builder: (context, state) {
        if (state is LoadingInventoryListState) {
          return inventoryList(context, true, []);
        } else if (state is LoadedInventoryListState) {
          return inventoryList(context, false, state.inventoryRowList);
        } else {
          return inventoryList(context, false, []);
        }
      },
      listener: (context, state) {},
    );
  }

  Widget inventoryList(BuildContext context, bool isLoading,
      List<InventoryRowModel> inventoryRowList) {
    return Scaffold(
      backgroundColor: ColorPalette.darkBackground,
      appBar: AppBarAxol(
        title: 'Inventario',
        isLoading: isLoading,
      ).appBarAxol(),
    ); 
    Row(
      children: [
        NavigationUtilities.emptyNavRailReturn(),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}

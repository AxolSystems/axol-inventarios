import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/widgets/drawer_find.dart';
import '../cubit/customer_find/customer_find_cubit.dart';
import '../model/customer_find_form_model.dart';

class CustomerDrawerFind extends StatelessWidget {
  const CustomerDrawerFind({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(providers: [
        BlocProvider(create: (_) => CustomerFindCubit()),
        BlocProvider(create: (_) => CustomerFindForm()),
        BlocProvider(create: (_) => FinderForm()),
      ], child: const CustomerDrawerFindBuild());
}

class CustomerDrawerFindBuild extends StatelessWidget {
  const CustomerDrawerFindBuild({super.key});

  @override
  Widget build(BuildContext context) {
    CustomerFindFormModel form = context.read<CustomerFindForm>().state;
    //CustomerFindFormModel form = CustomerFindFormModel.empty();
    const String lblText = 'Cliente';
    return BlocBuilder<CustomerFindCubit, DrawerFindState>(
      bloc: context.read<CustomerFindCubit>()..initLoad(form),
      builder: (context, state) {
        if (state is LoadingDrawerFindState) {
          return DrawerFind(
            textController: form.finder,
            lblText: lblText,
            listData: const [],
            isLoading: true,
          );
        } else if (state is LoadedDrawerFindState) {
          return DrawerFind(
            textController: form.finder,
            lblText: lblText,
            onPressed: () {
              //context.read<Customer>().setForm(TextfieldFormModel.empty());
              form.finder.text = '';
              context.read<CustomerFindCubit>().load(form, true);
            },
            onSubmitted: (value) {
              form.finder.text = value;
              context.read<CustomerFindCubit>().load(form, true);
            },
            listData: state.dataList,
            currentPage: form.currentPage,
            totalPages: form.totalPages,
            totalReg: form.totalReg,
            onPressedNext: () {
              if (form.currentPage < form.totalPages) {
                form.currentPage = form.currentPage + 1;
                context.read<CustomerFindCubit>().load(form, false);
              }
            },
            onPressedPrev: () {
              if (form.currentPage > 1) {
                form.currentPage = form.currentPage - 1;
                context.read<CustomerFindCubit>().load(form, false);
              }
            },
          );
        } else {
          return DrawerFind(
            textController: form.finder,
            lblText: lblText,
            listData: const [],
          );
        }
      },
    );
  }
}

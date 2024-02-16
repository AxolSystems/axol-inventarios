import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../user/model/user_mdoel.dart';
import '../../../cubit/movement_filter/movement_filter_cubit.dart';
import '../../../model/movement_filter_model.dart';

/*class DropdownUsers extends StatelessWidget {
  final MovementFilterModel filters;

  const DropdownUsers({super.key, required this.filters});

  @override
  Widget build(BuildContext context) {
    final UserModel userValue;
    final int i;
    if (filters.usersList.contains(filters.user)) {
      userValue = filters.user;
    } else {
      i = filters.usersList
          .indexWhere((element) => element.name == filters.user.name);
      if (i > -1) {
        userValue = filters.usersList.elementAt(i);
      } else {
        userValue = filters.usersList.last;
      }
    }
    return SizedBox(
      width: 250,
      height: 40,
      child: DropdownButton(
        isExpanded: true,
        value: userValue,
        items: filters.usersList.map((e) {
          return DropdownMenuItem(value: e, child: Text(e.name));
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            context.read<MovementFiltersCubit>().changeUser(filters, value);
          }
        },
      ),
    );
  }
}*/

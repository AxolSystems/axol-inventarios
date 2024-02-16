import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../inventory/model/inventory_move/concept_move_model.dart';
import '../../../cubit/movement_filter/movement_filter_cubit.dart';
import '../../../model/movement_filter_model.dart';

/*class DropdownConcepts extends StatelessWidget {
  final MovementFilterModel filters;

  const DropdownConcepts({super.key, required this.filters});

  @override
  Widget build(BuildContext context) {
    final ConceptMoveModel conceptValue;
    final int i;
    if (filters.conceptsList.contains(filters.concept)) {
      conceptValue = filters.concept;
    } else {
      i = filters.conceptsList
          .indexWhere((element) => element.id == filters.concept.id);
      if (i > -1) {
        conceptValue = filters.conceptsList.elementAt(i);
      } else {
        conceptValue = filters.conceptsList.last;
      }
    }
    return SizedBox(
      width: 250,
      height: 40,
      child: DropdownButton(
        isExpanded: true,
        value: conceptValue,
        items: filters.conceptsList.map((e) {
          return DropdownMenuItem(value: e, child: Text(e.text));
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            context.read<MovementFiltersCubit>().changeConcept(filters, value);
          }
        },
      ),
    );
  }
}*/

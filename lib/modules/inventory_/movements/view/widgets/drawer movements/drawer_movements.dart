import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/movement_filters/movement_filters_cubit.dart';
import '../../../model/movement_filter_model.dart';
import 'dropdown_concepts.dart';
import 'dropdown_users.dart';
import 'dropdown_warehouses.dart';
import 'textfield_select_limit.dart';

/*class DrawerMovements extends StatelessWidget {
  final MovementFilterModel filters;
  const DrawerMovements({super.key, required this.filters});

  @override
  Widget build(BuildContext context) {
    DateTime startTime;
    DateTime endTime;
    String textDate;
    bool allDates;
    if (filters.date[0]!.year == 0) {
      allDates = true;
      textDate = 'HASTA HOY';
    } else {
      if (filters.date[0] == filters.date[1]) {
        textDate =
            '${filters.date[0]!.day}/${filters.date[0]!.month}/${filters.date[0]!.year}';
      } else {
        textDate =
            '${filters.date[0]!.day}/${filters.date[0]!.month}/${filters.date[0]!.year} -> ${filters.date[1]!.day}/${filters.date[1]!.month}/${filters.date[1]!.year}';
      }
      allDates = false;
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Center(
            child: Text('Filtros'),
          ),
          Expanded(
              child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Almacén:'),
                  DropdownWarehouses(
                    filters: filters,
                    mode: 0,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Fecha:'),
                  Column(children: [
                    Text(textDate),
                    Row(
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              ).then((value) {
                                if (value != null) {
                                  startTime = DateTime(
                                      value.year, value.month, value.day);
                                  endTime = DateTime(value.year, value.month,
                                      value.day, 23, 59, 59, 999);
                                  context
                                      .read<MovementFiltersCubit>()
                                      .changeDate(
                                          filters, {0: startTime, 1: endTime});
                                }
                              });
                            },
                            child: const Text('Fecha')),
                        OutlinedButton(
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              ).then((value) {
                                if (value != null) {
                                  startTime = startTime = DateTime(
                                      value.year, value.month, value.day);
                                  context
                                      .read<MovementFiltersCubit>()
                                      .changeDate(filters,
                                          {0: value, 1: DateTime.now()});
                                }
                              });
                            },
                            child: const Text('Fecha inicial')),
                        OutlinedButton(
                            onPressed: () {
                              showDateRangePicker(
                                context: context,
                                firstDate: DateTime(DateTime.now().year - 10),
                                lastDate: DateTime.now(),
                              ).then((value) {
                                if (value != null) {
                                  startTime = DateTime(value.start.year,
                                      value.start.month, value.start.day);
                                  endTime = DateTime(
                                      value.end.year,
                                      value.end.month,
                                      value.end.day,
                                      23,
                                      59,
                                      59,
                                      999);
                                  context
                                      .read<MovementFiltersCubit>()
                                      .changeDate(
                                          filters, {0: startTime, 1: endTime});
                                }
                              });
                            },
                            child: const Text('Rango')),
                        Switch(
                            value: allDates,
                            onChanged: (value) {
                              if (value) {
                                context.read<MovementFiltersCubit>().changeDate(
                                    filters,
                                    {0: DateTime(0), 1: DateTime(3000)});
                              } else {
                                /*textDate =
                                    '${timeNow.day}/${timeNow.month}/${timeNow.year}';*/
                                context
                                    .read<MovementFiltersCubit>()
                                    .changeDate(filters, {
                                  0: DateTime(DateTime.now().year,
                                      DateTime.now().month, DateTime.now().day),
                                  1: DateTime.now()
                                });
                              }
                            }),
                      ],
                    )
                  ]),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Concepto:'),
                  DropdownConcepts(
                    filters: filters,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Encargado de almacén:'),
                  DropdownUsers(
                    filters: filters,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Limite:'),
                  TextfieldSelectLimit(filter: filters),
                ],
              ),
            ],
          )),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context, filters);
                },
                child: const Text('Aceptar'),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              OutlinedButton(
                onPressed: () {
                  context
                      .read<MovementFiltersCubit>()
                      .getInitialValues(MovementFilterModel.initialValue());
                },
                child: const Text('Reiniciar'),
              )
            ],
          )
        ],
      ),
    );
  }
}*/

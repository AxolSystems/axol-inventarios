import 'package:axol_inventarios/modules/inventory_/movements/view/widgets/toolbar_movements.dart';
import 'package:flutter/material.dart';

import '../../../../../models/textfield_model.dart';
import '../../../../../utilities/theme/theme.dart';
import '../../model/movement_filter_model.dart';
import '../../model/movement_model.dart';
import 'drawer_details_movements.dart';
import 'textfield_finder_movement.dart';

/*class ListviewMovements extends StatelessWidget {
  final List<MovementModel> movementsList;
  final TextfieldModel finder;
  final MovementFilterModel filters;
  final int mode;

  const ListviewMovements(
      {super.key,
      required this.movementsList,
      required this.finder,
      required this.filters,
      required this.mode});

  @override
  Widget build(BuildContext context) {
    Column contain;
    int i;
    int i2;
    List<MovementModel> sortMovements = movementsList;
    if (mode == 1) {
      sortMovements.sort(
        (a, b) {
          i = a.warehouse.compareTo(b.warehouse);
          if (i == 0) {
            i2 = a.code.compareTo(b.code);
            if (i2 == 0) {
              return a.time.millisecondsSinceEpoch
                  .compareTo(b.time.millisecondsSinceEpoch);
            }
            return i2;
          }
          return i;
        },
      );
      contain = Column(
        children: [
          TextfieldFinderMovement(
            filters: filters,
            isLoading: false,
            currentFinder: finder,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  'Almacén',
                  style: Typo.bodyText5,
                )),
              ),
              Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  'Documento',
                  style: Typo.bodyText5,
                )),
              ),
              Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  'Clave',
                  style: Typo.bodyText5,
                )),
              ),
              Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  'Descripción',
                  style: Typo.bodyText5,
                )),
              ),
              Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  'Concepto',
                  style: Typo.bodyText5,
                )),
              ),
              Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  'Fecha',
                  style: Typo.bodyText5,
                )),
              ),
              Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  'Cantidad',
                  style: Typo.bodyText5,
                )),
              ),
              Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  'Existencias',
                  style: Typo.bodyText5,
                )),
              ),
            ],
          ),
          Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            itemCount: sortMovements.length,
            itemBuilder: (context, index) {
              //double stock = 0;
              final movement = sortMovements[index];
              /*for (int i = 0; i <= index; i++) {
                if (movementsList.elementAt(i).conceptType == 0) {
                  stock = stock + movementsList.elementAt(i).quantity;
                } else if (movementsList.elementAt(i).conceptType == 1) {
                  stock = stock - movementsList.elementAt(i).quantity;
                }
              }*/
              return Container(
                height: 30,
                width: double.infinity,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black45)),
                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          DrawerDetailsMovements(movement: movement),
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        //1) Warehouse
                        flex: 1,
                        child: Center(
                          child: Text(
                            movement.warehouse,
                            style: Typo.labelText1,
                          ),
                        ),
                      ),
                      Expanded(
                        // 2) Document
                        flex: 1,
                        child: Center(
                          child: Text(
                            movement.document,
                            style: Typo.labelText1,
                          ),
                        ),
                      ),
                      Expanded(
                        // 3) Code
                        flex: 1,
                        child: Center(
                          child: Text(
                            movement.code,
                            style: Typo.labelText1,
                          ),
                        ),
                      ),
                      Expanded(
                        // 4) Description
                        flex: 1,
                        child: Center(
                          child: Text(
                            movement.description,
                            style: Typo.labelText1,
                          ),
                        ),
                      ),
                      Expanded(
                        // 5) Concept
                        flex: 1,
                        child: Center(
                          child: Text(
                            movement.concept.toString(),
                            style: Typo.labelText1,
                          ),
                        ),
                      ),
                      Expanded(
                        // 6) Date
                        flex: 1,
                        child: Center(
                          child: Text(
                            '${movement.time.day}/${movement.time.month}/${movement.time.year}',
                            style: Typo.labelText1,
                          ),
                        ),
                      ),
                      Expanded(
                        // 7) Quantity
                        flex: 1,
                        child: Center(
                          child: Text(
                            movement.conceptType == 0
                                ? movement.quantity.toString()
                                : '-${movement.quantity}',
                            style: Typo.labelText1,
                          ),
                        ),
                      ),
                      Expanded(
                        // 7) Quantity
                        flex: 1,
                        child: Center(
                          child: Text(
                            movement.stock.toString(),
                            style: Typo.labelText1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ))
        ],
      );
    } else {
      contain = Column(
        children: [
          TextfieldFinderMovement(
            filters: filters,
            isLoading: true,
            currentFinder: finder,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  'Almacén',
                  style: Typo.bodyText5,
                )),
              ),
              Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  'Documento',
                  style: Typo.bodyText5,
                )),
              ),
              Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  'Clave',
                  style: Typo.bodyText5,
                )),
              ),
              Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  'Descripción',
                  style: Typo.bodyText5,
                )),
              ),
              Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  'Concepto',
                  style: Typo.bodyText5,
                )),
              ),
              Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  'Fecha',
                  style: Typo.bodyText5,
                )),
              ),
              Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  'Cantidad',
                  style: Typo.bodyText5,
                )),
              ),
            ],
          ),
          Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            itemCount: movementsList.length,
            itemBuilder: (context, index) {
              final movement = movementsList[index];
              return Container(
                height: 30,
                width: double.infinity,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black45)),
                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          DrawerDetailsMovements(movement: movement),
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        //1) Warehouse
                        flex: 1,
                        child: Center(
                          child: Text(
                            movement.warehouse,
                            style: Typo.labelText1,
                          ),
                        ),
                      ),
                      Expanded(
                        // 2) Document
                        flex: 1,
                        child: Center(
                          child: Text(
                            movement.document,
                            style: Typo.labelText1,
                          ),
                        ),
                      ),
                      Expanded(
                        // 3) Code
                        flex: 1,
                        child: Center(
                          child: Text(
                            movement.code,
                            style: Typo.labelText1,
                          ),
                        ),
                      ),
                      Expanded(
                        // 4) Description
                        flex: 1,
                        child: Center(
                          child: Text(
                            movement.description,
                            style: Typo.labelText1,
                          ),
                        ),
                      ),
                      Expanded(
                        // 5) Concept
                        flex: 1,
                        child: Center(
                          child: Text(
                            movement.concept.toString(),
                            style: Typo.labelText1,
                          ),
                        ),
                      ),
                      Expanded(
                        // 6) Date
                        flex: 1,
                        child: Center(
                          child: Text(
                            '${movement.time.day}/${movement.time.month}/${movement.time.year}',
                            style: Typo.labelText1,
                          ),
                        ),
                      ),
                      Expanded(
                        // 7) Quantity
                        flex: 1,
                        child: Center(
                          child: Text(
                            movement.quantity.toString(),
                            style: Typo.labelText1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ))
        ],
      );
    }
    return Row(
      children: [
        Expanded(
          child: contain,
        ),
        ToolbarMovements(
          isLoading: false,
          currentFilter: filters,
          movementsList: movementsList,
          mode: mode,
        ),
      ],
    );
  }
}*/

import '../../../../models/textfield_form_model.dart';
import '../../inventory/model/warehouse_model.dart';

class MovementFilterFormModel {
  TextfieldFormModel tfWarehose;
  List<WarehouseModel> warehouseList;
  DateTime intDate;
  DateTime endDate;
  bool filterDate;

  MovementFilterFormModel({
    required this.tfWarehose,
    required this.warehouseList,
    required this.intDate,
    required this.endDate,
    required this.filterDate,
  });

  MovementFilterFormModel.empty()
  : tfWarehose = TextfieldFormModel.empty(),
  warehouseList = [],
  filterDate = false,
  intDate = DateTime(0),
  endDate = DateTime(3000);

}

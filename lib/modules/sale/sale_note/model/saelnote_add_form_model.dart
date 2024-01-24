import '../../../../models/textfield_form_model.dart';
import '../../../inventory_/inventory/model/warehouse_model.dart';
import '../../customer/model/customer_model.dart';
import 'salenote_row_form_model.dart';

class SaleNoteAddFormModel {
  TextfieldFormModel customerTf;
  TextfieldFormModel vendorTf;
  TextfieldFormModel warehouseTf;
  int id;
  CustomerModel customer;
  WarehouseModel warehouse;
  DateTime dateTime;
  String note;
  List<SaleNoteRowFormModel> productList;

  final String _emInvalidData = 'Dato invalido';

  String get emInvalidData => _emInvalidData;

  SaleNoteAddFormModel({
    required this.customerTf,
    required this.vendorTf,
    required this.warehouseTf,
    required this.productList,
    required this.customer,
    required this.dateTime,
    required this.id,
    required this.warehouse,
    required this.note,
  });

  SaleNoteAddFormModel.empty()
      : customerTf = TextfieldFormModel.empty(),
        vendorTf = TextfieldFormModel.empty(),
        warehouseTf = TextfieldFormModel.empty(),
        productList = [],
        customer = CustomerModel.empty(),
        warehouse = WarehouseModel.empty(),
        dateTime = DateTime.now(),
        id = -1,
        note = '';

  static const String pCustomer = 'customer';
  static const String pVendor = 'vendor';
  static const String pWarehouse = 'warehouse';
  static const String pCustomerModel = 'customerModel';
  static const String pVendorModel = 'vendorModel';
  static const String pWarehouseModel = 'warehouseModel';
}

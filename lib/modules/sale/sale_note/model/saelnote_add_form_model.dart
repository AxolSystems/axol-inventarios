import '../../../../models/textfield_form_model.dart';
import '../../customer/model/customer_model.dart';
import 'salenote_row_form_model.dart';

class SaleNoteAddFormModel {
  TextfieldFormModel customerTf;
  TextfieldFormModel vendorTf;
  TextfieldFormModel warehouseTf;
  int id;
  CustomerModel customer;
  DateTime dateTime;
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
  });

  SaleNoteAddFormModel.empty()
      : customerTf = TextfieldFormModel.empty(),
        vendorTf = TextfieldFormModel.empty(),
        warehouseTf = TextfieldFormModel.empty(),
        productList = [],
        customer = CustomerModel.empty(),
        dateTime = DateTime.now(),
        id = -1;

  static const String pCustomer = 'customer';
  static const String pVendor = 'vendor';
  static const String pWarehouse = 'warehouse';
  static const String pCustomerModel = 'customerModel';
  static const String pVendorModel = 'vendorModel';
  static const String pWarehouseModel = 'warehouseModel';
}

import '../../../../models/textfield_form_model.dart';
import '../../../inventory_/inventory/model/warehouse_model.dart';
import '../../../user/model/user_model.dart';
import '../../customer/model/customer_model.dart';
import '../../vendor/model/vendor_model.dart';
import 'salenote_row_form_model.dart';

class SaleNoteAddFormModel {
  TextfieldFormModel customerTf;
  TextfieldFormModel vendorTf;
  TextfieldFormModel warehouseTf;
  int id;
  CustomerModel customer;
  VendorModel vendor;
  WarehouseModel warehouse;
  DateTime dateTime;
  String note;
  double total;
  List<SaleNoteRowFormModel> productList;
  UserModel user;

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
    required this.total,
    required this.vendor,
    required this.user,
  });

  SaleNoteAddFormModel.empty()
      : customerTf = TextfieldFormModel.empty(),
        vendorTf = TextfieldFormModel.empty(),
        warehouseTf = TextfieldFormModel.empty(),
        productList = [],
        customer = CustomerModel.empty(),
        vendor = VendorModel.empty(),
        warehouse = WarehouseModel.empty(),
        dateTime = DateTime.now(),
        id = -1,
        note = '',
        total = 0,
        user = UserModel.empty();

  static const String pCustomer = 'customer';
  static const String pVendor = 'vendor';
  static const String pWarehouse = 'warehouse';
  static const String pCustomerModel = 'customerModel';
  static const String pVendorModel = 'vendorModel';
  static const String pWarehouseModel = 'warehouseModel';
}

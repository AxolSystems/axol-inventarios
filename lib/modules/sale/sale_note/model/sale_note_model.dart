import '../../../inventory_/inventory/model/warehouse_model.dart';
import '../../customer/model/customer_model.dart';
import 'sale_product_model.dart';
import '../../vendor/model/vendor_model.dart';

class SaleNoteModel {
  final int id;
  final CustomerModel customer;
  final int status;
  final DateTime date;
  final double? subtotal;
  final double? iva;
  final double total;
  final WarehouseModel warehouse;
  final VendorModel vendor;
  final int type;
  final String note;
  final SaleProductModel saleProduct;

  static const String tId = 'id';
  static const String tCustomer = 'customer';
  static const String tStatus = 'status';
  static const String tDate = 'date';
  static const String tSubtotal = 'subtotal';
  static const String tIva = 'iva';
  static const String tTotal = 'total';
  static const String tWarehouse = 'warehouse';
  static const String tVendor = 'vendor';
  static const String tType = 'type';
  static const String tNote = 'note';
  static const String tSaleProduct = 'products';

  SaleNoteModel({
    required this.id,
    required this.customer,
    required this.status,
    required this.date,
    this.subtotal,
    this.iva,
    required this.total,
    required this.warehouse,
    required this.vendor,
    required this.type,
    required this.note,
    required this.saleProduct,
  });

  SaleNoteModel.empty()
      : id = -1,
        customer = CustomerModel.empty(),
        status = -1,
        date = DateTime.now(),
        subtotal = 0,
        iva = 0,
        total = 0,
        warehouse = WarehouseModel.empty(),
        vendor = VendorModel.empty(),
        type = -1,
        note = '',
        saleProduct = SaleProductModel.empty();
}

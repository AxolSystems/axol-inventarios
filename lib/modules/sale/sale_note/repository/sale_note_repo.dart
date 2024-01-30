import 'package:axol_inventarios/modules/inventory_/product/model/product_model.dart';
import 'package:axol_inventarios/modules/sale/customer/model/customer_model.dart';
import 'package:axol_inventarios/modules/sale/sale_note/model/sale_product_model.dart';
import 'package:axol_inventarios/modules/sale/vendor/model/vendor_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../inventory_/inventory/model/warehouse_model.dart';
import '../model/sale_note_model.dart';
import '../model/salenote_filter_model.dart';

class SaleNoteRepo {
  static const String _table = 'sales_notes';
  static const String _id = 'id';
  static const String _customer = 'customer';
  static const String _time = 'date';
  static const String _subtotal = 'subtotal';
  static const String _iva = 'iva';
  static const String _total = 'total';
  static const String _warehouse = 'warehouse';
  static const String _vendor = 'vendor';
  static const String _note = 'note';
  static const String _products = 'products';
  final _supabase = Supabase.instance.client;

  Future<List<SaleNoteModel>> fetchNotes(
      SaleNoteFilterModel filter, String finder) async {
    CustomerModel customer = CustomerModel.empty();
    List<SaleNoteModel> salesNotes = [];
    SaleNoteModel saleNote;
    List<Map<String, dynamic>> saleNoteDB = [];
    Map<String, dynamic> filters = {};
    String textOr;
    List<SaleProductModel> productList = [];
    SaleProductModel saleProduct;
    Map<String, dynamic> jsonbProducts;
    List mapList;
    //int filterStartDate = 0;
    //int filterEndDate = 32503708800000;

    if (filter.customer > -1) {
      filters['${SaleNoteModel.tCustomer}->>${customer.tId}'] = filter.customer;
    }
    if (filter.vendor > -1) {
      filters['${SaleNoteModel.tVendor}->>${VendorModel.empty().tId}'] =
          filter.vendor;
    }
    if (filter.warehouse > -1) {
      filters['${SaleNoteModel.tWarehouse}->>${WarehouseModel.id_}'] =
          filter.warehouse;
    }

    if (finder == '') {
      saleNoteDB =
          await _supabase.from(_table).select<List<Map<String, dynamic>>>();
      /*.match(filters)
          .lte(_time, filterEndDate)
          .gte(_time, filterStartDate);*/
    } else {
      textOr =
          '${SaleNoteModel.tCustomer}->>${customer.tName}.ilike.%$finder%,';
      textOr =
          '$textOr${SaleNoteModel.tVendor}->>${VendorModel.empty().tName}.ilike.%$finder%';
      if (double.tryParse(finder) != null) {
        textOr = '$textOr,$_id.eq.$finder';
      }
      saleNoteDB = await _supabase
          .from(_table)
          .select<List<Map<String, dynamic>>>()
          .or(textOr);
    }
    for (var element in saleNoteDB) {
      productList = [];
      jsonbProducts = element[_products];
      mapList = jsonbProducts.values.toList();
      for (Map<String, dynamic> map in mapList) {
        saleProduct = SaleProductModel(
          product:
              ProductModel.singleCode(map[SaleProductModel.empty().tProduct]),
          quantity: map[SaleProductModel.empty().tQuantity],
          price: map[SaleProductModel.empty().tPrice],
          note: map[SaleProductModel.empty().tNote],
        );
        productList.add(saleProduct);
      }
      saleNote = SaleNoteModel(
        id: element[_id],
        customer: CustomerModel.fill(element[_customer]),
        date: DateTime.fromMillisecondsSinceEpoch(element[_time]),
        total: element[_total],
        warehouse: WarehouseModel.fillMap(element[_warehouse]),
        vendor: VendorModel.fillMap(element[_vendor]),
        note: element[_note],
        saleProduct: productList,
      );
      salesNotes.add(saleNote);
    }
    return salesNotes;
  }

  Future<int> fetchAvailableId() async {
    List<Map<String, dynamic>> saleNoteIdDB = [];
    List<int> listId = [];
    int newId = -1;
    saleNoteIdDB =
        await _supabase.from(_table).select<List<Map<String, dynamic>>>(_id);
    for (var element in saleNoteIdDB) {
      listId.add(int.parse(element[_id].toString()));
    }
    listId.sort((a, b) => a.compareTo(b));
    for (int i = 0; i <= listId.length; i++) {
      if (listId.contains(i) == false) {
        listId.add(i);
        newId = i;
        i = listId.length + 1;
      }
    }
    return newId;
  }

  Future<void> insert(SaleNoteModel saleNote) async {
    final Map<String, dynamic> customerMap = {
      saleNote.customer.tId: saleNote.customer.id,
      saleNote.customer.tName: saleNote.customer.name,
      saleNote.customer.tCountry: saleNote.customer.country,
      saleNote.customer.tHood: saleNote.customer.hood,
      saleNote.customer.tIntNumber: saleNote.customer.intNumber,
      saleNote.customer.tOutNumbre: saleNote.customer.outNumber,
      saleNote.customer.tPhoneNumber: saleNote.customer.phoneNumber,
      saleNote.customer.tPostalCode: saleNote.customer.postalCode,
      saleNote.customer.tRfc: saleNote.customer.rfc,
      saleNote.customer.tStreet: saleNote.customer.street,
      saleNote.customer.tTown: saleNote.customer.town,
    };
    final Map<String, dynamic> warehouseMap = {
      saleNote.warehouse.tId: saleNote.warehouse.id,
      saleNote.warehouse.tName: saleNote.warehouse.name,
      saleNote.warehouse.tManager: saleNote.warehouse.retailManager,
    };
    final Map<String, dynamic> vendorMap = {
      saleNote.vendor.tId: saleNote.vendor.id,
      saleNote.vendor.tName: saleNote.vendor.name,
    };
    Map<String, Map<String, dynamic>> productsMap = {};
    for (int i = 0; i < saleNote.saleProduct.length; i++) {
      SaleProductModel row = saleNote.saleProduct[i];
      productsMap[i.toString()] = {
        row.tProduct: row.product.code,
        row.tQuantity: row.quantity,
        row.tPrice: row.price,
        row.tNote: row.note,
      };
    }
    await _supabase.from(_table).insert({
      _id: saleNote.id,
      _customer: customerMap,
      _time: saleNote.date.millisecondsSinceEpoch,
      _subtotal: saleNote.subtotal,
      _iva: saleNote.iva,
      _total: saleNote.total,
      _warehouse: warehouseMap,
      _vendor: vendorMap,
      _note: saleNote.note,
      _products: productsMap,
    });
  }

  Future<void> delete(SaleNoteModel saleNote) async {
    await _supabase.from(_table).delete().eq(_id, saleNote.id);
  }
}

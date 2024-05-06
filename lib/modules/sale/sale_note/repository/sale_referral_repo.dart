import 'package:axol_inventarios/models/data_response_model.dart';
import 'package:axol_inventarios/modules/inventory_/product/model/product_model.dart';
import 'package:axol_inventarios/modules/sale/customer/model/customer_model.dart';
import 'package:axol_inventarios/modules/sale/sale_note/model/sale_product_model.dart';
import 'package:axol_inventarios/modules/sale/vendor/model/vendor_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../inventory_/inventory/model/warehouse_model.dart';
import '../model/sale_note_model.dart';
import '../model/salenote_filter_model.dart';

class SaleReferralRepo {
  static const String _table = 'sales_referral';
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
  static const String _status = SaleNoteModel.tStatus;
  final _supabase = Supabase.instance.client;

  Future<DataResponseModel> fetchReferral(
      SaleFilterModel filter, String finder) async {
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
    PostgrestResponse<List<Map<String, dynamic>>> postgrestResponse;
    DataResponseModel dataResponse;
    final int rangeMin = filter.rangeMin ?? 0;
    final int rangeMax = filter.rangeMax ?? 999;

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
      postgrestResponse = await _supabase
          .from(_table)
          .select<PostgrestResponse<List<Map<String, dynamic>>>>(
              '*', const FetchOptions(count: CountOption.exact))
          .order(_time, ascending: false)
          .range(rangeMin, rangeMax);
    }
    if (finder.toLowerCase().startsWith('clave:')) {
      final List<String> list;
      final find = finder.toLowerCase().replaceFirst('clave:', '');
      if (find.contains('-')) {
        list = find.split('-');
        if (list.length == 2) {
          postgrestResponse = await _supabase
              .from(_table)
              .select<PostgrestResponse<List<Map<String, dynamic>>>>(
                  '*', const FetchOptions(count: CountOption.exact))
              .gte(_id, list.first)
              .lte(_id, list.last)
              .order(_time, ascending: false)
              .range(rangeMin, rangeMax);
        } else {
          postgrestResponse = const PostgrestResponse(data: null, status: 0);
        }
      } else if (find.contains(',')) {
        list = find.split(',');
        postgrestResponse = await _supabase
            .from(_table)
            .select<PostgrestResponse<List<Map<String, dynamic>>>>(
                '*', const FetchOptions(count: CountOption.exact))
            .in_(_id, list)
            .order(_time, ascending: false)
            .range(rangeMin, rangeMax);
      } else {
        postgrestResponse = await _supabase
            .from(_table)
            .select<PostgrestResponse<List<Map<String, dynamic>>>>(
                '*', const FetchOptions(count: CountOption.exact))
            .eq(_id, find)
            .order(_time, ascending: false)
            .range(rangeMin, rangeMax);
      }
    } else {
      textOr =
          '${SaleNoteModel.tCustomer}->>${customer.tName}.ilike.%$finder%,';
      textOr =
          '$textOr${SaleNoteModel.tVendor}->>${VendorModel.empty().tName}.ilike.%$finder%';
      if (double.tryParse(finder) != null) {
        textOr = '$textOr,$_id.eq.$finder';
      }
      postgrestResponse = await _supabase
          .from(_table)
          .select<PostgrestResponse<List<Map<String, dynamic>>>>(
              '*', const FetchOptions(count: CountOption.exact))
          .or(textOr)
          .order(_time, ascending: false)
          .range(rangeMin, rangeMax);
    }
    saleNoteDB = postgrestResponse.data ?? [];
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
        status: element[_status],
        saleProduct: productList,
      );
      salesNotes.add(saleNote);
    }
    dataResponse = DataResponseModel(
      dataList: salesNotes,
      count: postgrestResponse.count ?? 0,
    );
    return dataResponse;
  }

  Future<int> fetchAvailableId() async {
    List<Map<String, dynamic>> saleNoteIdDB = [];
    int newId = -1;
    saleNoteIdDB = await _supabase
        .from(_table)
        .select<List<Map<String, dynamic>>>(_id)
        .order(_id)
        .limit(1);
    if (saleNoteIdDB.isNotEmpty) {
      newId = int.tryParse(saleNoteIdDB.first[_id].toString()) ?? -1;
      if (newId > -1) {
        newId++;
      }
    }
    return newId;
  }

  Future<int> insert(SaleNoteModel saleNote) async {
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
    final int id = await fetchAvailableId();
    await _supabase.from(_table).insert({
      _id: id,
      _customer: customerMap,
      _time: saleNote.date.millisecondsSinceEpoch,
      _subtotal: saleNote.subtotal,
      _iva: saleNote.iva,
      _total: saleNote.total,
      _warehouse: warehouseMap,
      _vendor: vendorMap,
      _note: saleNote.note,
      _status: saleNote.status,
      _products: productsMap,
    });
    if (id == saleNote.id) {
      return -1;
    } else {
      return id;
    }
  }

  Future<void> delete(SaleNoteModel saleNote) async {
    await _supabase.from(_table).delete().eq(_id, saleNote.id);
  }

  Future<void> cancelReferral(SaleNoteModel saleNote) async {
    await _supabase.from(_table).update({_status: 0}).eq(_id, saleNote.id);
  }

  Future<int> countRecords() async {
    PostgrestResponse dataDB;

    dataDB = await _supabase
        .from(_table)
        .select('*', const FetchOptions(count: CountOption.exact));
    return dataDB.count ?? 0;
  }
}

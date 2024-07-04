import 'package:axol_inventarios/modules/sale/customer/model/customer_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../models/data_response_model.dart';

class CustomerRepo {
  final String _table = 'customers';
  final String _id = CustomerModel.empty().tId;
  final String _name = CustomerModel.empty().tName;
  final String _rfc = CustomerModel.empty().tRfc;
  final String _street = CustomerModel.empty().tStreet;
  final String _outNumber = CustomerModel.empty().tOutNumbre;
  final String _intNumber = CustomerModel.empty().tIntNumber;
  final String _hood = CustomerModel.empty().tHood;
  final String _postalCode = CustomerModel.empty().tPostalCode;
  final String _town = CustomerModel.empty().tTown;
  final String _country = CustomerModel.empty().tCountry;
  final String _phoneNumber = CustomerModel.empty().tPhoneNumber;

  final _supabase = Supabase.instance.client;

  Future<List<CustomerModel>> fetchCustomersEq(String inText) async {
    List<Map<String, dynamic>> customersDB = [];
    List<CustomerModel> customers = [];
    CustomerModel customer = CustomerModel.empty();
    //Map<String, dynamic> mapProp;
    String textOr;
    if (int.tryParse(inText) == null) {
      textOr = '$_name.eq.$inText';
    } else {
      textOr = '$_id.eq.$inText';
    }
    customersDB = await _supabase
        .from(_table)
        .select<List<Map<String, dynamic>>>()
        .or(textOr);
    //.or('$_id.eq.$inText,$_name.eq.$inText');
    if (customersDB.isNotEmpty) {
      for (var element in customersDB) {
        //mapProp = element[_properties] ?? {};
        customer = CustomerModel(
          id: element[customer.tId],
          name: element[customer.tName],
          country: element[customer.tCountry],
          hood: element[customer.tHood],
          intNumber: element[customer.tIntNumber],
          outNumber: element[customer.tOutNumbre],
          phoneNumber: element[customer.tPhoneNumber],
          postalCode: element[customer.tPostalCode],
          rfc: element[customer.tRfc],
          street: element[customer.tStreet],
          town: element[customer.tTown],
        );
        customers.add(customer);
      }
    }
    return customers;
  }

  Future<DataResponseModel> fetchCustomersIlike(String inText,
      {int? rangeMax, int? rangeMin}) async {
    List<Map<String, dynamic>> customersDB = [];
    List<CustomerModel> customers = [];
    CustomerModel customer = CustomerModel.empty();
    PostgrestResponse<List<Map<String, dynamic>>> postgrestResponse;
    DataResponseModel dataResponse;
    final int rangeMax_ = rangeMax ?? 999;
    final int rangeMin_ = rangeMin ?? 0;

    String textOr;
    if (int.tryParse(inText) == null) {
      textOr = '$_name.ilike.%$inText%';
    } else {
      textOr = '$_id.eq.$inText';
    }
    if (inText == '') {
      postgrestResponse = await _supabase
          .from(_table)
          .select<PostgrestResponse<List<Map<String, dynamic>>>>(
            '*', const FetchOptions(count: CountOption.estimated)
          )
          .order(_id, ascending: true)
          .range(rangeMin_, rangeMax_);
    } else {
      postgrestResponse = await _supabase
          .from(_table)
          .select<PostgrestResponse<List<Map<String, dynamic>>>>(
            '*', const FetchOptions(count: CountOption.estimated)
          )
          .or(textOr)
          .order(_id, ascending: true)
          .range(rangeMin_, rangeMax_);
    }
    customersDB = postgrestResponse.data ?? [];
    if (customersDB.isNotEmpty) {
      for (var element in customersDB) {
        customer = CustomerModel(
          id: element[customer.tId],
          name: element[customer.tName],
          country: element[customer.tCountry],
          hood: element[customer.tHood],
          intNumber: element[customer.tIntNumber],
          outNumber: element[customer.tOutNumbre],
          phoneNumber: element[customer.tPhoneNumber],
          postalCode: element[customer.tPostalCode],
          rfc: element[customer.tRfc],
          street: element[customer.tStreet],
          town: element[customer.tTown],
        );
        customers.add(customer);
      }
    }
    dataResponse = DataResponseModel(
      dataList: customers,
      count: postgrestResponse.count ?? 0,
    );
    return dataResponse;
  }

  Future<int> fetchAvailableId() async {
    List<Map<String, dynamic>> customerIdDB = [];
    int newId = -1;

    customerIdDB = await _supabase
        .from(_table)
        .select<List<Map<String, dynamic>>>(_id)
        .order(_id, ascending: false)
        .limit(1);

    if (customerIdDB.isNotEmpty) {
      newId = int.tryParse(customerIdDB.first[_id].toString()) ?? -1;
      if (newId > -1) {
        newId++;
      }
    }
    return newId;
  }

  Future<bool> existId(int id) async {
    List<Map<String, dynamic>> customersDB = [];
    bool exist;
    customersDB = await _supabase
        .from(_table)
        .select<List<Map<String, dynamic>>>()
        .eq(_id, id);
    if (customersDB.isEmpty && id >= 0) {
      exist = false;
    } else {
      exist = true;
    }
    return exist;
  }

  Future<void> insertCustomer(CustomerModel customer) async {
    await _supabase.from(_table).insert({
      _id: customer.id,
      _name: customer.name,
      _phoneNumber: customer.phoneNumber,
      _country: customer.country,
      _hood: customer.hood,
      _intNumber: customer.intNumber,
      _outNumber: customer.outNumber,
      _postalCode: customer.postalCode,
      _rfc: customer.rfc,
      _street: customer.street,
      _town: customer.town,
    });
  }

  Future<void> delete(CustomerModel customer) async {
    await _supabase.from(_table).delete().eq(_id, customer.id);
  }

  Future<int> countRecords() async {
    PostgrestResponse dataDB;

    dataDB = await _supabase
        .from(_table)
        .select('*', const FetchOptions(count: CountOption.exact));
    return dataDB.count ?? 0;
  }
}

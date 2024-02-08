import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/product_model.dart';
import '../model/product_response_model.dart';

class ProductRepo {
  static const String _table = 'products';
  static const String _code = 'code';
  static const String _properties = 'attributes';
  static const String _description = 'description';
  static const String _class = 'class';
  static const String _type = 'type';
  static const String _gauge = 'gauge';
  static const String _pieces = 'pices';
  static const String _weight = 'weight';
  static const String _measure = 'measure';
  static const String _packing = 'packing';
  static const String _capacity = 'capacity';

  final _supabase = Supabase.instance.client;

  Future<List<ProductModel>> fetchProductList(List<String> codeList) async {
    //Map<String, dynamic> properties;
    List<ProductModel> products = [];
    ProductModel product;
    //List<Map<String, dynamic>> newList = [];
    List<Map<String, dynamic>> productsDB = [];

    productsDB = await _supabase
        .from(_table)
        .select<List<Map<String, dynamic>>>()
        .in_(_code, codeList);

    if (productsDB.isNotEmpty) {
      for (var element in productsDB) {
        product = ProductModel(
          code: element[_code],
          description: element[_description] ?? '',
          properties: element[_properties],
          class_: element[_class],
        );
        products.add(product);
      }
      //newList.add(properties[_product]);
      //element[PRODUCTO] --> {code: Map<String, dynamic>}
    }
    return products;
  }

  Future<ProductModel?> fetchProduct(String code) async {
    List<Map<String, dynamic>> products;
    Map<String, dynamic> productDB;
    ProductModel? product;

    products = await _supabase
        .from(_table)
        .select<List<Map<String, dynamic>>>()
        .eq(_code, code);
    if (products.isNotEmpty) {
      productDB = products.first;
      product = ProductModel(
        code: productDB[_code],
        description: productDB[_description],
        class_: productDB[_class],
        capacity: productDB[_properties][_capacity],
        gauge: double.parse(productDB[_properties][_gauge]),
        measure: productDB[_properties][_measure],
        packing: productDB[_properties][_packing],
        pieces: productDB[_properties][_pieces],
        type: productDB[_properties][_type],
        weight: double.parse(productDB[_properties][_weight]),
      );
    } else {
      productDB = {};
      product = null;
    }

    return product;
  }

  Future<ProductModel?> fetchProductByCode(String code) async {
    ProductModel? product;
    List<Map<String, dynamic>> productsDB;

    productsDB = await _supabase
        .from(_table)
        .select<List<Map<String, dynamic>>>()
        .eq(_code, code);

    if (productsDB.length == 1) {
      product = ProductModel(
        code: productsDB.single[_code],
        description: productsDB.single[_description] ?? '',
        properties: productsDB.single[_properties],
        class_: productsDB.single[_class],
      );
    } else {
      product = null;
    }

    return product;
  }

  Future<List<ProductModel>> fetchAllProducts() async {
    ProductModel product;
    List<ProductModel> products = [];
    List<Map<String, dynamic>> productsDB;
    productsDB =
        await _supabase.from(_table).select<List<Map<String, dynamic>>>();
    if (productsDB.isNotEmpty) {
      for (var element in productsDB) {
        product = ProductModel(
          code: element[_code],
          description: element[_description] ?? '',
          properties: element[_properties] ?? ProductModel.empty().properties,
          class_: element[_class],
        );
        products.add(product);
      }
    }
    return products;
  }

  Future<List<ProductResponseModel>> fetchProductFinder(String finder,
      {int? rangeMin, int? rangeMax}) async {
    ProductModel product;
    ProductResponseModel productResponse;
    final List<Map<String, dynamic>> productsDB;
    PostgrestResponse<List<Map<String, dynamic>>> postgrestResponseDB;
    final int rangeMin_ = rangeMin ?? 0;
    final int rangeMax_ = rangeMax ?? 0;

    postgrestResponseDB = await _supabase
        .from(_table)
        .select<PostgrestResponse<List<Map<String, dynamic>>>>(
            '*', const FetchOptions(count: CountOption.exact))
        .or('$_code.ilike.%$finder%,$_description.ilike.%$finder%')
        .order(_code, ascending: true)
        .range(rangeMin_, rangeMax_);

    productsDB = postgrestResponseDB.data ?? [];

    if (productsDB.isNotEmpty) {
      for (var element in productsDB) {
        product = ProductModel(
          code: element[_code],
          description: element[_description] ?? '',
          properties: element[_properties],
          class_: element[_class],
        );
        products.add(product);
      }
    }
    return products;
  }

  Future<void> insertProduct(ProductModel product) async {
    await _supabase.from(_table).insert({
      _code: product.code,
      _description: product.description,
      _properties: product.properties,
    });
  }

  Future<void> updateProduct(ProductModel product) async {
    await _supabase.from(_table).update({
      _description: product.description,
      _properties: product.properties,
    }).eq(_code, product.code);
  }

  Future<void> deleteProduct(ProductModel product) async {
    await _supabase.from(_table).delete().eq(_code, product.code);
  }

  Future<int> countRecords() async {
    PostgrestResponse dataDB;

    dataDB = await _supabase
        .from(_table)
        .select('*', const FetchOptions(count: CountOption.exact));
    return dataDB.count ?? 0;
  }
}

import 'package:axol_inventarios/modules/inventory_/product/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../models/data_response_model.dart';
import '../model/inventory_model.dart';
import '../../../../models/inventory_row_model.dart';
import '../../movements/model/movement_model.dart';
import '../../product/repository/product_repo.dart';
import 'warehouses_repo.dart';

class InventoryRepo {
  //Tabla
  static const String _table = 'inventory';
  //--Columnas
  static const String _stock = 'stock';
  static const String _manager = 'retail_manager';
  static const String _code = 'code';
  static const String _name = 'name';
  static const String _id = 'uid';
  //Memoria local
  static const String _user = 'user_name';
  //Otros
  //static const String _description = 'description';
  //Instancia a la base de datos
  final _supabase = Supabase.instance.client;

  Future<List<InventoryRowModel>> getInventoryList(
      String inventoryName, String filter) async {
    List<InventoryRowModel> inventoryList = [];
    List<InventoryRowModel> finalInventoryList = [];
    InventoryRowModel inventoryRow;
    ProductModel productModel;
    List<String> codes = [];
    //Lee en la base de datos el inventario del usuario registrado.
    //y obtiene una lista de claves de las existencias en inventario.
    final List<Map<String, dynamic>> inventoryDB =
        await fetchInventory(inventoryName);
    for (Map<String, dynamic> element in inventoryDB) {
      if (double.parse(element[_stock].toString()) > 0) {
        codes.add(element[_code]);
      }
    }
    //Obtiene la lista de productos: {code: Map<String,dynamic>}
    final List<ProductModel> productsDB =
        await ProductRepo().fetchProductList(codes);
    //Llena inventoryList con iteraciones de codes y utilizando los elementos
    // de productDB e inventoryDB.
    for (String element in codes) {
      productModel = productsDB
          .elementAt(productsDB.indexWhere((value) => value.code == element));
      /*productModel = ProductModel(
          code: element,
          description: productModel.description,
          properties: productModel.properties);*/
      inventoryRow = InventoryRowModel(
        product: productModel,
        stock: double.parse(inventoryDB
            .where((value) => value[_code] == element)
            .first[_stock]
            .toString()),
        warehouseName: inventoryName,
      );
      inventoryList.add(inventoryRow);
    }
    //Filtra la lista
    if (filter != '') {
      for (var element in inventoryList) {
        if (element.product.code.contains(filter) ||
            element.product.description
                .toString()
                .contains(filter)) {
          finalInventoryList.add(element);
        }
      }
    } else {
      finalInventoryList = inventoryList;
    }
    return finalInventoryList;
  }

  Future<DataResponseModel> fetchInventoryList(
    String find,
    String inventoryName, {
    int? rangeMin,
    int? rangeMax,
  }) async {
    final int rangeMin_ = rangeMin ?? 0;
    final int rangeMax_ = rangeMax ?? 0;
    final DataResponseModel dataResponse;
    String filters = '';
    PostgrestResponse<List<Map<String, dynamic>>> postgrestResponse;
    List<Map<String, dynamic>> inventoryListDB = [];
    InventoryModel inventory;
    InventoryRowModel inventoryRow;
    List<InventoryRowModel> inventoryRowList = [];
    ProductModel product;
    List<String> codeList = [];
    String code;
    List<ProductModel> productList;

    if (find != '') {
      codeList = await ProductRepo().fetchCodeList(find);
      for (var element in codeList) {
        if (filters == '') {
          filters = '$_code.ilike.%$element%';
        } else {
          filters = '$filters,$_code.ilike.%$element%';
        }
      }
      if (filters == '') {
        filters = '$_code.ilike.%$find%';
      } else {
        filters = '$filters,$_code.ilike.%$find%';
      }

      postgrestResponse = await _supabase
          .from(_table)
          .select<PostgrestResponse<List<Map<String, dynamic>>>>(
              '*', const FetchOptions(count: CountOption.exact))
          .or(filters)
          .eq(_name, inventoryName)
          .gt(_stock, 0)
          .order(_code, ascending: true)
          .range(rangeMin_, rangeMax_);
    } else {
      filters = '$_name.eq.$inventoryName';
      postgrestResponse = await _supabase
          .from(_table)
          .select<PostgrestResponse<List<Map<String, dynamic>>>>(
              '*', const FetchOptions(count: CountOption.exact))
          .eq(_name, inventoryName)
          .gt(_stock, 0)
          .order(_code, ascending: true)
          .range(rangeMin_, rangeMax_);
    }
    inventoryListDB = postgrestResponse.data ?? [];
    codeList = [];
    for (var element in inventoryListDB) {
      code = element[_code];
      codeList.add(code);
    }
    productList = await ProductRepo().fetchProductList(codeList);
    if (inventoryListDB.isNotEmpty) {
      for (var element in inventoryListDB) {
        inventory = InventoryModel(
          code: element[_code] ?? '',
          id: element[_id].toString(),
          name: element[_name] ?? '',
          retailManager: element[_manager] ?? '',
          stock: element[_stock] ?? 0,
        );
        product = productList.where((x) => x.code == inventory.code).first;
        inventoryRow = InventoryRowModel(
            product: product,
            stock: inventory.stock,
            warehouseName: inventory.name);
        inventoryRowList.add(inventoryRow);
      }
    }

    dataResponse = DataResponseModel(
      dataList: inventoryRowList,
      count: postgrestResponse.count ?? 0,
    );

    return dataResponse;
  }

  Future<DataResponseModel> fetchInventoryListMulti(
    String find,
    String inventoryName, {
    int? rangeMin,
    int? rangeMax,
  }) async {
    final int rangeMin_ = rangeMin ?? 0;
    final int rangeMax_ = rangeMax ?? 0;
    final DataResponseModel dataResponse;
    String filters = '';
    PostgrestResponse<List<Map<String, dynamic>>> postgrestResponse;
    List<Map<String, dynamic>> inventoryListDB = [];
    InventoryModel inventory;
    InventoryRowModel inventoryRow;
    List<InventoryRowModel> inventoryRowList = [];
    ProductModel product;
    List<String> codeList = [];
    String code;
    List<ProductModel> productList;

    if (find != '') {
      codeList = await ProductRepo().fetchCodeList(find);
      for (var element in codeList) {
        if (filters == '') {
          filters = '$_code.ilike.%$element%';
        } else {
          filters = '$filters,$_code.ilike.%$element%';
        }
      }
      if (filters == '') {
        filters = '$_code.ilike.%$find%';
      } else {
        filters = '$filters,$_code.ilike.%$find%';
      }

      postgrestResponse = await _supabase
          .from(_table)
          .select<PostgrestResponse<List<Map<String, dynamic>>>>(
              '*', const FetchOptions(count: CountOption.exact))
          .or(filters)
          //.eq(_name, inventoryName)
          .gt(_stock, 0)
          .order(_code, ascending: true)
          .range(rangeMin_, rangeMax_);
    } else {
      filters = '$_name.eq.$inventoryName';
      postgrestResponse = await _supabase
          .from(_table)
          .select<PostgrestResponse<List<Map<String, dynamic>>>>(
              '*', const FetchOptions(count: CountOption.exact))
          //.eq(_name, inventoryName)
          .gt(_stock, 0)
          .order(_code, ascending: true)
          .range(rangeMin_, rangeMax_);
    }

    inventoryListDB = postgrestResponse.data ?? [];
    codeList = [];
    for (var element in inventoryListDB) {
      code = element[_code];
      codeList.add(code);
    }
    productList = await ProductRepo().fetchProductList(codeList);
    if (inventoryListDB.isNotEmpty) {
      for (var element in inventoryListDB) {
        inventory = InventoryModel(
          code: element[_code] ?? '',
          id: element[_id].toString(),
          name: element[_name] ?? '',
          retailManager: element[_manager] ?? '',
          stock: element[_stock] ?? 0,
        );
        product = productList.where((x) => x.code == inventory.code).first;
        inventoryRow = InventoryRowModel(
          product: product,
          stock: inventory.stock,
          warehouseName: inventory.name,
        );
        inventoryRowList.add(inventoryRow);
      }
    }

    dataResponse = DataResponseModel(
      dataList: inventoryRowList,
      count: postgrestResponse.count ?? 0,
    );

    return dataResponse;
  }

  Future<List<Map<String, dynamic>>> fetchInventory(
      String? inventoryName) async {
    final String name;
    List<Map<String, dynamic>> inventoryList = [];

    if (inventoryName != null) {
      name = inventoryName;
    } else {
      final pref = await SharedPreferences.getInstance();
      name = pref.getString(_user)!;
    }

    inventoryList = await _supabase
        .from(_table)
        .select<List<Map<String, dynamic>>>()
        .eq(_name, name);
    return inventoryList;
  }

  Future<InventoryModel?> fetchRowByCode(
      String code, String? inventoryName) async {
    final String name;
    InventoryModel? inventoryRow;
    List<Map<String, dynamic>> inventoryList = [];

    if (inventoryName != null) {
      name = inventoryName;
    } else {
      final pref = await SharedPreferences.getInstance();
      name = pref.getString(_user)!;
    }
    inventoryList = await _supabase
        .from(_table)
        .select<List<Map<String, dynamic>>>()
        .eq(_name, name)
        .eq(_code, code);
    if (inventoryList.isNotEmpty) {
      inventoryRow = InventoryModel(
          code: inventoryList.first[_code].toString(),
          id: inventoryList.first[_id].toString(),
          name: inventoryList.first[_name].toString(),
          retailManager: inventoryList.first[_manager].toString(),
          stock: inventoryList.first[_stock]);
    } else {
      inventoryRow = null;
    }
    return inventoryRow;
  }

  Future<void> updateInventoryWithMovemets(
      List<MovementModel> movements) async {
    double currentStock = -1;
    double newStock = -1;
    InventoryModel? inventoryModel;
    InventoryModel newInventoryRow;
    List<String> inventories = [];

    for (var element in movements) {
      inventoryModel =
          await fetchRowByCode(element.code, element.warehouseName);
      if (inventoryModel != null) {
        currentStock = inventoryModel.stock;
        if (element.conceptType == 0) {
          newStock = currentStock + element.quantity;
        } else if (element.conceptType == 1) {
          newStock = currentStock - element.quantity;
        }
        if (newStock >= 0) {
          await _supabase
              .from(_table)
              .update({_stock: newStock})
              .eq(_code, inventoryModel.code)
              .eq(_name, inventoryModel.name);
        }
      } else {
        inventories = await WarehousesRepo().fetchNames();
        if (inventories.contains(element.warehouseName) &&
            element.conceptType == 0) {
          newInventoryRow = InventoryModel(
              code: element.code,
              id: const Uuid().v4(),
              name: element.warehouseName,
              retailManager: '',
              stock: element.quantity);
          await insertInventoryRow(newInventoryRow);
        }
      }
    }
  }

  //Envía una lista de inventario para actualizar la base de datos.
  //Solo actualizara en la base de datos los elementos que aparecén en la lista
  // que se recibío. Si el elemento no existe en la base de datos lo crea. Si el nuevo
  // elemento que se envía es igual a cero, lo elimina de la base de datos.
  Future<void> updateInventory(List<InventoryModel> inventoryList) async {
    InventoryModel? invRowDB;
    for (var row in inventoryList) {
      print('${row.code}: ${row.stock}');
      print(row.name);
      invRowDB = await fetchRowByCode(row.code, row.name);
      if (invRowDB != null) {
        if (row.stock > 0) {
          //Actualiza fila de base de datos
          await _supabase
              .from(_table)
              .update({_stock: row.stock})
              .eq(_code, row.code)
              .eq(_name, row.name);
        } else {
          //Elimina fila de base de datos
          await _supabase
              .from(_table)
              .delete()
              .eq(_code, row.code)
              .eq(_name, row.name);
        }
      } else if (row.stock > 0) {
        await insertInventoryRow(row);
      }
    }
  }

  Future<void> updateInventoryRow(InventoryModel inventory) async {
    await _supabase
        .from(_table)
        .update({_stock: inventory.stock})
        .eq(_code, inventory.code)
        .eq(_name, inventory.name);
  }

  Future<void> insertInventoryRow(InventoryModel inventory) async {
    await _supabase.from(_table).insert({
      _id: inventory.id,
      _code: inventory.code,
      _stock: inventory.stock,
      _name: inventory.name,
      _manager: inventory.retailManager,
    });
  }
}

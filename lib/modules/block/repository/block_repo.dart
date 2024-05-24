import 'package:axol_inventarios/modules/block/model/property_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/block_model.dart';

class BlockRepo {
  static const String _table = 'block';
  static const String _id = 'id';
  static const String _tableName = 'table_name';
  static const String _blockName = 'block_name';
  static const String _property = 'property';
  final _supabase = Supabase.instance.client;

  Future<void> fetchAllBlocks() async {
    List<Map<String, dynamic>> blocksDB = [];
    List<BlockModel> blockList;
    BlockModel block;

    blocksDB =
        await _supabase.from(_table).select<List<Map<String, dynamic>>>('*');

    if (blocksDB.isNotEmpty) {
      for (var element in blocksDB) {
        block = BlockModel(
          blockName: element[_blockName] ?? '',
          propertyList: PropertyModel.mapToProperty(element[_property]),
          tableName: element[_tableName] ?? '',
          uuid: element[_id].toString(),
        );
      }
    }
  }
}

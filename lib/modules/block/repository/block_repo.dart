import 'package:axol_inventarios/modules/block/model/property_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/block_model.dart';

class BlockRepo {
  static const String table = 'block';
  static const String id = 'id';
  static const String tableName = 'table_name';
  static const String blockName = 'block_name';
  static const String property = 'property';
  static final _supabase = Supabase.instance.client;

  static Future<List<BlockModel>> fetchAllBlocks() async {
    List<Map<String, dynamic>> blocksDB = [];
    List<BlockModel> blockList = [];
    BlockModel block;
    blocksDB = await _supabase
        .from(table)
        .select<List<Map<String, dynamic>>>('*')
        .order(tableName, ascending: true);

    if (blocksDB.isNotEmpty) {
      for (var element in blocksDB) {
        block = BlockModel(
          blockName: element[blockName] ?? '',
          propertyList: PropertyModel.mapToProperty(element[property] ?? {}),
          tableName: element[tableName] ?? '',
          uuid: element[id].toString(),
        );
        blockList.add(block);
      }
    }

    return blockList;
  }

  static Future<void> update(BlockModel block) async {
    await _supabase.from(table).update({
      blockName: block.blockName,
      property: BlockModel.propsToMap(block.propertyList),
    }).eq(id, block.uuid);
  }
}

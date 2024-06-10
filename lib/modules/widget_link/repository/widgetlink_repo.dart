import 'package:supabase_flutter/supabase_flutter.dart';

import '../../block/model/block_model.dart';
import '../../block/model/property_model.dart';
import '../../block/repository/block_repo.dart';
import '../model/widgetlink_model.dart';

class WidgetLinkRepo {
  static const String _table = 'widget_link';
  static const String _id = 'id';
  static const String _block = 'block';
  static const String _widget = 'widget';
  static const String _views = 'views';
  static final _supabase = Supabase.instance.client;

  static Future<List<WidgetLinkModel>> fetchWidgetLik(
      List<String> idList) async {
    List<Map<String, dynamic>> wlsDB;
    List<WidgetLinkModel> wlList = [];
    WidgetLinkModel wl;
    BlockModel block = BlockModel.empty();

    wlsDB = await _supabase
        .from(_table)
        .select<List<Map<String, dynamic>>>('*, block:block(*)')
        .in_(_id, idList);

    if (wlsDB.isNotEmpty) {
      for (var wlDB in wlsDB) {
        final dynamicBlock = wlDB[_block];
        if (dynamicBlock is Map<String, dynamic> && dynamicBlock.isNotEmpty) {
          print('flag0.1: ${dynamicBlock[BlockRepo.blockName].runtimeType}');
          block = BlockModel(
            blockName: dynamicBlock[BlockRepo.blockName].toString(),
            propertyList: PropertyModel.mapToProperty(
                dynamicBlock[BlockRepo.property] ?? {}),
            tableName: dynamicBlock[BlockRepo.tableName],
            uuid: dynamicBlock[BlockRepo.id],
          );
        }
        wl = WidgetLinkModel(
          block: block,
          id: wlDB[_id],
          widget: wlDB[_widget],
          views: wlDB[_views],
        );
        wlList.add(wl);
      }
    }
    print('flag0.2');
    return wlList;
  }
}

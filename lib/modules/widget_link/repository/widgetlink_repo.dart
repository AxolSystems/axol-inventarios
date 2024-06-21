import 'package:supabase_flutter/supabase_flutter.dart';

import '../../block/model/block_model.dart';
import '../../block/model/property_model.dart';
import '../../block/repository/block_repo.dart';
import '../model/widget_view_model.dart';
import '../model/widgetlink_model.dart';

/// Conexión a la base de datos para realizar consultas de widgetLinks. 
/// Los widgetLinks contienen los datos necesarios para hacer la relación 
/// entre módulos, bloques y axolWidgets.
class WidgetLinkRepo {
  static const String _table = 'widget_link';
  static const String _id = 'id';
  static const String _block = 'block';
  static const String _widget = 'widget';
  static const String _views = 'views';
  static final _supabase = Supabase.instance.client;

  /// Mediante una lista de cadenas de texto, consulta y devuelve 
  /// todos los widgetLinks que coincidan con su id.
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
          views: WidgetViewModel.mapToViews(wlDB[_views]),
        );
        wlList.add(wl);
      }
    }
    return wlList;
  }
}

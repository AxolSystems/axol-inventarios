import 'package:supabase_flutter/supabase_flutter.dart';

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

    wlsDB = await _supabase
        .from(_table)
        .select<List<Map<String, dynamic>>>('*')
        .in_(_id, idList);

    if (wlsDB.isNotEmpty) {
      for (var wlDB in wlsDB) {
        wl = WidgetLinkModel(
          block: wlDB[_block],
          id: wlDB[_id],
          widget: wlDB[_widget],
          views: wlDB[_views],
        );
        wlList.add(wl);
      }
    }

    return wlList;
  }
}

class LinkWidgetModuleModel {
  final String id;
  final int index;
  final String idWidget;
  final String idModule;
  final DateTime createAt;

  LinkWidgetModuleModel({
    required this.createAt,
    required this.id,
    required this.idModule,
    required this.idWidget,
    required this.index,
  });

  LinkWidgetModuleModel.empty()
      : id = '',
        index = -1,
        idWidget = '',
        idModule = '',
        createAt = DateTime(0);
}

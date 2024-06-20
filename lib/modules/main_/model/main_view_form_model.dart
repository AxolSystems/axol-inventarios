import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:axol_inventarios/modules/widget_link/model/widgetlink_model.dart';

import '../../object/model/object_model.dart';
import '../../user/model/user_model.dart';
import 'module_model.dart';

/// Modelo de datos utilizado para mantener 
/// los datos de MainView de forma paralela 
/// a los cambios de la vista.
/// 
/// - [body] : Widget almacenado en esta propiedad es el que se 
/// muestra en pantalla.
/// - [moduleSelect] : Índice del modulo actual que se MainView.
/// - [linkSelect] : Índice del widgetLink actual en el módulo 
/// abierto en el momento.
/// - [viewSelect] : Índice del widgetView actual.
/// - [moduleList] : Lista con los módulos que se muestran MainView.
/// - [moduleBarVisible] : Identifica si actualmente la barra de modulo
/// se encuentra visible o no.
/// - [menuVisible] : Identifica si actualmente la barra de vistas se 
/// encuentra visible.
/// - [title] : Mantiene el título del encabezado de MainView.
/// - [user] : Datos del usuario con sesión iniciada.
/// - [objects] : Datos consultados en la base datos que se muestran en 
/// pantalla mediante el widget actual.
/// - [widgetLink] : WidgetLink abierto actualmente en pantalla.
class MainViewFormModel {
  AxolWidget? body;
  int moduleSelect;
  int linkSelect;
  int viewSelect;
  List<ModuleModel> moduleList;
  bool moduleBarVisible;
  bool menuVisible;
  String title;
  UserModel user;
  List<ObjectModel> objects;
  WidgetLinkModel widgetLink;

  MainViewFormModel({
    required this.body,
    required this.moduleSelect,
    required this.moduleList,
    required this.moduleBarVisible,
    required this.title,
    required this.menuVisible,
    required this.linkSelect,
    required this.viewSelect,
    required this.user,
    required this.objects,
    required this.widgetLink,
  });

  /// Not tiene parámetros, devuelve un MainViewFormModel en su 
  /// estado inicial. 
  MainViewFormModel.empty()
      : body = null,
        moduleSelect = 0,
        linkSelect = 0,
        viewSelect = 0,
        moduleList = [],
        moduleBarVisible = true,
        menuVisible = true,
        title = '',
        user = UserModel.empty(),
        objects = [],
        widgetLink = WidgetLinkModel.empty();
}

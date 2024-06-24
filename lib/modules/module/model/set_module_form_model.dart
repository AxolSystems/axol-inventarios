import 'package:axol_inventarios/modules/module/model/module_model.dart';

/// Datos de la vista de SetModule que varían según el cambio de estado.
class SetModuleFormModel {
  List<ModuleModel> modules;
  int theme;

  SetModuleFormModel({required this.modules, required this.theme});

  /// Estado inicial del form.
  SetModuleFormModel.empty()
      : modules = [],
        theme = 0;
}

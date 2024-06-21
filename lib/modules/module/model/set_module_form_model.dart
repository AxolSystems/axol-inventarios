import 'package:axol_inventarios/modules/module/model/module_model.dart';

class SetModuleFormModel {
  List<ModuleModel> modules;
  int theme;

  SetModuleFormModel({required this.modules, required this.theme});

  SetModuleFormModel.empty()
      : modules = [],
        theme = 0;
}

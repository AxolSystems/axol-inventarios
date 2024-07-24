import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/entity_model.dart';
import '../model/property_model.dart';
import '../model/setentity_form_model.dart';
import '../repository/entity_repo.dart';
import 'setentity_state.dart';

/// Clase con lógica del negocio de la vista de ajustes de bloque.
class SetEntityCubit extends Cubit<SetEntityState> {
  SetEntityCubit() : super(InitialSetEntityState());

  /// Obtiene todos los datos necesarios para iniciar la vista. 
  /// Dichos datos son proporcionados a al form.
  Future<void> initLoad(SetEntityFormModel form, int theme) async {
    try {
      emit(InitialSetEntityState());
      form.theme = theme;
      emit(LoadingSetEntityState());
      List<EntityModel> entitysDB;

      entitysDB = await EntityRepo.fetchAllEntitys();
      form.entityList = entitysDB;

      form.cEntity = form.select >= 0 ? form.entityList[form.select] : null;
      if (form.entityList.isNotEmpty && form.select == -1) {
        form.select = 0;
        form.cEntity = form.entityList[0];
      }
      if (form.cEntity != null) {
        if (form.cEntity!.entityName == '') {
          form.cEntity = EntityModel.setName(form.cEntity!,
              'Bloque ${form.cEntity!.tableName.split('table_').last}');
        }
        form.properties =
            SetEntityPropModel.propListToForm(form.cEntity!.propertyList);
        form.ctrlEntityName.text = form.cEntity?.entityName ?? '';
        form.heightBoxProp = form.properties.length * 52;
      }

      emit(LoadedSetEntityState());
    } catch (e) {
      emit(InitialSetEntityState());
      emit(ErrorSetEntityState(error: e.toString()));
    }
  }

  /// Método utilizado para realizar una recarga de la vista sin 
  /// necesidad de pasar por algún proceso. Suele utilizarse desde 
  /// SetEntityWidget.
  Future<void> load() async {
    try {
      emit(InitialSetEntityState());
      emit(LoadingSetEntityState());

      emit(LoadedSetEntityState());
    } catch (e) {
      emit(InitialSetEntityState());
      emit(ErrorSetEntityState(error: e.toString()));
    }
  }

  /// Lógica utilizada para hacer el cambio de bloque en la barra de 
  /// bloques disponibles.
  Future<void> switchEntity(SetEntityFormModel form) async {
    try {
      emit(InitialSetEntityState());
      emit(LoadingSetEntityState());

      form.cEntity = form.select >= 0 ? form.entityList[form.select] : null;
      if (form.entityList.isNotEmpty && form.select == -1) {
        form.select = 0;
        form.cEntity = form.entityList[0];
      }
      if (form.cEntity != null) {
        if (form.cEntity!.entityName == '') {
          form.cEntity = EntityModel.setName(form.cEntity!,
              'Bloque ${form.cEntity!.tableName.split('table_').last}');
        }
        form.properties =
            SetEntityPropModel.propListToForm(form.cEntity!.propertyList);
        form.ctrlEntityName.text = form.cEntity?.entityName ?? '';
        form.heightBoxProp = form.properties.length * 52;
        form.isChanged = false;
      }

      emit(LoadedSetEntityState());
    } catch (e) {
      emit(InitialSetEntityState());
      emit(ErrorSetEntityState(error: e.toString()));
    }
  }

  /// Agrega un nuevo espacio en la tabla para crear una propiedad.
  Future<void> addProperty(SetEntityFormModel form) async {
    try {
      emit(InitialSetEntityState());
      emit(LoadingSetEntityState());

      form.properties.add(SetEntityPropModel.empty());
      form.heightBoxProp = form.heightBoxProp + 52;
      form.isChanged = true;

      emit(LoadedSetEntityState());
    } catch (e) {
      emit(InitialSetEntityState());
      emit(ErrorSetEntityState(error: e.toString()));
    }
  }

  /// Lógica al seleccionar una nueva propiedad en el drop down 
  /// de nueva propiedad.
  Future<void> selectProp(
    SetEntityFormModel form,
    int index,
    Prop prop,
  ) async {
    try {
      emit(InitialSetEntityState());
      emit(LoadingSetEntityState());

      form.properties[index].property = prop;
      form.isChanged = true;

      emit(LoadedSetEntityState());
    } catch (e) {
      emit(InitialSetEntityState());
      emit(ErrorSetEntityState(error: e.toString()));
    }
  }

  /// Proceso de guardado de un bloque en la base datos. Si hay cambios 
  /// en el bloque seleccionado, actualiza sus objetos.
  Future<void> save(SetEntityFormModel form) async {
    try {
      emit(InitialSetEntityState());

      final EntityModel entity;
      List<EntityModel> entitysDB;
      List<PropertyModel> propList = [];
      PropertyModel prop;

      for (var element in form.properties) {
        prop = PropertyModel(
            name: element.ctrlProp.text, propertyType: element.property, key: element.key);
        if (prop.name.contains('~') ||
            prop.name.contains('\\') ||
            prop.name.contains('/')) {
          emit(LoadedSetEntityState());
          emit(const ErrorSetEntityState(
              error:
                  'No utilice los siguientes símbolos en los nombres de las propiedades:\n \\ / ~'));
          return;
        }
        if (propList.indexWhere((x) => x.name == prop.name) < 0) {
          propList.add(prop);
        } else {
          emit(LoadedSetEntityState());
          emit(const ErrorSetEntityState(
              error:
                  'No puede repetir nombres de propiedades en un mismo bloque'));
          return;
        }
      }

      emit(SavingSetEntityState());

      if (form.cEntity != null) {
        entity = EntityModel(
          entityName: form.ctrlEntityName.text,
          propertyList: propList,
          tableName: form.cEntity!.tableName,
          uuid: form.cEntity!.uuid,
        );

        await EntityRepo.update(entity);

        entitysDB = await EntityRepo.fetchAllEntitys();
        form.entityList = entitysDB;

        form.cEntity = form.select >= 0 ? form.entityList[form.select] : null;
        if (form.entityList.isNotEmpty && form.select == -1) {
          form.select = 0;
          form.cEntity = form.entityList[0];
        }
        if (form.cEntity != null && form.cEntity!.entityName == '') {
          form.cEntity = EntityModel.setName(form.cEntity!,
              'Bloque ${form.cEntity!.tableName.split('table_').last}');
          form.properties =
              SetEntityPropModel.propListToForm(form.cEntity!.propertyList);
          form.ctrlEntityName.text = form.cEntity?.entityName ?? '';
        }
      }

      emit(SavedSetEntityState());
      emit(LoadedSetEntityState());
    } catch (e) {
      emit(InitialSetEntityState());
      emit(ErrorSetEntityState(error: e.toString()));
    }
  }
}

/// Cubit utilizado para mantener los cambios del form de *SetEntityFormModel*.
class SetEntityForm extends Cubit<SetEntityFormModel> {
  SetEntityForm() : super(SetEntityFormModel.empty());
}

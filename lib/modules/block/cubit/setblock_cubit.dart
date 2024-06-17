import 'package:axol_inventarios/modules/block/model/block_model.dart';
import 'package:axol_inventarios/modules/block/model/setblock_form_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/property_model.dart';
import '../repository/block_repo.dart';
import 'setblock_state.dart';

class SetBlockCubit extends Cubit<SetBlockState> {
  SetBlockCubit() : super(InitialSetBlockState());

  Future<void> initLoad(SetBlockFormModel form, int theme) async {
    try {
      emit(InitialSetBlockState());
      form.theme = theme;
      emit(LoadingSetBlockState());
      List<BlockModel> blocksDB;

      blocksDB = await BlockRepo.fetchAllBlocks();
      form.blockList = blocksDB;

      form.cBlock = form.select >= 0 ? form.blockList[form.select] : null;
      if (form.blockList.isNotEmpty && form.select == -1) {
        form.select = 0;
        form.cBlock = form.blockList[0];
      }
      if (form.cBlock != null) {
        if (form.cBlock!.blockName == '') {
          form.cBlock = BlockModel.setName(form.cBlock!,
              'Bloque ${form.cBlock!.tableName.split('table_').last}');
        }
        form.properties =
            SetBlockPropModel.propListToForm(form.cBlock!.propertyList);
        form.ctrlBlockName.text = form.cBlock?.blockName ?? '';
        form.heightBoxProp = form.properties.length * 52;
      }

      emit(LoadedSetBlockState());
    } catch (e) {
      emit(InitialSetBlockState());
      emit(ErrorSetBlockState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialSetBlockState());
      emit(LoadingSetBlockState());

      emit(LoadedSetBlockState());
    } catch (e) {
      emit(InitialSetBlockState());
      emit(ErrorSetBlockState(error: e.toString()));
    }
  }

  Future<void> switchBlock(SetBlockFormModel form) async {
    try {
      emit(InitialSetBlockState());
      emit(LoadingSetBlockState());

      form.cBlock = form.select >= 0 ? form.blockList[form.select] : null;
      if (form.blockList.isNotEmpty && form.select == -1) {
        form.select = 0;
        form.cBlock = form.blockList[0];
      }
      if (form.cBlock != null) {
        if (form.cBlock!.blockName == '') {
          form.cBlock = BlockModel.setName(form.cBlock!,
              'Bloque ${form.cBlock!.tableName.split('table_').last}');
        }
        form.properties =
            SetBlockPropModel.propListToForm(form.cBlock!.propertyList);
        form.ctrlBlockName.text = form.cBlock?.blockName ?? '';
        form.heightBoxProp = form.properties.length * 52;
        form.isChanged = false;
      }

      emit(LoadedSetBlockState());
    } catch (e) {
      emit(InitialSetBlockState());
      emit(ErrorSetBlockState(error: e.toString()));
    }
  }

  Future<void> addProperty(SetBlockFormModel form) async {
    try {
      emit(InitialSetBlockState());
      emit(LoadingSetBlockState());

      form.properties.add(SetBlockPropModel.empty());
      form.heightBoxProp = form.heightBoxProp + 52;
      form.isChanged = true;

      emit(LoadedSetBlockState());
    } catch (e) {
      emit(InitialSetBlockState());
      emit(ErrorSetBlockState(error: e.toString()));
    }
  }

  Future<void> selectProp(
    SetBlockFormModel form,
    int index,
    Prop prop,
  ) async {
    try {
      emit(InitialSetBlockState());
      emit(LoadingSetBlockState());

      form.properties[index].property = prop;
      form.isChanged = true;

      emit(LoadedSetBlockState());
    } catch (e) {
      emit(InitialSetBlockState());
      emit(ErrorSetBlockState(error: e.toString()));
    }
  }

  Future<void> save(SetBlockFormModel form) async {
    try {
      emit(InitialSetBlockState());

      final BlockModel block;
      List<BlockModel> blocksDB;
      List<PropertyModel> propList = [];
      PropertyModel prop;

      for (var element in form.properties) {
        prop = PropertyModel(
            name: element.ctrlProp.text, propertyType: element.property);
        if (prop.name.contains('~') ||
            prop.name.contains('\\') ||
            prop.name.contains('/')) {
          emit(LoadedSetBlockState());
          emit(const ErrorSetBlockState(
              error:
                  'No utilice los siguientes símbolos en los nombres de las propiedades:\n \\ / ~'));
          return;
        }
        if (propList.indexWhere((x) => x.name == prop.name) < 0) {
          propList.add(prop);
        } else {
          emit(LoadedSetBlockState());
          emit(const ErrorSetBlockState(
              error:
                  'No puede repetir nombres de propiedes en un mismo bloque'));
          return;
        }
      }

      emit(SavingSetBlockState());

      if (form.cBlock != null) {
        block = BlockModel(
          blockName: form.ctrlBlockName.text,
          propertyList: propList,
          tableName: form.cBlock!.tableName,
          uuid: form.cBlock!.uuid,
        );

        await BlockRepo.update(block);

        blocksDB = await BlockRepo.fetchAllBlocks();
        form.blockList = blocksDB;

        form.cBlock = form.select >= 0 ? form.blockList[form.select] : null;
        if (form.blockList.isNotEmpty && form.select == -1) {
          form.select = 0;
          form.cBlock = form.blockList[0];
        }
        if (form.cBlock != null && form.cBlock!.blockName == '') {
          form.cBlock = BlockModel.setName(form.cBlock!,
              'Bloque ${form.cBlock!.tableName.split('table_').last}');
          form.properties =
              SetBlockPropModel.propListToForm(form.cBlock!.propertyList);
          form.ctrlBlockName.text = form.cBlock?.blockName ?? '';
        }
      }

      emit(SavedSetBlockState());
      emit(LoadedSetBlockState());
    } catch (e) {
      emit(InitialSetBlockState());
      emit(ErrorSetBlockState(error: e.toString()));
    }
  }
}

class SetBlockForm extends Cubit<SetBlockFormModel> {
  SetBlockForm() : super(SetBlockFormModel.empty());
}

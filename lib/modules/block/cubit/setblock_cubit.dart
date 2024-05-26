import 'package:axol_inventarios/modules/block/model/block_model.dart';
import 'package:axol_inventarios/modules/block/model/setblock_form_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/block_repo.dart';
import 'setblock_state.dart';

class SetBlockCubit extends Cubit<SetBlockState> {
  SetBlockCubit() : super(InitialSetBlockState());

  Future<void> initLoad(SetBlockFormModel form) async {
    try {
      emit(InitialSetBlockState());
      emit(LoadingSetBlockState());
      List<BlockModel> blocksDB;

      blocksDB = await BlockRepo.fetchAllBlocks();
      form.blockList = blocksDB;

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
}

class SetBlockForm extends Cubit<SetBlockFormModel> {
  SetBlockForm() : super(SetBlockFormModel.empty());
}
import 'block_model.dart';

class SetBlockFormModel {
  List<BlockModel> blockList;
  int select;

  SetBlockFormModel({required this.blockList, required this.select});

  SetBlockFormModel.empty()
      : blockList = [],
        select = -1;
}

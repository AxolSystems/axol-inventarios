import 'package:flutter/widgets.dart';

import 'block_model.dart';

class SetBlockFormModel {
  List<BlockModel> blockList;
  int select;
  TextEditingController ctrlBlockName;

  SetBlockFormModel({
    required this.blockList,
    required this.select,
    required this.ctrlBlockName,
  });

  SetBlockFormModel.empty()
      : blockList = [],
        select = -1,
        ctrlBlockName = TextEditingController();
}

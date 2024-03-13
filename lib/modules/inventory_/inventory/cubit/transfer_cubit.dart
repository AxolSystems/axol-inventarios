import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/movement_transfer_model.dart';
import '../repository/warehouses_repo.dart';

/*class TransferCubit extends Cubit<MovementTransferModel> {
  TransferCubit()
      : super(MovementTransferModel(
            inventories: [], inventory1: '', inventory2: '', concept: 0));

  Future<void> change(
      bool isTransfer, String origin, String destiny, int concept) async {
    List<String> list;
    MovementTransferModel emptyModel = MovementTransferModel(
        inventories: [], inventory1: '', inventory2: '', concept: 0);

    if (isTransfer == false) {
      emit(emptyModel);
    } else {
      list = await WarehousesRepo().fetchNames();
      list.remove(origin);
      emit(emptyModel);
      emit(MovementTransferModel(
        inventories: list,
        inventory1: origin,
        inventory2: destiny,
        concept: concept,
      ));
    }
  }
}*/

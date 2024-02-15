import '../../inventory/model/inventory_move/concept_move_model.dart';
import '../../../../models/textfield_model.dart';
import '../../../user/model/user_mdoel.dart';
import '../../inventory/model/warehouse_model.dart';

class MovementFilterModel {
  final WarehouseModel warehouse;
  final DateTime initDate;
  final DateTime endDate;
  final List<WarehouseModel> warehousesList;
  final ConceptMoveModel concept;
  final List<ConceptMoveModel> conceptsList;
  final UserModel user;
  final List<UserModel> usersList;
  final TextfieldModel currentLimit;

  static const WarehouseModel initWarehouse =
      WarehouseModel(id: -1, name: 'TODOS', retailManager: '');
  static const List<WarehouseModel> initWarehouseList = [];
  static const ConceptMoveModel initConcept =
      ConceptMoveModel(text: 'TODOS', id: -1, type: -1);
  static const List<ConceptMoveModel> initConceptList = [];
  static const UserModel initUser =
      UserModel(name: 'TODOS', id: -1, rol: '//', password: '//');
  static const List<UserModel> initUsersList = [];
  static TextfieldModel initLimit = const TextfieldModel(text: '50', position: 0);

  const MovementFilterModel({
    required this.initDate,
    required this.endDate,
    required this.warehouse,
    required this.warehousesList,
    required this.concept,
    required this.conceptsList,
    required this.user,
    required this.usersList,
    required this.currentLimit,
  });

  static MovementFilterModel initialValue() {
    return MovementFilterModel(
        initDate: DateTime(0),
        endDate: DateTime(3000),
        warehouse: initWarehouse,
        warehousesList: initWarehouseList,
        concept: initConcept,
        conceptsList: initConceptList,
        user: initUser,
        usersList: initUsersList,
        currentLimit: initLimit);
  }
}

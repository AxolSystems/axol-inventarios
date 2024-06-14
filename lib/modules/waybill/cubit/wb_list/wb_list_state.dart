import 'package:equatable/equatable.dart';

import '../../../user/model/user_model.dart';
import '../../model/waybill_list_model.dart';

abstract class WbListState extends Equatable {
  const WbListState();
}

class InitialWbListState extends WbListState {
  @override
  List<Object?> get props => [];
}

class LoadingWbListState extends WbListState {
  @override
  List<Object?> get props => [];
}

class LoadedWbListState extends WbListState {
  @override
  List<Object?> get props => [];
}

class OpenDetailsWbListState extends WbListState {
  final WaybillListModel waybillList;
  final UserModel user;
  const OpenDetailsWbListState({
    required this.waybillList,
    required this.user,
  });
  @override
  List<Object?> get props => [waybillList, user];
}

class ErrorWbListState extends WbListState {
  final String error;
  const ErrorWbListState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../user/model/user_model.dart';
import '../../../user/repository/user_repo.dart';
import 'salereport_view_state.dart';

class SaleReportViewCubit extends Cubit<SaleReportViewState> {
  SaleReportViewCubit() : super(InitialSaleReportViewState());

  Future<void> initLoad() async {
    try {
      emit(InitialSaleReportViewState());
      emit(LoadingSaleReportViewState());
      final UserModel user = await LocalUser().getLocalUser();
      emit(LoadedSaleReportViewState(user: user));
    } catch (e) {
      emit(ErrorSaleReportViewState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialSaleReportViewState());
      emit(LoadingSaleReportViewState());
      final UserModel user = await LocalUser().getLocalUser();
      emit(LoadedSaleReportViewState(user: user));
    } catch (e) {
      emit(ErrorSaleReportViewState(error: e.toString()));
    }
  }
}
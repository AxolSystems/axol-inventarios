import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/widgetlink_drawer_form_model.dart';
import '../model/widgetlink_model.dart';
import '../repository/widgetlink_repo.dart';
import 'widgetlink_drawer_state.dart';

class WLinkDrawerCubit extends Cubit<WLinkDrawerState> {
  WLinkDrawerCubit() : super(LoadedWLinkDrawerState());

  Future<void> initLoad(WLinkDrawerFormModel form) async {
    try {
      emit(InitialWLinkDrawerState());
      emit(LoadingWLinkDrawerState());
      List<WidgetLinkModel> links;
      
      links = await WidgetLinkRepo.fetchAllWidgetLik();
      form.links = links;
      print(form.links);

      emit(LoadedWLinkDrawerState());
    } catch (e) {
      emit(InitialWLinkDrawerState());
      emit(ErrorWLinkDrawerState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialWLinkDrawerState());
      emit(LoadingWLinkDrawerState());
      emit(LoadedWLinkDrawerState());
    } catch (e) {
      emit(InitialWLinkDrawerState());
      emit(ErrorWLinkDrawerState(error: e.toString()));
    }
  }
}

class WLinkDrawerForm extends Cubit<WLinkDrawerFormModel> {
  WLinkDrawerForm() : super(WLinkDrawerFormModel.empty());
}

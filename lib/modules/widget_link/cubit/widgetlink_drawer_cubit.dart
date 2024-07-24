import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/widgetlink_drawer_form_model.dart';
import '../model/widgetlink_model.dart';
import '../repository/widgetlink_repo.dart';
import 'widgetlink_drawer_state.dart';

/// Lógica del negocio del drawer para buscar widgetLinks.
class WLinkDrawerCubit extends Cubit<WLinkDrawerState> {
  WLinkDrawerCubit() : super(LoadedWLinkDrawerState());

  /// Lógica encargada de obtener los datos iniciales para el widget.
  Future<void> initLoad(WLinkDrawerFormModel form) async {
    try {
      emit(InitialWLinkDrawerState());
      emit(LoadingWLinkDrawerState());
      List<WidgetLinkModel> links;

      links = await WidgetLinkRepo.fetchAllWidgetLik();
      form.links = links;
      form.filterLinks = links;

      emit(LoadedWLinkDrawerState());
    } catch (e) {
      emit(InitialWLinkDrawerState());
      emit(ErrorWLinkDrawerState(error: e.toString()));
    }
  }

  /// Método utilizado para recargar el widget sin necesidad de 
  /// pasar por algún otro proceso.
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

  /// Actualiza la lista filtrada de links que muestra en pantalla, realizando 
  /// la comparación con el texto actual del buscador.
  Future<void> finder(WLinkDrawerFormModel form) async {
    try {
      emit(InitialWLinkDrawerState());
      emit(LoadingWLinkDrawerState());
      List<WidgetLinkModel> links = [];
      String text = form.ctrlFind.text.toLowerCase();

      links = form.links
          .where((x) =>
              x.id.toLowerCase().contains(text) ||
              x.entity.entityName.toLowerCase().contains(text))
          .toList();
      form.filterLinks = links;

      emit(LoadedWLinkDrawerState());
    } catch (e) {
      emit(InitialWLinkDrawerState());
      emit(ErrorWLinkDrawerState(error: e.toString()));
    }
  }
  
  /// Procesos al presionar uno de los links que se quiera seleccionar. 
  /// Al finalizar retorna a la vista anterior.
  Future<void> selectLink(BuildContext context, WidgetLinkModel link) async {
    try {
      emit(InitialWLinkDrawerState());
      emit(LoadingWLinkDrawerState());
      Navigator.pop(context, link);
    } catch (e) {
      emit(InitialWLinkDrawerState());
      emit(ErrorWLinkDrawerState(error: e.toString()));
    }
  }
}

/// Cubit con datos mutables según el estado del drawer para buscar links.
class WLinkDrawerForm extends Cubit<WLinkDrawerFormModel> {
  WLinkDrawerForm() : super(WLinkDrawerFormModel.empty());
}

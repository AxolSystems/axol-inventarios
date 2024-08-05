import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/data_response_model.dart';
import '../../../../../modules/object/model/object_model.dart';
import '../../../../../modules/object/repository/object_repo.dart';
import '../../../../../modules/widget_link/model/widgetlink_model.dart';
import '../../../../../modules/widget_link/repository/widgetlink_repo.dart';
import '../model/search_ref_obj_form_model.dart';
import 'search_ref_obj_state.dart';

class SearchRefObjCubit extends Cubit<SearchRefObjState> {
  SearchRefObjCubit() : super(InitialSearchRefObjState());

  Future<void> load() async {
    try {
      emit(InitialSearchRefObjState());
      emit(LoadingSearchRefObjState());

      emit(LoadedSearchRefObjState());
    } catch (e) {
      emit(InitialSearchRefObjState());
      emit(ErrorSearchRefObjState(error: e.toString()));
    }
  }

  Future<void> initLoad(SearchRefObjFormModel form, String idLink) async {
    try {
      emit(InitialSearchRefObjState());
      emit(LoadingSearchRefObjState());
      final List<WidgetLinkModel> links;

      links = await WidgetLinkRepo.fetchWidgetLik([idLink]);

      /*rangeMin = (form.currentPage * form.limitRows) - form.limitRows;
      rangeMax = (form.currentPage * form.limitRows) - 1;

      dataResponse = await ObjectRepo.fetchObject(
        filters: [],
        link: links.first,
        rangeMin: rangeMin,
        rangeMax: rangeMax,
      );

      countReg = dataResponse.count;
      form.totalPage = (countReg / form.limitRows).ceil();
      form.totalReg = countReg;*/
      await getData(form: form, link: links.first);
      form.link = links.first;

      emit(LoadedSearchRefObjState());
    } catch (e) {
      emit(InitialSearchRefObjState());
      emit(ErrorSearchRefObjState(error: e.toString()));
    }
  }

  Future<void> prevPage(SearchRefObjFormModel form) async {
    try {
      emit(InitialSearchRefObjState());
      emit(LoadingSearchRefObjState());

      if (form.currentPage > 1) {
        form.currentPage = form.currentPage - 1;
        await getData(form: form, link: form.link);
      }

      emit(LoadedSearchRefObjState());
    } catch (e) {
      emit(InitialSearchRefObjState());
      emit(ErrorSearchRefObjState(error: e.toString()));
    }
  }

  Future<void> nextPage(SearchRefObjFormModel form) async {
    try {
      emit(InitialSearchRefObjState());
      emit(LoadingSearchRefObjState());

      if (form.currentPage < form.totalPage) {
        form.currentPage = form.currentPage + 1;
        await getData(form: form, link: form.link);
      }

      emit(LoadedSearchRefObjState());
    } catch (e) {
      emit(InitialSearchRefObjState());
      emit(ErrorSearchRefObjState(error: e.toString()));
    }
  }

  Future<void> search(SearchRefObjFormModel form) async {
    try {
      emit(InitialSearchRefObjState());
      emit(LoadingSearchRefObjState());

      await getData(
          form: form, link: form.link, search: form.finderController.text);

      emit(LoadedSearchRefObjState());
    } catch (e) {
      emit(InitialSearchRefObjState());
      emit(ErrorSearchRefObjState(error: e.toString()));
    }
  }

  Future<void> getData({
    required SearchRefObjFormModel form,
    required WidgetLinkModel link,
    int? rangeMin,
    int? rangeMax,
    String? search,
  }) async {
    final DataResponseModel dataResponse;
    final int countReg;

    rangeMin ??= (form.currentPage * form.limitRows) - form.limitRows;
    rangeMax ??= (form.currentPage * form.limitRows) - 1;

    dataResponse = await ObjectRepo.fetchObject(
      filters: [],
      link: link,
      rangeMin: rangeMin,
      rangeMax: rangeMax,
      search: search,
    );
    countReg = dataResponse.count;
    form.totalPage = (countReg / form.limitRows).ceil();
    form.totalReg = countReg;
    form.objectList = dataResponse.dataList as List<ObjectModel>;
  }
}

class SearchRefObjForm extends Cubit<SearchRefObjFormModel> {
  SearchRefObjForm() : super(SearchRefObjFormModel.empty());
}

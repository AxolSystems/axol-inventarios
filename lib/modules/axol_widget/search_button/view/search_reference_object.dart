import 'package:axol_inventarios/modules/axol_widget/search_button/model/filter_property_form_model.dart';
import 'package:axol_inventarios/modules/axol_widget/search_button/view/filter_property_drawer.dart';
import 'package:axol_inventarios/modules/entity/model/property_model.dart';
import 'package:axol_inventarios/modules/object/model/object_model.dart';
import 'package:axol_inventarios/modules/object/model/reference_object_model.dart';
import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:axol_inventarios/utilities/widgets/buttons/button.dart';
import 'package:axol_inventarios/modules/axol_widget/search_button/cubit/search_ref_obj/search_ref_obj_state.dart';
import 'package:axol_inventarios/modules/axol_widget/search_button/model/search_ref_obj_form_model.dart';
import 'package:axol_inventarios/utilities/widgets/dialog.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:axol_inventarios/utilities/widgets/loading_indicator/progress_indicator.dart';
import 'package:axol_inventarios/utilities/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../generic/view/axol_widget.dart';
import '../cubit/search_ref_obj/search_ref_obj_cubit.dart';

class SearchReferenceObject extends AxolWidget {
  final String idRefLink;
  final String idRefPropView;
  final String initIdRefObject;
  const SearchReferenceObject({
    super.key,
    super.theme,
    required this.idRefLink,
    required this.initIdRefObject,
    required this.idRefPropView,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SearchRefObjCubit()),
        BlocProvider(create: (_) => SearchRefObjForm()),
      ],
      child: SearchReferenceObjectBuild(
        idRefLink: idRefLink,
        idRefPropView: idRefPropView,
        initIdRefObject: initIdRefObject,
        theme: theme,
      ),
    );
  }
}

class SearchReferenceObjectBuild extends AxolWidget {
  final String idRefLink;
  final String initIdRefObject;
  final String idRefPropView;
  const SearchReferenceObjectBuild({
    super.key,
    super.theme,
    required this.idRefLink,
    required this.initIdRefObject,
    required this.idRefPropView,
  });

  @override
  Widget build(BuildContext context) {
    final int theme_ = theme ?? 0;
    SearchRefObjFormModel form = context.read<SearchRefObjForm>().state;
    return BlocConsumer<SearchRefObjCubit, SearchRefObjState>(
      bloc: context.read<SearchRefObjCubit>()..initLoad(form, idRefLink),
      listener: (context, state) {
        if (state is ErrorSearchRefObjState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialogAxol(text: state.error));
        }
      },
      builder: (context, state) => DrawerBox(
        theme: theme_,
        header: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(color: ColorTheme.item30(theme_)),
                    )),
                    child: Text(
                      'Buscar objetos relacionales',
                      style: Typo.titleH2(theme_),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: PrimaryTextField(
                    controller: form.finderController,
                    theme: theme_,
                    margin: const EdgeInsets.all(12),
                    prefixIcon: Icon(
                      Icons.search,
                      color: ColorTheme.item10(theme_),
                    ),
                    onSubmitted: (value) {
                      context.read<SearchRefObjCubit>().search(form);
                    },
                  ),
                ),
                SecondaryButton(
                  icon: Icons.filter_list,
                  theme: theme,
                  height: 42,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  margin: const EdgeInsets.only(right: 8),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => FilterPropDrawer(
                        propCheckedList: form.propCheckedList,
                      ),
                    ).then(
                      (value) {
                        if (value is List<PropChecked>) {
                          form.propCheckedList = value;
                          context.read<SearchRefObjCubit>().load();
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    SecondaryButton(
                      icon: Icons.chevron_left,
                      theme: theme_,
                      onPressed: () {
                        context.read<SearchRefObjCubit>().prevPage(form);
                      },
                    ),
                    const SizedBox(width: 8),
                    Text('${form.currentPage} de ${form.totalPage}',
                        style: Typo.body(theme_)),
                    const SizedBox(width: 8),
                    SecondaryButton(
                      icon: Icons.chevron_right,
                      theme: theme_,
                      onPressed: () {
                        context.read<SearchRefObjCubit>().nextPage(form);
                      },
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Text('${form.limitRows}', style: Typo.body(theme_)),
                        Text(' filas', style: Typo.body(theme_)),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Text('${form.totalReg} registros',
                        style: Typo.body(theme_)),
                  ],
                ),
              ),
            ),
          ),
        ],
        child: state is LoadingSearchRefObjState
            ? const Expanded(
                child: Column(
                children: [
                  LinearProgressIndicatorAxol(),
                  Expanded(child: SizedBox()),
                ],
              ))
            : Expanded(
                child: ListView.builder(
                  itemCount: form.objectList.length,
                  itemBuilder: (context, index) {
                    final ObjectModel obj = form.objectList[index];
                    List<Widget> objectSchema = [];
                    for (PropertyModel prop in form.link.entity.propertyList) {
                      if (form.propCheckedList.indexWhere((x) =>
                              x.checked == true && x.property.key == prop.key) >
                          -1) {
                        objectSchema.add(Row(
                          children: [
                            const SizedBox(width: 12),
                            Text(
                              '${prop.name}: ',
                              style: Typo.subtitle(theme_),
                            ),
                            Text(
                              obj.dataViewText(prop),
                              style: Typo.body(theme_),
                            ),
                          ],
                        ));
                      }
                    }
                    return Card(
                      shadowColor: ColorTheme.item10(theme_),
                      shape: ContinuousRectangleBorder(
                          side: BorderSide(color: ColorTheme.item30(theme_)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6))),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      color: ColorTheme.background(theme_),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                        ),
                        onPressed: () {
                          Navigator.pop(
                              context,
                              ReferenceObjectModel(
                                referenceLink: form.link,
                                //idLink: form.link.id,
                                referenceObject: obj,
                                //propertyList: form.link.entity.propertyList,
                                idPropertyView: idRefPropView,
                              ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Id: ', style: Typo.subtitle(theme_)),
                                  Text(
                                    obj.id,
                                    style: Typo.body(theme_),
                                  )
                                ],
                              ),
                              Column(
                                children: objectSchema,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

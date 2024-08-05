import 'package:axol_inventarios/modules/axol_widget/generic/view/axol_widget.dart';
import 'package:axol_inventarios/modules/entity/model/property_model.dart';
import 'package:axol_inventarios/modules/object/model/reference_object_model.dart';
import 'package:axol_inventarios/utilities/widgets/loading_indicator/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../modules/object/model/object_model.dart';
import '../../../../theme/theme.dart';
import '../../../dialog.dart';
import '../../../drawer_box.dart';
import '../../../textfield.dart';
import '../../button.dart';
import '../cubit/search_ref_obj_cubit.dart';
import '../cubit/search_ref_obj_state.dart';
import '../model/search_ref_obj_form_model.dart';

class SearchButton extends AxolWidget {
  final ReferenceObjectModel referenceObject;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? width;
  final Function()? onPressed;
  const SearchButton({
    required this.referenceObject,
    super.key,
    super.theme,
    this.margin,
    this.padding,
    this.width,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final int theme_ = theme ?? 0;
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: SizedBox(
        width: width,
        child: OutlinedButton(
          style: ButtonStyle(
            alignment: Alignment.centerLeft,
            side: WidgetStatePropertyAll(
                BorderSide(color: ColorTheme.item20(theme_))),
            shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)))),
            backgroundColor: WidgetStatePropertyAll(ColorTheme.fill(theme_)),
          ),
          onPressed: onPressed,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  referenceObject.getPropViewText(),
                  style: Typo.body(theme_),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.search,
                  color: ColorTheme.item10(theme_),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchReferenceObject extends AxolWidget {
  final String idRefLink;
  final String initIdRefObject;
  const SearchReferenceObject({
    super.key,
    super.theme,
    required this.idRefLink,
    required this.initIdRefObject,
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
        initIdRefObject: initIdRefObject,
        theme: theme,
      ),
    );
  }
}

class SearchReferenceObjectBuild extends AxolWidget {
  final String idRefLink;
  final String initIdRefObject;
  const SearchReferenceObjectBuild({
    super.key,
    super.theme,
    required this.idRefLink,
    required this.initIdRefObject,
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
                ))
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
                )
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
                    );
                  },
                ),
              ),
      ),
    );
  }
}

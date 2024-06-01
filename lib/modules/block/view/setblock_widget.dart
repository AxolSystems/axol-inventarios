import 'package:axol_inventarios/modules/axol_widget/axol_widget.dart';
import 'package:axol_inventarios/modules/block/model/property_model.dart';
import 'package:axol_inventarios/modules/main_/model/main_view_form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../utilities/widgets/button.dart';
import '../../../utilities/widgets/textfield.dart';
import '../cubit/setblock_cubit.dart';
import '../cubit/setblock_state.dart';
import '../model/block_model.dart';
import '../model/setblock_form_model.dart';

class SetBlockWidget extends StatelessWidget {
  const SetBlockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SetBlockCubit()),
        BlocProvider(create: (_) => SetBlockForm()),
      ],
      child: const SetBlockWidgetBuild(),
    );
  }
}

class SetBlockWidgetBuild extends StatelessWidget {
  const SetBlockWidgetBuild({super.key});

  @override
  Widget build(BuildContext context) {
    SetBlockFormModel form = context.read<SetBlockForm>().state;
    return BlocConsumer<SetBlockCubit, SetBlockState>(
      bloc: context.read<SetBlockCubit>()..initLoad(form),
      builder: (context, state) {
        const double widthMenuBlock = 250;
        ScrollController scrollController = ScrollController();
        return Expanded(child: LayoutBuilder(
          builder: (context, constraints) {
            final double paddingBox;
            final double heightBox;
            bool isBoxNarrow = false;
            if (constraints.maxWidth > 1450) {
              paddingBox = 130;
              heightBox = 100;
            } else if (constraints.maxWidth > 1190) {
              paddingBox = 110;
              heightBox = 100;
            } else if (constraints.maxWidth > 940) {
              paddingBox = 50;
              heightBox = 100;
            } else {
              paddingBox = 16;
              heightBox = 150;
              isBoxNarrow = true;
            }
            print('max: ${constraints.maxWidth}');
            return Container(
              color: ColorPalette.darkBackground,
              child: RawScrollbar(
                controller: scrollController,
                thumbVisibility: true,
                radius: const Radius.circular(8),
                thickness: 12,
                child: ListView(
                  //Cambio de ListView a Row:
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: widthMenuBlock,
                      decoration: const BoxDecoration(
                          border: Border(
                              right: BorderSide(
                        color: ColorPalette.darkItems20,
                      ))),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4),
                            child: Text(
                              'Bloques disponibles',
                              style: Typo.subtitleLight,
                            ),
                          ),
                          Expanded(
                              child: ListView.builder(
                            itemCount: form.blockList.length,
                            itemBuilder: (context, index) {
                              final block = form.blockList[index];
                              final blockName = block.blockName == ''
                                  ? 'Bloque ${block.tableName.split('table_').last}'
                                  : block.blockName;
                              return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 4, 4, 0),
                                  child: MainNavButton(
                                    onPressed: () {
                                      form.select = index;
                                      form.cBlock = form.blockList[form.select];
                                      context.read<SetBlockCubit>().load(form);
                                    },
                                    text: blockName,
                                    menuVisible: false,
                                    isHover: form.select == index,
                                  ));
                            },
                          ))
                        ],
                      ),
                    ),
                    SizedBox(
                        width: constraints.maxWidth > 450
                            ? constraints.maxWidth - widthMenuBlock
                            : 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  paddingBox, 16, paddingBox, 8),
                              child: Container(
                                width: constraints.maxWidth > 450
                                    ? constraints.maxWidth -
                                        widthMenuBlock -
                                        (paddingBox * 2)
                                    : 200,
                                height: heightBox,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorPalette.darkItems20),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6)),
                                  color: ColorPalette.darkItems30,
                                ),
                                child: constraints.maxWidth > 940
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children:
                                            generalSettings(form, isBoxNarrow),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children:
                                            generalSettings(form, isBoxNarrow),
                                      ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text(
                                  'Propiedades',
                                  style: Typo.labelLight,
                                ),
                                PrimaryButton(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 12, 0),
                                  text: 'Agregar',
                                  icon: Icons.add,
                                  onPressed: () {
                                    context
                                        .read<SetBlockCubit>()
                                        .addProprty(form);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                                child: ListView.builder(
                              itemCount: form.properties.length,
                              itemBuilder: (context, index) {
                                final SetBlockPropModel property =
                                    form.properties[index];
                                List<DropdownMenuItem<Prop>> itemList = [];
                                DropdownMenuItem<Prop> item;
                                for (Prop prop in Prop.values) {
                                  item = DropdownMenuItem(
                                    value: prop,
                                    child: Text(
                                      PropertyModel.getTextToProp(prop),
                                    ),
                                  );
                                  itemList.add(item);
                                }
                                return Row(
                                  children: [
                                    Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                      width: 200,
                                      height: 40,
                                      child: PrimaryTextField(
                                        controller: property.ctrlProp,
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 8, 8),
                                      width: 160,
                                      height: 40,
                                      child: DropdownButtonFormField(
                                        dropdownColor:
                                            ColorPalette.darkBackground,
                                        icon: const SizedBox(),
                                        style: Typo.systemLight,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          prefixIcon: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: ColorPalette.lightText,
                                            size: 15,
                                          ),
                                          filled: true,
                                          fillColor: ColorPalette.filledLight,
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6)),
                                              borderSide: BorderSide(
                                                  color: ColorPalette
                                                      .darkItems10)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                              borderSide: BorderSide(
                                                  color: ColorPalette
                                                      .lightItems10)),
                                        ),
                                        items: itemList,
                                        value: form.properties[index].property,
                                        onChanged: (value) {
                                          if (value != null) {
                                            context
                                                .read<SetBlockCubit>()
                                                .selectProp(form, index, value);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ))
                          ],
                        ))
                  ],
                ),
              ), //RawScrollBar
            );
          },
        ));
      },
      listener: (context, state) {
        if (state is ErrorSetBlockState) {
          showDialog(
            context: context,
            builder: (context) => AlertDialogAxol(
              text: state.error,
            ),
          );
        }
      },
    );
  }

  List<Widget> generalSettings(SetBlockFormModel form, bool isBoxNarrow) => [
        SizedBox(
          width: 150,
          child: Text(
            form.cBlock != null
                ? (form.cBlock!.blockName == ''
                    ? form.cBlock!.tableName
                    : form.cBlock!.blockName)
                : 'Loading...',
            style: Typo.subtitleLight,
          ),
        ),
        //Container(
        //padding:
        //    const EdgeInsets.fromLTRB(0, 4, 8, 4),
        //height: 40,
        //width: p2,
        //child:
        Visibility(
          visible: isBoxNarrow == false,
          replacement: const SizedBox(height: 16),
          child: const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
        ),

        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nombre del bloque', style: Typo.labelLight),
               const SizedBox(height: 4),
              PrimaryTextField(
                controller: form.ctrlBlockName,
              )
            ],
          ),
        ),
        //),
      ];
}

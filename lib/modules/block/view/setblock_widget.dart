import 'package:axol_inventarios/modules/axol_widget/axol_widget.dart';
import 'package:axol_inventarios/modules/block/model/property_model.dart';
import 'package:axol_inventarios/modules/main_/model/main_view_form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/alert_dialog_axol.dart';
import '../../../utilities/widgets/button.dart';
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
    //double widthScreen = MediaQuery.of(context).size.width;
    return BlocConsumer<SetBlockCubit, SetBlockState>(
      bloc: context.read<SetBlockCubit>()..initLoad(form),
      builder: (context, state) {
        BlockModel? cBlock =
            form.select >= 0 ? form.blockList[form.select] : null;
        if (form.blockList.isNotEmpty && form.select == -1) {
          form.select = 0;
          context.read<SetBlockCubit>().load();
        }
        if (cBlock != null && cBlock.blockName == '') {
          cBlock = BlockModel.setName(
              cBlock, 'Bloque ${cBlock.tableName.split('table_').last}');
        }
        ScrollController scrollController = ScrollController();
        return Expanded(
            child: Container(
          color: ColorPalette.darkBackground,
          child: RawScrollbar(
            controller: scrollController,
            thumbVisibility: true,
            radius: const Radius.circular(8),
            thickness: 12,
            child: ListView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  width: 250,
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
                              padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                              child: MainNavButton(
                                onPressed: () {
                                  form.select = index;
                                  context.read<SetBlockCubit>().load();
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
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                          child: Text(
                            cBlock != null
                                ? (cBlock.blockName == ''
                                    ? cBlock.tableName
                                    : cBlock.blockName)
                                : '',
                            style: Typo.subtitleLight,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          height: 40,
                          width: 300,
                          child: TextField(
                            controller: form.ctrlBlockName,
                            style: Typo.bodyLight,
                            decoration: const InputDecoration(
                              isDense: false,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 0),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide: BorderSide(
                                      color: ColorPalette.darkItems10)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  borderSide:
                                      BorderSide(color: ColorPalette.primary)),
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
                              icon: Icons.add,
                              onPressed: () {},
                            )
                          ],
                        ),
                        Expanded(
                            child: ListView.builder(
                          itemCount: cBlock?.propertyList.length ?? 0,
                          itemBuilder: (context, index) {
                            final property = cBlock?.propertyList[index] ??
                                PropertyModel.empty();
                            List<DropdownMenuItem<Prop>> itemList = [];
                            DropdownMenuItem<Prop> item;
                            for (Prop prop in Prop.values) {
                              item = DropdownMenuItem(
                                value: prop,
                                child: Text(PropertyModel.getTextToProp(prop)),
                              );
                              itemList.add(item);
                            }
                            return Row(
                              children: [
                                const TextField(),
                                DropdownButton(
                                  items: itemList,
                                  onChanged: (value) {},
                                ),
                              ],
                            );
                          },
                        ))
                      ],
                    ))
              ],
            ),
          ),
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
}

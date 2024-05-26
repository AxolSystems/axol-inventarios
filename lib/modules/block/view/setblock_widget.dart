import 'package:axol_inventarios/modules/axol_widget/axol_widget.dart';
import 'package:axol_inventarios/modules/block/model/property_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/theme/theme.dart';
import '../../../utilities/widgets/alert_dialog_axol.dart';
import '../cubit/setblock_cubit.dart';
import '../cubit/setblock_state.dart';
import '../model/block_model.dart';
import '../model/setblock_form_model.dart';

class SetBlockWidget extends StatelessWidget {
  //final List<BlockModel> blockList;
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
  //final List<BlockModel> blockList;
  const SetBlockWidgetBuild({super.key});

  @override
  Widget build(BuildContext context) {
    SetBlockFormModel form = context.read<SetBlockForm>().state;
    BlockModel? cBlock = form.select >= 0 ? form.blockList[form.select] : null;
    return BlocConsumer<SetBlockCubit, SetBlockState>(
      bloc: context.read<SetBlockCubit>()..initLoad(form),
      builder: (context, state) {
        return Expanded(
            child: Container(
          color: ColorPalette.darkBackground,
          child: Row(
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
                            ? block.tableName
                            : block.blockName;
                        return Padding(
                            padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                            child: OutlinedButton(
                              onPressed: () {},
                              child: Text(blockName),
                            ));
                      },
                    ))
                  ],
                ),
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    cBlock?.blockName ?? '',
                    style: Typo.subtitleLight,
                  ),
                  //const TextField(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Propiedades',
                        style: Typo.labelLight,
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  /*Expanded(
                          child: ListView.builder(
                        itemCount: cBlock.propertyList.length,
                        itemBuilder: (context, index) {
                          final property = cBlock.propertyList[index];
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
                      ))*/
                ],
              ))
            ],
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

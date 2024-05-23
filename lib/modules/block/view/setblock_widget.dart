import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/theme/theme.dart';
import '../cubit/setblock_cubit.dart';
import '../model/block_model.dart';

class SetBlockWidget extends StatelessWidget {
  final List<BlockModel> blockList;
  const SetBlockWidget({super.key, required this.blockList});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SetBlockCubit(),
      child: SetBlockWidgetBuild(blockList: blockList),
    );
  }
}

class SetBlockWidgetBuild extends StatelessWidget {
  final List<BlockModel> blockList;
  const SetBlockWidgetBuild({super.key, required this.blockList});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      builder: (context, state) {
        return Container(
          color: ColorPalette.darkBackground,
          child: Row(
            children: [
              SizedBox(
                width: 250,
                child: Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                      itemBuilder: (context, index) {},
                    ))
                  ],
                ),
              )
            ],
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/resizable_cubit.dart';
import '../model/resizable_form_model.dart';

class ResizableBox extends StatelessWidget {
  const ResizableBox({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ResizableCubit()),
        BlocProvider(create: (_) => ResizableForm()),
      ],
      child: const ResizableBoxBuild(),
    );
  }
}

class ResizableBoxBuild extends StatelessWidget {
  const ResizableBoxBuild({super.key});

  @override
  Widget build(BuildContext context) {
    ResizableFormModel form = context.read<ResizableForm>().state;
    return BlocBuilder<ResizableCubit, ResizableState>(
      bloc: context.read<ResizableCubit>()..initLoad(form),
      builder: (context, state) => Container(
        color: Colors.white,
        width: 500,
        height: 400,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                Container(
                  width: (constraints.maxWidth - 2) * form.percent[0],
                  height: constraints.maxHeight,
                  color: Colors.blue,
                ),
                GestureDetector(
                  onTapDown: (details) {},
                  onHorizontalDragStart: (details) {
                    print('start: ${details.localPosition}');
                  },
                  onHorizontalDragEnd: (details) {
                    final double value;
                    print('end: ${details.localPosition}');
                    value = (details.localPosition.dy / 500);
                    if (details.localPosition.dy < 0) {
                      form.percent[0] = form.percent[0] - (value * -1);
                      form.percent[1] = form.percent[1] - (value * -1);
                      context.read<ResizableCubit>().load();
                    }
                  },
                  child: const VerticalDivider(
                    width: 2,
                    thickness: 2,
                    color: Colors.black,
                  ),
                ),
                Container(
                  width: (constraints.maxWidth - 2) * form.percent[1],
                  height: constraints.maxHeight,
                  color: Colors.amber,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

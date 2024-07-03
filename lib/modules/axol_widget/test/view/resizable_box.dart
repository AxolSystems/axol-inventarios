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
                        width: (constraints.maxWidth - 4) * form.percent[0],
                        height: constraints.maxHeight,
                        color: Colors.blue,
                      ),
                      GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          print(details.delta);
                          final double value;
                          value = (details.delta.dx / 500);
                          form.percent[0] = form.percent[0] + (value);
                          form.percent[1] = form.percent[1] - (value);
                          context.read<ResizableCubit>().load();
                        },
                        /*onHorizontalDragEnd: (details) {
                          final double value;
                          value = (details.localPosition.dx / 500);
                          form.percent[0] = form.percent[0] + (value);
                          form.percent[1] = form.percent[1] - (value);
                          context.read<ResizableCubit>().load();
                        },*/
                        child: const MouseRegion(
                          cursor: SystemMouseCursors.resizeColumn,
                          child: VerticalDivider(
                          width: 4,
                          thickness: 4,
                          color: Colors.black,
                        ),
                        ) 
                      ),
                      Container(
                        width: (constraints.maxWidth - 4) * form.percent[1],
                        height: constraints.maxHeight,
                        color: Colors.amber,
                      ),
                    ],
                  );
                },
              ),
            ));
  }
}

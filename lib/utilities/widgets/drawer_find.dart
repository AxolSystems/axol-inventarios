import 'package:axol_inventarios/utilities/theme/textfield_decoration.dart';
import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/data_find.dart';
import '../../models/textfield_form_model.dart';
import 'button.dart';
import 'progress_indicator.dart';

class DrawerFind extends StatelessWidget {
  final String lblText;
  final List<DataFind> listData;
  final Function()? onPressed;
  final Function(String value)? onSubmitted;
  final bool? isLoading;
  final List<DrawerColumn>? headerTable;

  const DrawerFind({
    super.key,
    required this.lblText,
    this.onPressed,
    required this.listData,
    this.isLoading,
    this.onSubmitted,
    this.headerTable,
  });

  @override
  Widget build(BuildContext context) {
    final form = context.read<FinderForm>().state;
    TextfieldFormModel upForm = form;
    TextEditingController controller = TextEditingController();
    controller.value = TextEditingValue(
        text: form.value,
        selection: TextSelection.collapsed(offset: form.position));
    final headerTable_ = headerTable ?? [];
    List<Widget> subtitleList = [];
    Widget subtitle;
    List<Widget> contentList;
    for (DrawerColumn element in headerTable_) {
      subtitle = Expanded(
        flex: element.flex ?? 1,
          child: Text(
        element.subtitle,
        style: Typo.bodyDark,
      ));
      subtitleList.add(subtitle);
    }
    if () {
      
    }
    return DrawerBox(
      padding: const EdgeInsets.all(8),
      header: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: TextFieldDecoration.inputForm(lblText: lblText),
                  cursorColor: ColorPalette.primary,
                  style: Typo.bodyDark,
                  onSubmitted: onSubmitted,
                  onChanged: (value) {
                    upForm.value = value;
                    upForm.position = controller.selection.base.offset;
                    context.read<FinderForm>().setForm(upForm);
                  },
                ),
              ),
              IconButton(
                onPressed: onPressed,
                icon: const Icon(
                  Icons.close,
                  color: ColorPalette.lightItems,
                ),
              )
            ],
          ),
          Visibility(
              visible: headerTable != null && headerTable != [],
              child: Row(
                children: subtitleList,
              ))
        ],
      ),
      actions: [
        ButtonReturnDialog(
          isLoading: false,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
      child: isLoading != true
          ? Expanded(
              child: ListView.builder(
              shrinkWrap: true,
              itemCount: listData.length,
              itemBuilder: (context, index) {
                final data = listData[index];
                return ButtonRowTable(
                  onPressed: () {
                    Navigator.pop(context, data);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          data.id.toString(),
                          style: Typo.bodyDark,
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          data.description,
                          style: Typo.bodyDark,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ))
          : const Expanded(
              child: Column(
              children: [
                LinearProgressIndicatorAxol(),
                Expanded(child: SizedBox()),
              ],
            )),
    );
  }
}

abstract class DrawerFindState extends Equatable {
  const DrawerFindState();
}

class InitialDrawerFindState extends DrawerFindState {
  @override
  List<Object?> get props => [];
}

class LoadingDrawerFindState extends DrawerFindState {
  @override
  List<Object?> get props => [];
}

class LoadedDrawerFindState extends DrawerFindState {
  final List<DataFind> dataList;
  const LoadedDrawerFindState({required this.dataList});
  @override
  List<Object?> get props => [dataList];
}

class ErrorDrawerFindState extends DrawerFindState {
  final String error;
  const ErrorDrawerFindState({required this.error});
  @override
  String toString() => 'Error: $error';
  @override
  List<Object?> get props => [error];
}

class FinderForm extends Cubit<TextfieldFormModel> {
  FinderForm() : super(TextfieldFormModel.empty());

  void setForm(TextfieldFormModel form) {
    emit(TextfieldFormModel.empty());
    emit(form);
  }
}

class DrawerColumn {
  final String subtitle;
  final int? flex;

  DrawerColumn(this.subtitle, {this.flex});
}

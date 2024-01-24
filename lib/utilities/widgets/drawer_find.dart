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
  final List<DataFind>? listData;
  final List<DataFindValues>? listValues;
  final Function()? onPressed;
  final Function(String value)? onSubmitted;
  final bool? isLoading;
  final List<DrawerColumn>? headerTable;

  const DrawerFind({
    super.key,
    required this.lblText,
    this.onPressed,
    this.listData,
    this.isLoading,
    this.onSubmitted,
    this.headerTable,
    this.listValues,
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
    final List listData_;
    for (DrawerColumn element in headerTable_) {
      subtitle = Expanded(
          flex: element.flex ?? 1,
          child: Text(
            element.subtitle,
            style: Typo.subtitleDark,
            textAlign: TextAlign.center,
          ));
      subtitleList.add(subtitle);
    }
    if (listValues != null) {
      listData_ = listValues ?? [];
    } else if (listData != null) {
      listData_ = listData ?? [];
    } else {
      listData_ = [];
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
              visible: subtitleList.isNotEmpty && isLoading != true,
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
              itemCount: listData_.length,
              itemBuilder: (context, index) {
                final data = listData_[index];
                if (data is DataFind) {
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
                } else if (data is DataFindValues) {
                  Widget contentElement;
                  List<Widget> listContent = [];
                  int flex;
                  for (int i = 0; i < data.values.length; i++) {
                    final value = data.values[i];
                    if (i >= headerTable_.length ||
                        headerTable_[i].flex == null) {
                      flex = 1;
                    } else {
                      flex = headerTable_[i].flex ?? 1;
                    }
                    contentElement = Expanded(
                      flex: flex,
                      child: Text(
                        value,
                        style: Typo.bodyDark,
                        textAlign: TextAlign.center,
                      ),
                    );
                    listContent.add(contentElement);
                  }
                  return ButtonRowTable(
                    onPressed: () {
                      Navigator.pop(context, data);
                    },
                    child: Row(
                      children: listContent,
                    ),
                  );
                } else {
                  return null;
                }
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
  final List<DataFindValues> valuesList;
  final List<DataFind> dataList;
  const LoadedDrawerFindState(
      {required this.dataList, required this.valuesList});
  @override
  List<Object?> get props => [dataList, valuesList];
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

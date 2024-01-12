import 'package:axol_inventarios/utilities/theme/textfield_decoration.dart';
import 'package:axol_inventarios/utilities/theme/theme.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/data_find.dart';
import 'button.dart';

class DrawerFind extends StatelessWidget {
  final String lblText;
  final List<DataFind> listData;
  final Function() onPressFind;

  const DrawerFind({
    super.key,
    required this.lblText,
    required this.onPressFind,
    required this.listData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      builder: (context, state) {
        
      },
    );
  }

  Widget drawerFind(BuildContext context) {
    return DrawerBox(
      header: Row(
        children: [
          Expanded(
              child: TextField(
            decoration: TextFieldDecoration.inputForm(lblText: lblText),
            cursorColor: ColorPalette.primary,
            style: Typo.bodyDark,
          )),
          IconButton(
            onPressed: onPressFind,
            icon: const Icon(
              Icons.close,
              color: ColorPalette.lightItems,
            ),
          )
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
      ),
    );
  }
}

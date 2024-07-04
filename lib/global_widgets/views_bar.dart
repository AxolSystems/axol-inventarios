import 'package:flutter/material.dart';

import '../models/elemnets_bar_model.dart';

class ViewsBar extends StatelessWidget {
  final List<ElementsBarModel> listData;

  const ViewsBar({super.key, required this.listData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: double.infinity,
      color: Colors.black12,
      //decoration: BoxDecoration(border: Border.all(color: Colors.white30)),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white12),
            right: BorderSide(color: Colors.white12),
          ),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: listData.length,
          itemBuilder: ((context, index) {
            final elementList = listData[index];
            return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
              child: /*IconButton(
              onPressed: elementList.action,
              icon: elementList.icon!,
              color: Colors.white70,
            ),*/
                  OutlinedButton.icon(
                onPressed: elementList.action,
                icon: elementList.icon!,
                label: Text(elementList.text!,
                    style: const TextStyle(color: Colors.white70)),
                style: const ButtonStyle(
                    iconColor: MaterialStatePropertyAll(Colors.white70)),
              ),
            );
          }),
        ),
      ),
    );
  }
}

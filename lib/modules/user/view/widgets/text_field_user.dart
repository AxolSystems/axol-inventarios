import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utilities/theme/theme.dart';
import '../../cubit/login_txt_cubit.dart';

class TextFieldUser extends StatelessWidget {
  const TextFieldUser({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: ColorPalette.primary,
      onChanged: (value) {
        context.read<UserTxtCubit>().change(value);
      },
      autofocus: false,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorPalette.primary),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: 'Usuario',
        hintStyle: Typo.hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: ColorPalette.lightBackground,
      ),
    );
  }
}

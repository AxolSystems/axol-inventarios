import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/login/login_cubit.dart';
import '../../cubit/login_txt_cubit.dart';
import '../controllers/login_controller.dart';

import '../../../../utilities/theme/theme.dart';
import '../controllers/password_visibility_cubit.dart';
import '../widgets/button_login.dart';
import '../widgets/logo.dart';
import '../widgets/text_field_password.dart';
import '../widgets/text_field_user.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => LoginCubit()),
          BlocProvider(create: (_) => PasswordVisibilityCubit()),
          BlocProvider(create: (_) => PasswordTxtCubit()),
          BlocProvider(create: (_) => UserTxtCubit()),
        ],
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: ColorPalette.darkBackground,
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                //shrinkWrap: true,
                children: [
                  Visibility(
                      visible: MediaQuery.of(context).size.height > 570,
                      child: const Logo()),
                  const Center(
                    child: SizedBox(
                      width: 800,
                      height: 220,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(24, 8, 24, 8),
                            child: TextFieldUser(),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(24, 8, 24, 8),
                            child: TextFieldPassword(),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(24, 8, 24, 0),
                            child: ButtonLogin(),
                          ),
                          LoginController(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}

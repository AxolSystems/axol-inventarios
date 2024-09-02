import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../main_/view/main_view.dart';
import '../../model/user_model.dart';
import '../views/home_view.dart';
import '../views/login_view.dart';
import '../views/splash_view.dart';
import '../../cubit/auth/auth_cubit.dart';
import '../../cubit/auth/auth_state.dart';

class AuthController extends StatelessWidget {
  const AuthController({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: BlocProvider.of<AuthCubit>(context)..getUserState(),
      builder: (BuildContext context, AuthState state) {
        if (state is AuthLoadingState) {
          return const SplashView();
        } else if (state is AuthAuthenticatedState) {
          final rol = state.user.rol;
          if (rol == UserModel.rolVendor) {
            //return const HomeView();
            return const MainView();
          } else if (rol == UserModel.rolAdmin) {
            //return const HomeView();
            return const MainView();
          } else if (rol == UserModel.rolSup) {
            //return const HomeView();
            return const MainView();
          } else {
            return const Text('Error: no entró a página.');
          }
        } else if (state is AuthUnuauthenticatedState) {
          return const Center(child: LoginView());
        } else if (state is AuthErrorState) {
          return Center(
            child: Text(state.toString()),
          );
        } else {
          return const Center(
            child: Text('Error: no se recibió estado.'),
          );
        }
      },
    );
  }
}

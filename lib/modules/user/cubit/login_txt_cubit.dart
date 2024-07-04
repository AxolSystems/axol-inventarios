import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordTxtCubit extends Cubit<String> {
  PasswordTxtCubit() : super('');

  void change(String text) {
    emit(text);
  }
}

class UserTxtCubit extends Cubit<String> {
  UserTxtCubit() : super('');

  void change(String text) {
    emit(text);
  }
}

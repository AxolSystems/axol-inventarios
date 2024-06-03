import 'package:flutter_bloc/flutter_bloc.dart';

enum CustomerDetailsState {init, loading, load, error}

class CustomerDetailsCubit extends Cubit<CustomerDetailsState> {
  CustomerDetailsCubit() : super(CustomerDetailsState.init);

  Future<void> load() async {
    try {
      emit(CustomerDetailsState.init);
      emit(CustomerDetailsState.loading);
      emit(CustomerDetailsState.load);
    } catch (e) {
      emit(CustomerDetailsState.init);
      emit(CustomerDetailsState.error);
    }
  }
}
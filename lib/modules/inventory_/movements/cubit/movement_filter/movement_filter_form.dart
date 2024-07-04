import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/movement_filter_form_model.dart';

class MovementFilterForm extends Cubit {
  MovementFilterForm() : super(MovementFilterFormModel.empty());
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/product_edit_form_model.dart';

class ProductEditForm extends Cubit<ProductEditFormModel> {
  ProductEditForm() : super(ProductEditFormModel.empty());
}
import 'package:axol_inventarios/modules/sale/vendor/model/vendor_model.dart';

import '../../../../models/textfield_form_model.dart';

class VendorAddFormModel {
  TextfieldFormModel id;
  TextfieldFormModel name;

  static const String _lblId = 'Id: ';
  static const String _lblName = 'Nombre: ';


  final Map<String, String> _mapLbl = {
    VendorModel.empty().tId: _lblId,
    VendorModel.empty().tName: _lblName,
  };

  final String _emIdInvalid = 'Id invalido';
  final String _emNameInvalid = 'Nombre invalido';

  String get lblId => _lblId;
  String get lblName => _lblName;

  Map<String, String> get mapLbl => _mapLbl;

  String get emIdInvalid => _emIdInvalid;
  String get emNameInvalid => _emNameInvalid;

  VendorAddFormModel({
    required this.id,
    required this.name,
  });

  VendorAddFormModel.empty()
      : id = TextfieldFormModel.initKey(
          key: VendorModel.empty().tId,
          tags: [],
        ),
        name = TextfieldFormModel.initKey(
          key: VendorModel.empty().tName,
          tags: [],
        )
        ;

  VendorAddFormModel.listToForm(List<TextfieldFormModel> list)
      : id = list.singleWhere((x) => x.key == VendorModel.empty().tId),
        name = list.singleWhere((x) => x.key == VendorModel.empty().tName);

  static List<TextfieldFormModel> formToList(VendorAddFormModel form) {
    final TextfieldFormModel id = form.id;
    final TextfieldFormModel name = form.name;
    final List<TextfieldFormModel> list = [
      id,
      name,
    ];
    return list;
  }

  static VendorModel formToVendor(VendorAddFormModel form) =>
      VendorModel(
        id: int.tryParse(form.id.value) ?? -1,
        name: form.name.value,
      );
}
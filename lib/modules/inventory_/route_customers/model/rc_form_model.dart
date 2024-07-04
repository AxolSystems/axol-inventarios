import '../../../../models/textfield_form_model.dart';

class RcFormModel {
  TextfieldFormModel id;
  TextfieldFormModel name;
  TextfieldFormModel location;
  TextfieldFormModel address;
  TextfieldFormModel hood;
  TextfieldFormModel town;
  TextfieldFormModel country;
  TextfieldFormModel vendor;
  bool status;
  String user;

  RcFormModel({
    required this.id,
    required this.name,
    required this.location,
    required this.address,
    required this.hood,
    required this.town,
    required this.country,
    required this.status,
    required this.user,
    required this.vendor,
  });

  static RcFormModel empty() => RcFormModel(
        id: TextfieldFormModel.empty(),
        name: TextfieldFormModel.empty(),
        location: TextfieldFormModel.empty(),
        address: TextfieldFormModel.empty(),
        hood: TextfieldFormModel.empty(),
        town: TextfieldFormModel.empty(),
        country: TextfieldFormModel.empty(),
        vendor: TextfieldFormModel.empty(),
        status: true,
        user: '',
      );
}

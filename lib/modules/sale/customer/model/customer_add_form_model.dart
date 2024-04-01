import 'package:axol_inventarios/modules/sale/customer/model/customer_model.dart';

import '../../../../models/textfield_form_model.dart';

class CustomerAddFormModel {
  TextfieldFormModel id;
  TextfieldFormModel name;
  TextfieldFormModel phoneNumber;
  TextfieldFormModel rfc;
  TextfieldFormModel postalCode;
  TextfieldFormModel intNumber;
  TextfieldFormModel outNumber;
  TextfieldFormModel street;
  TextfieldFormModel hood;
  TextfieldFormModel town;
  TextfieldFormModel country;

  static const String _lblId = 'Id: ';
  static const String _lblName = 'Nombre: ';
  static const String _lblPhoneNumber = 'Telefono: ';
  static const String _lblRfc = 'RFC: ';
  static const String _lblPostalCode = 'Código postal: ';
  static const String _lblIntNumber = 'Número interior: ';
  static const String _lblOutNumber = 'Número exterior: ';
  static const String _lblStreet = 'Calle: ';
  static const String _lblHood = 'Colonia: ';
  static const String _lblTown = 'Ciudad: ';
  static const String _lblCountry = 'Estado: ';

  final Map<String, String> _mapLbl = {
    CustomerModel.empty().tCountry: _lblCountry,
    CustomerModel.empty().tHood: _lblHood,
    CustomerModel.empty().tId: _lblId,
    CustomerModel.empty().tIntNumber: _lblIntNumber,
    CustomerModel.empty().tName: _lblName,
    CustomerModel.empty().tOutNumbre: _lblOutNumber,
    CustomerModel.empty().tPhoneNumber: _lblPhoneNumber,
    CustomerModel.empty().tPostalCode: _lblPostalCode,
    CustomerModel.empty().tRfc: _lblRfc,
    CustomerModel.empty().tStreet: _lblStreet,
    CustomerModel.empty().tTown: _lblTown,
  };

  final String _emIdInvalid = 'Id invalido';
  final String _emNameInvalid = 'Nombre invalido';

  static const tagInteger = '#integer';
  static const tagDouble = '#double';
  static const tagSimple = '#simple';

  String get lblId => _lblId;
  String get lblName => _lblName;
  String get lblPhoneNumber => _lblPhoneNumber;
  String get lblRfc => _lblRfc;
  String get lblPostalCode => _lblPostalCode;
  String get lblIntNumber => _lblIntNumber;
  String get lblOutNumber => _lblOutNumber;
  String get lblStreet => _lblStreet;
  String get lblHood => _lblHood;
  String get lblTown => _lblTown;
  String get lblCountry => _lblCountry;

  Map<String, String> get mapLbl => _mapLbl;

  String get emIdInvalid => _emIdInvalid;
  String get emNameInvalid => _emNameInvalid;

  CustomerAddFormModel({
    required this.country,
    required this.hood,
    required this.id,
    required this.intNumber,
    required this.name,
    required this.outNumber,
    required this.phoneNumber,
    required this.postalCode,
    required this.rfc,
    required this.street,
    required this.town,
  });

  CustomerAddFormModel.empty()
      : id = TextfieldFormModel.initKey(
          key: CustomerModel.empty().tId,
          tags: [tagInteger],
        ),
        name = TextfieldFormModel.initKey(
          key: CustomerModel.empty().tName,
          tags: [tagSimple],
        ),
        phoneNumber = TextfieldFormModel.initKey(
          key: CustomerModel.empty().tPhoneNumber,
          tags: [tagSimple],
        ),
        rfc = TextfieldFormModel.initKey(
          key: CustomerModel.empty().tRfc,
          tags: [tagSimple],
        ),
        postalCode = TextfieldFormModel.initKey(
          key: CustomerModel.empty().tPostalCode,
          tags: [tagSimple],
        ),
        intNumber = TextfieldFormModel.initKey(
          key: CustomerModel.empty().tIntNumber,
          tags: [tagSimple],
        ),
        outNumber = TextfieldFormModel.initKey(
          key: CustomerModel.empty().tOutNumbre,
          tags: [tagSimple],
        ),
        street = TextfieldFormModel.initKey(
          key: CustomerModel.empty().tStreet,
          tags: [tagSimple],
        ),
        hood = TextfieldFormModel.initKey(
          key: CustomerModel.empty().tHood,
          tags: [tagSimple],
        ),
        town = TextfieldFormModel.initKey(
          key: CustomerModel.empty().tTown,
          tags: [tagSimple],
        ),
        country = TextfieldFormModel.initKey(
          key: CustomerModel.empty().tCountry,
          tags: [tagSimple],
        );

  CustomerAddFormModel.listToForm(List<TextfieldFormModel> list)
      : id = list.singleWhere((x) => x.key == CustomerModel.empty().tId),
        name = list.singleWhere((x) => x.key == CustomerModel.empty().tName),
        phoneNumber = list
            .singleWhere((x) => x.key == CustomerModel.empty().tPhoneNumber),
        rfc = list.singleWhere((x) => x.key == CustomerModel.empty().tRfc),
        postalCode =
            list.singleWhere((x) => x.key == CustomerModel.empty().tPostalCode),
        intNumber =
            list.singleWhere((x) => x.key == CustomerModel.empty().tIntNumber),
        outNumber =
            list.singleWhere((x) => x.key == CustomerModel.empty().tOutNumbre),
        street =
            list.singleWhere((x) => x.key == CustomerModel.empty().tStreet),
        hood = list.singleWhere((x) => x.key == CustomerModel.empty().tHood),
        town = list.singleWhere((x) => x.key == CustomerModel.empty().tTown),
        country =
            list.singleWhere((x) => x.key == CustomerModel.empty().tCountry);

  static List<TextfieldFormModel> formToList(CustomerAddFormModel form) {
    final TextfieldFormModel id = form.id;
    final TextfieldFormModel name = form.name;
    final TextfieldFormModel phoneNumber = form.phoneNumber;
    final TextfieldFormModel rfc = form.rfc;
    final TextfieldFormModel postalCode = form.postalCode;
    final TextfieldFormModel intNumber = form.intNumber;
    final TextfieldFormModel outNumber = form.outNumber;
    final TextfieldFormModel street = form.street;
    final TextfieldFormModel hood = form.hood;
    final TextfieldFormModel town = form.town;
    final TextfieldFormModel country = form.country;
    final List<TextfieldFormModel> list = [
      id,
      name,
      phoneNumber,
      rfc,
      postalCode,
      intNumber,
      outNumber,
      street,
      hood,
      town,
      country,
    ];
    return list;
  }

  static CustomerModel formToCustomer(CustomerAddFormModel form) =>
      CustomerModel.all(
        id: int.tryParse(form.id.value) ?? -1,
        name: form.name.value,
        country: form.country.value,
        hood: form.hood.value,
        intNumber: form.intNumber.value,
        outNumber: form.outNumber.value,
        phoneNumber: form.phoneNumber.value,
        postalCode: form.postalCode.value,
        rfc: form.rfc.value,
        street: form.street.value,
        town: form.town.value,
      );

  static CustomerAddFormModel allTrueLoading(CustomerAddFormModel form) {
    CustomerAddFormModel upForm = form;
    List<TextfieldFormModel> listForm = formToList(form);
    for (var element in listForm) {
      element.isLoading = true;
    }
    upForm = CustomerAddFormModel.listToForm(listForm);
    return upForm;
  }

  static CustomerAddFormModel allFalseLoading(CustomerAddFormModel form) {
    CustomerAddFormModel upForm = form;
    List<TextfieldFormModel> listForm = formToList(form);
    for (var element in listForm) {
      element.isLoading = false;
    }
    upForm = CustomerAddFormModel.listToForm(listForm);
    return upForm;
  }
}

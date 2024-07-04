class CustomerModel {
  final int id;
  final String name;
  final String? rfc;
  final String? street;
  final String? outNumber;
  final String? intNumber;
  final String? hood;
  final String? postalCode;
  final String? town;
  final String? country;
  final String? phoneNumber;

  static const String _id = 'id';
  static const String _name = 'name';
  static const String _rfc = 'rfc';
  static const String _street = 'street';
  static const String _outNumber = 'outNumber';
  static const String _intNumber = 'intNumber';
  static const String _hood = 'hood';
  static const String _postalCode = 'postalCode';
  static const String _town = 'town';
  static const String _country = 'country';
  static const String _phoneNumber = 'phoneNumber';

  String get tId => _id;
  String get tName => _name;
  String get tRfc => _rfc;
  String get tStreet => _street;
  String get tOutNumbre => _outNumber;
  String get tIntNumber => _intNumber;
  String get tHood => _hood;
  String get tPostalCode => _postalCode;
  String get tTown => _town;
  String get tCountry => _country;
  String get tPhoneNumber => _phoneNumber;

  static const String lblId = 'Id: ';
  static const String lblName = 'Nombre: ';
  static const String lblPhoneNumber = 'Telefono: ';
  static const String lblRfc = 'RFC: ';
  static const String lblPostalCode = 'Código postal: ';
  static const String lblIntNumber = 'Número interior: ';
  static const String lblOutNumber = 'Número exterior: ';
  static const String lblStreet = 'Calle: ';
  static const String lblHood = 'Colonia: ';
  static const String lblTown = 'Ciudad: ';
  static const String lblCountry = 'Estado: ';

  const CustomerModel({
    required this.id,
    required this.name,
    this.country,
    this.hood,
    this.intNumber,
    this.outNumber,
    this.phoneNumber,
    this.postalCode,
    this.rfc,
    this.street,
    this.town,
  });

  CustomerModel.empty()
    : id = -1,
      name = '',
      country = '',
      hood = '',
      intNumber = '',
      outNumber = '',
      phoneNumber = '',
      postalCode = '',
      rfc = '',
      street = '',
      town = '';

  CustomerModel.all({
    required this.id,
    required this.name,
    required this.country,
    required this.hood,
    required this.intNumber,
    required this.outNumber,
    required this.phoneNumber,
    required this.postalCode,
    required this.rfc,
    required this.street,
    required this.town,
  });

  CustomerModel.fill(Map<String, dynamic> map)
    : id = map[_id],
      name = map[_name].toString(),
      country = '${map[_country] ?? ''}',
      hood = '${map[_hood] ?? ''}',
      intNumber = '${map[_intNumber] ?? ''}',
      outNumber = '${map[_outNumber] ?? ''}',
      phoneNumber = '${map[_phoneNumber] ?? ''}',
      postalCode = '${map[_postalCode] ?? ''}',
      rfc = '${map[_rfc] ?? ''}',
      street = '${map[_street] ?? ''}',
      town = '${map[_town] ?? ''}';
}

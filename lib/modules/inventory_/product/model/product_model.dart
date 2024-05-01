class ProductModel {
  final String code;
  final String description;
  final int class_;
  final double price;
  final String unitSale;
  final Map<String, dynamic>? properties;
  final String? type;
  final double? gauge;
  final String? pieces;
  final double? weight;
  final String? measure;
  final String? packing;
  final String? capacity;

  static const String tCode = 'code';
  static const String tDescription = 'description';
  static const String tType = 'type';
  static const String tGauge = 'gauge';
  static const String tPieces = 'pices';
  static const String tWeight = 'weight';
  static const String tMeasure = 'measure';
  static const String tPacking = 'packing';
  static const String tCapacity = 'capacity';

  static String get lblCode => 'Clave';
  static String get lblDescription => 'Descripción';
  static String get lblType => 'Tipo';
  static String get lblGauge => 'Calibre';
  static String get lblPieces => 'Piezas';
  static String get lblWeight => 'Peso';
  static String get lblMeasure => 'Medida';
  static String get lblPacking => 'Empaque';
  static String get lblCapacity => 'Capacidad';

  ProductModel({
    required this.code,
    required this.description,
    required this.class_,
    required this.price,
    required this.unitSale,
    this.properties,
    this.type,
    this.gauge,
    this.pieces,
    this.weight,
    this.measure,
    this.packing,
    this.capacity,
  });

  static ProductModel empty() {
    return ProductModel(
        code: '',
        description: '',
        price: 0,
        unitSale: '',
        properties: {
          tCode: '',
          tDescription: '',
          tType: '',
          tGauge: '',
          tPieces: '',
          tWeight: '',
          tMeasure: '',
          tPacking: '',
          tCapacity: '',
        },
        class_: -1);
  }

  static ProductModel sortProduct(ProductModel product) {
    ProductModel newProduct;
    Map<String, dynamic> newMap = {};
    final List<String> propList =
        List.from(ProductModel.empty().properties!.keys);
    for (var element in propList) {
      if (product.properties!.containsKey(element)) {
        newMap[element] = product.properties![element];
      }
    }
    newProduct = ProductModel(
      code: product.code,
      description: product.description,
      properties: newMap,
      class_: product.class_,
      price: product.price,
      unitSale: product.unitSale
    );
    return newProduct;
  }

  ProductModel.singleCode(this.code)
      : description = '',
        price = 0,
        unitSale = '',
        capacity = null,
        class_ = -1,
        gauge = null,
        measure = null,
        packing = null,
        pieces = null,
        properties = null,
        type = null,
        weight = null;
}

class SaleFilterModel {
  final int customer;
  final int vendor;
  final int warehouse;
  final DateTime startTime;
  final DateTime endTime;
  final int? limit;
  final int? rangeMin;
  final int? rangeMax;
  final String? currentFind;

  SaleFilterModel({
    required this.customer,
    required this.vendor,
    required this.warehouse,
    required this.startTime,
    required this.endTime,
    this.limit,
    this.rangeMin, 
    this.rangeMax,
    this.currentFind,
  });

  SaleFilterModel.empty()
      : customer = -1,
        vendor = -1,
        warehouse = -1,
        limit = 0,
        rangeMin = null,
        rangeMax = null,
        startTime = DateTime.fromMillisecondsSinceEpoch(0),
        endTime = DateTime.fromMillisecondsSinceEpoch(32503708800000),
        currentFind = null;
  
  SaleFilterModel.limit(this.limit, {SaleFilterModel? saleFilter})
      : customer = saleFilter?.customer ?? SaleFilterModel.empty().customer,
        vendor = saleFilter?.vendor ?? SaleFilterModel.empty().vendor,
        warehouse = saleFilter?.warehouse ?? SaleFilterModel.empty().warehouse,
        rangeMin = saleFilter?.rangeMin ?? SaleFilterModel.empty().rangeMin,
        rangeMax = saleFilter?.rangeMax ?? SaleFilterModel.empty().rangeMax,
        startTime = saleFilter?.startTime ?? SaleFilterModel.empty().startTime,
        endTime = saleFilter?.endTime ?? SaleFilterModel.empty().endTime,
        currentFind = saleFilter?.currentFind ?? SaleFilterModel.empty().currentFind;

  SaleFilterModel.range({required this.rangeMin, required this.rangeMax, SaleFilterModel? saleFilter})
      : customer = saleFilter?.customer ?? SaleFilterModel.empty().customer,
        vendor = saleFilter?.vendor ?? SaleFilterModel.empty().vendor,
        warehouse = saleFilter?.warehouse ?? SaleFilterModel.empty().warehouse,
        limit = saleFilter?.limit ?? SaleFilterModel.empty().limit,
        startTime = saleFilter?.startTime ?? SaleFilterModel.empty().startTime,
        endTime = saleFilter?.endTime ?? SaleFilterModel.empty().endTime,
        currentFind = saleFilter?.currentFind ?? SaleFilterModel.empty().currentFind;
  
  SaleFilterModel.currentFind(this.currentFind, {SaleFilterModel? saleFilter})
      : customer = saleFilter?.customer ?? SaleFilterModel.empty().customer,
        vendor = saleFilter?.vendor ?? SaleFilterModel.empty().vendor,
        warehouse = saleFilter?.warehouse ?? SaleFilterModel.empty().warehouse,
        rangeMin = saleFilter?.rangeMin ?? SaleFilterModel.empty().rangeMin,
        rangeMax = saleFilter?.rangeMax ?? SaleFilterModel.empty().rangeMax,
        startTime = saleFilter?.startTime ?? SaleFilterModel.empty().startTime,
        endTime = saleFilter?.endTime ?? SaleFilterModel.empty().endTime,
        limit = saleFilter?.limit ?? SaleFilterModel.empty().limit;
}

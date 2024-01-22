import 'package:axol_inventarios/modules/sale/sale_note/view/views/salenote_drawer_note.dart';
import 'package:axol_inventarios/modules/sale/sale_note/view/views/salenote_tab.dart';
import 'package:axol_inventarios/utilities/widgets/drawer_find.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/inventory_/inventory/cubit/warehouse_find/warehouse_find_cubit.dart';
import '../../modules/inventory_/inventory/view/views/warehouse_drawer_find.dart';
import '../../modules/inventory_/product/cubit/product_find/product_find_cubit.dart';
import '../../modules/inventory_/product/view/product_drawer_find.dart';
import '../../modules/sale/customer/cubit/customer_add/customer_add_cubit.dart';
import '../../modules/sale/customer/cubit/customer_add/customer_add_form.dart';
import '../../modules/sale/customer/cubit/customer_delete/customer_delete_cubit.dart';
import '../../modules/sale/customer/cubit/customer_find/customer_find_cubit.dart';
import '../../modules/sale/customer/cubit/customer_tab/customer_tab_cubit.dart';
import '../../modules/sale/customer/cubit/customer_tab/customer_tab_form.dart';
import '../../modules/sale/customer/model/customer_model.dart';
import '../../modules/sale/customer/view/customer_dialog_delete.dart';
import '../../modules/sale/customer/view/customer_drawer_add.dart';
import '../../modules/sale/customer/view/customer_drawer_find.dart';
import '../../modules/sale/customer/view/customer_tab.dart';
import '../../modules/sale/sale_note/cubit/salenote_add/salenote_add_cubit.dart';
import '../../modules/sale/sale_note/cubit/salenote_add/salenote_add_form.dart';
import '../../modules/sale/sale_note/cubit/salenote_note/salenote_note_cubit.dart';
import '../../modules/sale/sale_note/cubit/salenote_tab/salenote_tab_form.dart';
import '../../modules/sale/sale_note/cubit/salenote_tab/salenote_tab_cubit.dart';
import '../../modules/sale/sale_note/model/salenote_row_form_model.dart';
import '../../modules/sale/sale_note/view/views/salenote_add.dart';
import '../../modules/sale/vendor/cubit/vendor_add/vendor_add_cubit.dart';
import '../../modules/sale/vendor/cubit/vendor_add/vendor_add_form.dart';
import '../../modules/sale/vendor/cubit/vendor_delete/customer_delete_cubit.dart';
import '../../modules/sale/vendor/cubit/vendor_find/vendor_find_cubit.dart';
import '../../modules/sale/vendor/cubit/vendor_tab/vendor_tab_cubit.dart';
import '../../modules/sale/vendor/cubit/vendor_tab/vendor_tab_form.dart';
import '../../modules/sale/vendor/model/vendor_model.dart';
import '../../modules/sale/vendor/view/vendor_dialog_delete.dart';
import '../../modules/sale/vendor/view/vendor_drawer_add.dart';
import '../../modules/sale/vendor/view/vendor_drawer_find.dart';
import '../../modules/sale/vendor/view/vendor_tab.dart';

abstract class Providers extends StatelessWidget {
  const Providers({super.key});
}

//----Customer
class ProviderCustomerAdd extends Providers {
  const ProviderCustomerAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (_) => CustomerAddForm()),
      BlocProvider(create: (_) => CustomerAddCubit()),
    ], child: const CustomerDrawerAdd());
  }
}

class ProviderCustomerDelete extends Providers {
  final CustomerModel customer;
  const ProviderCustomerDelete({super.key, required this.customer});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(providers: [
        BlocProvider(create: (_) => CustomerDeleteCubit()),
      ], child: CustomerDialogDelete(customer: customer));
}

class ProviderCustomerTab extends Providers {
  const ProviderCustomerTab({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(providers: [
        BlocProvider(create: (_) => CustomerTabCubit()),
        BlocProvider(create: (_) => CustomerTabForm()),
      ], child: const CustomerTab());
}

class ProviderCustomerFind extends Providers {
  const ProviderCustomerFind({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(providers: [
        BlocProvider(create: (_) => CustomerFindCubit()),
        BlocProvider(create: (_) => FinderForm()),
      ], child: const CustomerDrawerFind());
}

//----Product
class ProviderProductFind extends Providers {
  const ProviderProductFind({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(providers: [
        BlocProvider(create: (_) => ProductFindCubit()),
        BlocProvider(create: (_) => FinderForm()),
      ], child: const ProductDrawerFindAll());
}

//----SaleNote
class ProviderSaleNoteTab extends Providers {
  const ProviderSaleNoteTab({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(providers: [
        BlocProvider(create: (_) => SaleNoteTabCubit()),
        BlocProvider(create: (_) => SaleNoteTabForm()),
      ], child: const SaleNoteTab());
}

class ProviderSaleNoteAdd extends Providers {
  const ProviderSaleNoteAdd({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(providers: [
        BlocProvider(create: (_) => SaleNoteAddCubit()),
        BlocProvider(create: (_) => SaleNoteAddForm()),
      ], child: const SaleNoteAdd());
}

class ProviderSaleNoteNote extends Providers {
  final SaleNoteRowFormModel row;
  const ProviderSaleNoteNote({super.key, required this.row});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(providers: [
        BlocProvider(create: (_) => SaleNoteNoteCubit()),
      ], child: SaleNoteDrawerNote(row: row,));
}

//----Vendor
class ProviderVendorTab extends Providers {
  const ProviderVendorTab({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(providers: [
        BlocProvider(create: (_) => VendorTabCubit()),
        BlocProvider(create: (_) => VendorTabForm()),
      ], child: const VendorTab());
}

class ProviderVendorAdd extends Providers {
  const ProviderVendorAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (_) => VendorAddForm()),
      BlocProvider(create: (_) => VendorAddCubit()),
    ], child: const VendorDrawerAdd());
  }
}

class ProviderVendorDelete extends Providers {
  final VendorModel vendor;
  const ProviderVendorDelete({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(providers: [
        BlocProvider(create: (_) => VendorDeleteCubit()),
      ], child: VendorDialogDelete(vendor: vendor));
}

class ProviderVendorFind extends Providers {
  const ProviderVendorFind({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(providers: [
        BlocProvider(create: (_) => VendorFindCubit()),
        BlocProvider(create: (_) => FinderForm()),
      ], child: const VendorDrawerFind());
}

//----Warehouse
class ProviderWarehouseFind extends Providers {
  const ProviderWarehouseFind({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(providers: [
        BlocProvider(create: (_) => WarehouseFindCubit()),
        BlocProvider(create: (_) => FinderForm()),
      ], child: const WarehouseDrawerFind());
}
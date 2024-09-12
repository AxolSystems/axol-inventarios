import 'package:axol_inventarios/modules/inventory_/product/model/product_model.dart';
import 'package:axol_inventarios/modules/sale/sale_note/model/salenote_filter_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/data_response_model.dart';
import '../../../../inventory_/product/repository/product_repo.dart';
import '../../model/sale_note_model.dart';
import '../../model/sale_product_model.dart';
import '../../repository/sale_file_repo.dart';
import '../../repository/sale_note_repo.dart';
import '../../repository/sale_referral_repo.dart';
import 'snt_down_dialog_state.dart';

class SntDownDialogCubit extends Cubit<SntDownDialogState> {
  SntDownDialogCubit() : super(InitialSntDownDialogState());

  Future<void> initLoad() async {
    try {
      emit(InitialSntDownDialogState());
      emit(const LoadingSntDownDialogState(btnDownLoading: false));

      emit(DownloadedSntDownDialogState());
    } catch (e) {
      emit(InitialSntDownDialogState());
      emit(ErrorSntDownDialogState(error: e.toString()));
    }
  }

  Future<void> load() async {
    try {
      emit(InitialSntDownDialogState());
      emit(const LoadingSntDownDialogState(btnDownLoading: false));

      emit(DownloadedSntDownDialogState());
    } catch (e) {
      emit(InitialSntDownDialogState());
      emit(ErrorSntDownDialogState(error: e.toString()));
    }
  }

  Future<void> down(int saleType, SaleFilterModel filter) async {
    try {
      DataResponseModel dataResponse;
      List<SaleNoteModel> salenoteListDB = [];
      List<String> codeList = [];
      String code;
      List<ProductModel> productList;
      List<SaleProductModel> upSaleProduct = [];
      emit(InitialSntDownDialogState());
      emit(const LoadingSntDownDialogState(btnDownLoading: true));
      if (saleType == 0) {
        dataResponse =
            await SaleNoteRepo().fetchNotes(filter, filter.currentFind ?? '');
        if (dataResponse.dataList is List<SaleNoteModel>) {
          salenoteListDB = dataResponse.dataList as List<SaleNoteModel>;
          for (var salenote in salenoteListDB) {
            for (var element in salenote.saleProduct) {
              code = element.product.code;
              if (codeList.contains(code) == false) {
                codeList.add(code);
              }
            }
          }
          productList = await ProductRepo().fetchProductListCode(codeList);
          for (int i = 0; i < salenoteListDB.length; i++) {
            final saleNote = salenoteListDB[i];
            upSaleProduct = [];
            for (int i = 0; i < saleNote.saleProduct.length; i++) {
              final product = productList.firstWhere(
                  (x) => x.code == saleNote.saleProduct[i].product.code);
              upSaleProduct.add(SaleProductModel.setProduct(
                  product: product, productSale: saleNote.saleProduct[i]));
            }
            salenoteListDB[i] = SaleNoteModel.setSaleProduct(
              saleProduct: upSaleProduct,
              saleNote: salenoteListDB[i],
            );
          }
        }
      } else if (saleType == 1) {
        dataResponse =
            await SaleReferralRepo().fetchReferral(filter, filter.currentFind ?? '');
        if (dataResponse.dataList is List<SaleNoteModel>) {
          salenoteListDB = dataResponse.dataList as List<SaleNoteModel>;
          for (var salenote in salenoteListDB) {
            for (var element in salenote.saleProduct) {
              code = element.product.code;
              if (codeList.contains(code) == false) {
                codeList.add(code);
              }
            }
          }
          productList = await ProductRepo().fetchProductListCode(codeList);
          for (int i = 0; i < salenoteListDB.length; i++) {
            final saleNote = salenoteListDB[i];
            upSaleProduct = [];
            for (int i = 0; i < saleNote.saleProduct.length; i++) {
              final product = productList.firstWhere(
                  (x) => x.code == saleNote.saleProduct[i].product.code);
              upSaleProduct.add(SaleProductModel.setProduct(
                  product: product, productSale: saleNote.saleProduct[i]));
            }
            salenoteListDB[i] = SaleNoteModel.setSaleProduct(
              saleProduct: upSaleProduct,
              saleNote: salenoteListDB[i],
            );
          }
        }
      }
      //await SaleFileRepo.saleListCsv(salenoteListDB);
      emit(DownloadedSntDownDialogState());
    } catch (e) {
      emit(InitialSntDownDialogState());
      emit(ErrorSntDownDialogState(error: e.toString()));
    }
  }
}

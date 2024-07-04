import 'package:flutter/material.dart';

class CustomerFindFormModel {
  TextEditingController finder;
  int currentPage;
  int totalPages;
  int totalReg;

  CustomerFindFormModel({
    required this.currentPage,
    required this.finder,
    required this.totalPages,
    required this.totalReg,
  });

  CustomerFindFormModel.empty()
      : finder = TextEditingController(),
        currentPage = 0,
        totalPages = 0,
        totalReg = 0;
}

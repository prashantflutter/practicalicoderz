class CategoryModel {
  int? statusCode;
  String? message;
  List<CreditCategory>? creditCategory;
  List<DebitCategory>? debitCategory;

  CategoryModel(
      {this.statusCode, this.message, this.creditCategory, this.debitCategory});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['creditCategory'] != null) {
      creditCategory = <CreditCategory>[];
      json['creditCategory'].forEach((v) {
        creditCategory!.add(new CreditCategory.fromJson(v));
      });
    }
    if (json['debitCategory'] != null) {
      debitCategory = <DebitCategory>[];
      json['debitCategory'].forEach((v) {
        debitCategory!.add(new DebitCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.creditCategory != null) {
      data['creditCategory'] =
          this.creditCategory!.map((v) => v.toJson()).toList();
    }
    if (this.debitCategory != null) {
      data['debitCategory'] =
          this.debitCategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CreditCategory {
  String? categoryId;
  String? categoryName;

  CreditCategory({this.categoryId, this.categoryName});

  CreditCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'].toString();
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    return data;
  }
}

class DebitCategory {
  String? categoryId;
  String? categoryName;

  DebitCategory({this.categoryId, this.categoryName});

  DebitCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'].toString();
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    return data;
  }
}
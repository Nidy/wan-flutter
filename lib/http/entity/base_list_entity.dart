import 'package:flutter/cupertino.dart';
import 'package:wanflutter/http/entity_factory.dart';
class BaseListEntity<T> {
  int errorCode;
  String errorMsg;
  List<T> data;

  BaseListEntity({@required this.errorCode, this.errorMsg, this.data});

  factory BaseListEntity.fromJson(json) {
    List<T> mData = List();
    if (json['data'] != null) {
      (json['data'] as List).forEach((v) {
        mData.add(EntityFactory.generateObj<T>(v));
      });
    }

    return BaseListEntity(
      errorCode: json['errorCode'],
      errorMsg: json['errorMsg'],
      data: mData,
    );
  }

}
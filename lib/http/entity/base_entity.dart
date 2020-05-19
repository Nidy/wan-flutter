import 'package:flutter/cupertino.dart';
import 'package:wanflutter/http/entity_factory.dart';

class BaseEntity<T> {
  int errorCode;
  String errorMsg;
  T data;

  BaseEntity({@required this.errorCode, this.errorMsg, this.data});

  factory BaseEntity.fromJson(json) {
    return BaseEntity(
      errorCode: json['errorCode'],
      errorMsg: json['errorMsg'],
      data: EntityFactory.generateObj<T>(json['data']),
    );
  }
}
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:wanflutter/http/entity/article_entity.dart';
import 'package:wanflutter/generated/json/article_entity_helper.dart';
import 'package:wanflutter/http/entity/user_entity.dart';
import 'package:wanflutter/generated/json/user_entity_helper.dart';
import 'package:wanflutter/http/entity/project_entity.dart';
import 'package:wanflutter/generated/json/project_entity_helper.dart';
import 'package:wanflutter/http/entity/category_entity.dart';
import 'package:wanflutter/generated/json/category_entity_helper.dart';
import 'package:wanflutter/http/entity/banner_entity.dart';
import 'package:wanflutter/generated/json/banner_entity_helper.dart';

class JsonConvert<T> {
	T fromJson(Map<String, dynamic> json) {
		return _getFromJson<T>(runtimeType, this, json);
	}

  Map<String, dynamic> toJson() {
		return _getToJson<T>(runtimeType, this);
  }

  static _getFromJson<T>(Type type, data, json) {
    switch (type) {			case ArticleEntity:
			return articleEntityFromJson(data as ArticleEntity, json) as T;			case UserEntity:
			return userEntityFromJson(data as UserEntity, json) as T;			case ProjectEntity:
			return projectEntityFromJson(data as ProjectEntity, json) as T;			case ProjectTag:
			return projectTagFromJson(data as ProjectTag, json) as T;			case CategoryEntity:
			return categoryEntityFromJson(data as CategoryEntity, json) as T;			case BannerEntity:
			return bannerEntityFromJson(data as BannerEntity, json) as T;    }
    return data as T;
  }

  static _getToJson<T>(Type type, data) {
		switch (type) {			case ArticleEntity:
			return articleEntityToJson(data as ArticleEntity);			case UserEntity:
			return userEntityToJson(data as UserEntity);			case ProjectEntity:
			return projectEntityToJson(data as ProjectEntity);			case ProjectTag:
			return projectTagToJson(data as ProjectTag);			case CategoryEntity:
			return categoryEntityToJson(data as CategoryEntity);			case BannerEntity:
			return bannerEntityToJson(data as BannerEntity);    }
    return data as T;
  }
  //Go back to a single instance by type
  static _fromJsonSingle(String type, json) {
    switch (type) {			case 'ArticleEntity':
			return ArticleEntity().fromJson(json);			case 'UserEntity':
			return UserEntity().fromJson(json);			case 'ProjectEntity':
			return ProjectEntity().fromJson(json);			case 'ProjectTag':
			return ProjectTag().fromJson(json);			case 'CategoryEntity':
			return CategoryEntity().fromJson(json);			case 'BannerEntity':
			return BannerEntity().fromJson(json);    }
    return null;
  }

  //empty list is returned by type
  static _getListFromType(String type) {
    switch (type) {			case 'ArticleEntity':
			return List<ArticleEntity>();			case 'UserEntity':
			return List<UserEntity>();			case 'ProjectEntity':
			return List<ProjectEntity>();			case 'ProjectTag':
			return List<ProjectTag>();			case 'CategoryEntity':
			return List<CategoryEntity>();			case 'BannerEntity':
			return List<BannerEntity>();    }
    return null;
  }

  static M fromJsonAsT<M>(json) {
    String type = M.toString();
    if (json is List && type.contains("List<")) {
      String itemType = type.substring(5, type.length - 1);
      List tempList = _getListFromType(itemType);
      json.forEach((itemJson) {
        tempList
            .add(_fromJsonSingle(type.substring(5, type.length - 1), itemJson));
      });
      return tempList as M;
    } else {
      return _fromJsonSingle(M.toString(), json) as M;
    }
  }
}
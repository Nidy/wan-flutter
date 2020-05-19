import 'package:flutter/cupertino.dart';
import 'package:wanflutter/http/entity_factory.dart';

class PageEntity<T> {
	int curPage;
	List<T> datas;
	int offset;
	bool over;
	int pageCount;
	int size;
	int total;

	PageEntity({this.curPage, @required this.datas, this.offset, this.over, this.pageCount, this.size, this.total});

	factory PageEntity.fromJson(json) {
		List<T> _data = List();
		if (json['datas'] != null) {
			(json['datas'] as List).forEach((v) {
				_data.add(EntityFactory.generateObj<T>(v));
			});
		}
		return PageEntity(
			curPage: json['curPage'],
			datas: _data,
			offset: json['offset'],
			over: json['over'],
			pageCount: json['pageCount'],
			size: json['size'],
			total: json['total']
		);
	}
}

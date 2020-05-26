import 'package:wanflutter/generated/json/base/json_convert_content.dart';

class CategoryEntity with JsonConvert<CategoryEntity> {
	List<dynamic> children;
	int courseId;
	int id;
	String name;
	int order;
	int parentChapterId;
	bool userControlSetTop;
	int visible;
}

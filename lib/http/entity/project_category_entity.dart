import 'package:wanflutter/generated/json/base/json_convert_content.dart';

class ProjectCategoryEntity with JsonConvert<ProjectCategoryEntity> {
	List<dynamic> children;
	int courseId;
	int id;
	String name;
	int order;
	int parentChapterId;
	bool userControlSetTop;
	int visible;
}

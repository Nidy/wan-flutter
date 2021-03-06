import 'package:wanflutter/generated/json/base/json_convert_content.dart';

class ProjectEntity with JsonConvert<ProjectEntity> {
	String apkLink;
	int audit;
	String author;
	bool canEdit;
	int chapterId;
	String chapterName;
	bool collect;
	int courseId;
	String desc;
	String descMd;
	String envelopePic;
	bool fresh;
	int id;
	String link;
	String niceDate;
	String niceShareDate;
	String origin;
	String prefix;
	String projectLink;
	int publishTime;
	int selfVisible;
	int shareDate;
	String shareUser;
	int superChapterId;
	String superChapterName;
	List<ProjectTag> tags;
	String title;
	int type;
	int userId;
	int visible;
	int zan;
}

class ProjectTag with JsonConvert<ProjectTag> {
	String name;
	String url;
}

import 'package:wanflutter/generated/json/base/json_convert_content.dart';

class UserEntity with JsonConvert<UserEntity> {
	bool admin;
	List<dynamic> chapterTops;
	List<dynamic> collectIds;
	String email;
	String icon;
	int id;
	String nickname;
	String password;
	String publicName;
	String token;
	int type;
	String username;
}

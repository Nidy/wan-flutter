import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wanflutter/http/entity/project_entity.dart';
import 'package:wanflutter/modules/project/provider/project_model.dart';
import 'package:wanflutter/modules/project/provider/project_provider.dart';
import 'package:wanflutter/router/left2right_router.dart';
import 'package:wanflutter/theme/app_style.dart';
import 'package:wanflutter/widget/empty_holder.dart';
import 'package:wanflutter/widget/webview/common_webview.dart';

class ProjectCategoryWidget extends StatefulWidget {
  final ProjectModel projectModel;
  final ProjectProvider provider;

  ProjectCategoryWidget(this.projectModel, this.provider);

  @override
  _ProjectCategoryState createState() => _ProjectCategoryState();
}

class _ProjectCategoryState extends State<ProjectCategoryWidget>
    with AutomaticKeepAliveClientMixin {
  var _projectList = List<ProjectEntity>();

  @override
  void initState() {
    super.initState();
    loadProjectData();
  }
  void loadProjectData() async {
    _projectList =
        await widget.provider.loadProjectList(widget.projectModel, true);
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProjectProvider>(
      builder: (context, provider, child) => _projectList.isEmpty
          ? EmptyHolder(msg: 'Loading...')
          : SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              controller: provider.refreshController,
              onRefresh: () async {
                _projectList =
                    await provider.loadProjectList(widget.projectModel, true);
              },
              onLoading: () async {
                _projectList =
                    await provider.loadProjectList(widget.projectModel, false);
              },
              child: ListView.builder(
                  itemBuilder: (BuildContext ctx, int index) {
                    var item = _projectList[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          ctx,
                          Left2RightRouter(
                              child: CommonWebview(
                            title: item.title,
                            url: item.link,
                            id: item.id,
                            collect: item.collect,
                          ))),
                      child: _projectItem(item),
                    );
                  },
                  itemCount: widget.projectModel.datas.isEmpty
                      ? 0
                      : widget.projectModel.datas.length),
            ),
    );
  }

  Widget _projectItem(ProjectEntity item) {
    return SizedBox(
      child: Card(
        margin: EdgeInsets.all(8),
        elevation: 15.0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                item.title,
                textDirection: TextDirection.ltr,
                style: AppStyle.defaultBoldTextStyle,
              ),
              SizedBox(height: 4),
              Text(
                item.desc,
                textDirection: TextDirection.ltr,
                style: AppStyle.smallRegularTextStyle,
              ),
              SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                      StringUtils.isNotNullOrEmpty(item.author)
                          ? "@${item.author}"
                          : "@${item.shareUser}",
                      style:
                          TextStyle(color: (Colors.blueGrey), fontSize: 14.0)),
                  SizedBox(width: 8),
                  Icon(Icons.access_time, color: Colors.blueGrey, size: 14),
                  SizedBox(width: 4),
                  Text(
                    item.niceShareDate,
                    style: TextStyle(color: (Colors.blueGrey), fontSize: 14.0),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.adb, color: Colors.lightGreen, size: 14),
                  SizedBox(width: 4),
                  Text("${item.superChapterName}/${item.chapterName}",
                      style:
                          TextStyle(color: (Colors.blueGrey), fontSize: 14.0)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}

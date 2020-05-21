import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wanflutter/http/entity/project_category_entity.dart';
import 'package:wanflutter/modules/project/provider/project_provider.dart';

class ProjectCategoryWidget extends StatelessWidget {
  final ProjectCategoryEntity pcEntity;

  ProjectCategoryWidget(this.pcEntity);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectProvider>(
      builder: (context, provider, child) => Container(
        child: Text(pcEntity.name),
      ),
    );
  }
}

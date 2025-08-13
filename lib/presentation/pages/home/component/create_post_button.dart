import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/enums/auth_enums.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/init/app_init.dart';
import '../../../../core/utils/images_path.dart';
import '../home_store.dart';

class CreatePostButton extends StatelessWidget {
  final HomeStore store = AppInit.instance.homeStore;
  CreatePostButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 4,
                child: CircleAvatar(
                  radius: 23,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: SetUpAssetImage(
                      height: 44.h,
                      width: 44.w,
                      store.profileStore.userProfile.avatar ?? ImagesPath.icPerson,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  context.push(AuthRoutes.CREATE_POST);
                },
                child: Container(
                  height: 40.h,
                  width: 250.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w, top: 7.h, bottom: 5.h),
                    child: Text("Bạn đang nghĩ gì?", style: AppText.text16),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Icon(Icons.image_search, color: Colors.green, size: 25),
              ),
            ],
          );
        }
    );
  }
}

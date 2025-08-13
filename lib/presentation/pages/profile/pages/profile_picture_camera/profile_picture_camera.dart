import 'package:camera/camera.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/presentation/pages/profile/pages/profile_picture_camera/profile_picture_camera_store.dart';

import '../../../../../core/base_widget/loading/loading_app.dart';
import '../../../../../core/utils/color_resources.dart';
import '../../../../../core/utils/images_path.dart';


class ProfilePictureCamera extends StatefulWidget {
  const ProfilePictureCamera({super.key});

  @override
  State<ProfilePictureCamera> createState() => _ProfilePictureCameraState();
}

class _ProfilePictureCameraState extends State<ProfilePictureCamera> with WidgetsBindingObserver{
  ProfilePictureCameraStore store = AppInit.instance.profilePictureCamera;

   @override
  void initState() {
    super.initState();
    store.getCameraDescription();
  }

  @override
  void dispose() {
    super.dispose();
    store.disposeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
      store.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.COLOR_2A292E,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Observer(
        builder: (context){
          print("${store.cameraController}");
          return Stack(
            children: [
              if (store.isCameraInitialized)
                if(!store.isLoading)
                  SizedBox(
                    width: SizeUtil.getMaxWidth(),
                    height: SizeUtil.getMaxHeight(),
                    child: CameraPreview(store.cameraController!),
                  ),
              Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: Column(
                  children: [
                    _buildTittle(context),
                    Spacer(),
                    _buildItemButton(),
                    _buildGallery(),
                    const SizedBox(
                      height: 70,
                    )
                  ],
                ),
              ),
              if(store.isLoading)
                Center(
                    child: Container(
                        height: SizeUtil.getMaxHeight(),
                        width: SizeUtil.getMaxWidth(),
                        color: ColorResources.DARK,
                        child: const LoadingApp()
                    )
                ),
            ],
          );
        }
    );
  }

   ///Remote config theo realtime
   Widget _buildTittle(BuildContext context) {
     return Padding(
       padding: EdgeInsets.only(top: 10.h),
       child: SizedBox(
         height: 50.h,
         child: Stack(
           alignment: Alignment.center,
           children: [
             Positioned(
               left:  10,
               child: Row(
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(left: 20),
                     child: Text("Camera",
                         style: AppText.text16_bold
                             .copyWith(color: ColorResources.WHITE)),
                   ),
                 ],
               ),
             ),
             Positioned(
               right: 20.w,
               child: GestureDetector(
                 onTap: () {
                   // store.changeFlashMode();
                 },
                 child: Row(
                   children: [
                     SetUpAssetImage(
                       store.flashMode == FlashMode.always
                           ? ImagesPath.icFlash
                           : ImagesPath.icNoFlash,
                     ),
                   ],
                 ),
               ),
             )
           ],
         ),
       ),
     );
   }


   Widget _buildItemButton() {
     return SizedBox(
       width: 210,
       child: Padding(
         padding: EdgeInsets.only(left: 60.w),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             GestureDetector(
               onTap: () async {
                 await store.capturePhoto();
                 store.onTapCrop(context);
               },
               child: SetUpAssetImage(
                 height: 60.h,
                 width: 60.w,
                 ImagesPath.icScan,
                 fit: BoxFit.fill,
               ),
             ),
             SizedBox(width: 40.w,),
             GestureDetector(
               onTap: () async {
                  store.onChangeCamera();
               },
               child: SetUpAssetImage(
                 height: 35.h,
                 width: 35.w,
                 ImagesPath.icChangeCamera,
                 color: ColorResources.LIGHT_GREY,
                 fit: BoxFit.fill,
               ),
             ),
           ],
         ),
       ),
     );
   }

   Widget _buildGallery() {
     return Row(
       children: [
         Padding(
           padding: EdgeInsets.only(left: 20.w, bottom: 20.h, top: 20.h),
           child: GestureDetector(
               onTap: () async {
                 store.getImageFromGallery(context);
               },
               child: Observer(builder: (_) =>  _buildImageWidget()) 
           ),
         ),
       ],
     );
   }

   /// Image widget
   Widget _buildImageWidget() {
       return SetUpAssetImage(
         ImagesPath.icGallery,
         width: 40.w,
       );
   }
}


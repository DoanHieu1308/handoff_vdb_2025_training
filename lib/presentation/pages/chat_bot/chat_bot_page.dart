// import 'package:flutter/material.dart';
//
// class ChatBotPage extends StatelessWidget {
//   const ChatBotPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return true;
//       },
//       child: Obx(() => Stack(
//           children: [
//             Scaffold(
//                 backgroundColor: ColorResources.COLOR_F5F6F8,
//                 appBar: BaseAppBar(
//                   title: 'Assistant'.tr,
//                   titleStyle: AppStyles.text18BoldInter,
//                   leading: GestureDetector(
//                     onTap: (){
//                       Get.back();
//                       Get.find<DashBoardController>().onChangedDashboardPage(index: 0);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
//                       child: Container(
//                         padding: const EdgeInsets.only(right: 15, left: 10, top: 10, bottom: 10),
//                         height: 17.h,
//                         width: 19.w,
//                         color: Colors.transparent,
//                         child: Image.asset(
//                           ImagesPath.back,
//                           color: Colors.grey,
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                     ),
//                   ),
//                   actions: [
//                     Padding(
//                         padding: EdgeInsets.only(right: 25.w),
//                         child: Obx(
//                               () => GestureDetector(
//                             onTap: () {
//                               controller.updateBookMark();
//                             },
//                             child: Visibility(
//                               visible: !controller.isFirstSendMessage.value,
//                               child: IZIImage(
//                                 controller.isBookmarked.value
//                                     ? ImagesPath.bookmark_03
//                                     : ImagesPath.bookmark_01,
//                                 colorIconsSvg: ColorResources.COLOR_292D32,
//                                 width: 18.w,
//                               ),
//                             ),
//                           ),
//                         )),
//                   ],
//                 ),
//                 body: buildBody(context)),
//             if(controller.loadResult.value) const LoadingPage()
//           ]
//       )),
//     );
//   }
// }

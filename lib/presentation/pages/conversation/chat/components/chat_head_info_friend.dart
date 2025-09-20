import 'package:flutter/material.dart';

import '../../../../../core/helper/app_custom_circle_avatar.dart';
import '../../../../../core/helper/app_sitebox.dart';
import '../../../../../core/helper/app_text.dart';
import '../../../../../core/utils/images_path.dart';

class ChatHeadInfoFriend extends StatelessWidget {
  final String? avatar;
  final String? state;
  final String? name;
  const ChatHeadInfoFriend({
    super.key,
    this.avatar,
    this.state,
    this.name
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 180),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              AppCustomCircleAvatar(
                image: avatar ?? ImagesPath.icPerson,
                radius: 50,
                height: 100,
                width: 100,
              ),
              Transform.translate(
                offset: Offset(75, 75),
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: state == "online" ? Colors.green : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppSiteBox.h5,
          Text(name ?? "User", style: AppText.text25_bold),
          Text(
            "Sống tại Đà Nẵng",
            style: AppText.text12.copyWith(color: Colors.black45),
          ),
          AppSiteBox.h10,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
            width: 140,
            child: Center(
              child: Text("Xem trang cá nhân", style: AppText.text11_bold),
            ),
          ),
        ],
      ),
    );
  }
}

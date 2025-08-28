import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/presentation/pages/search/search_store.dart';

import '../../../core/helper/app_text.dart';
import '../../../core/utils/color_resources.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchStore store = AppInit.instance.searchStore;

  @override
  void initState() {
    store.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Container(
          height: 50.h,
          width: store.hasText ? null : double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ColorResources.WHITE,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search, size: 20),
                SizedBox(width: 10.w),
                Expanded(
                  child: Observer(
                    builder:
                        (context) => TextFormField(
                          controller: store.textEditingController,
                          decoration: InputDecoration(
                            hintText: "Tìm kiếm bạn bè",
                            hintStyle: AppText.text14.copyWith(
                              color: ColorResources.COLOR_D2D6DE,
                              fontFamily: 'Inter-Regular',
                            ),
                            suffixIcon:
                                store.searchText.isNotEmpty
                                    ? GestureDetector(
                                      onTap: () {
                                        store.textEditingController.clear();
                                        store.searchText = '';
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: ColorResources.GREY,
                                      ),
                                    )
                                    : null,
                            border: InputBorder.none,
                          ),
                          style: AppText.text14.copyWith(
                            color: ColorResources.PRIMARY_TEXT,
                          ),
                          onChanged: (value) {
                            store.searchText = value;
                          },
                          onEditingComplete: () {},
                        ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

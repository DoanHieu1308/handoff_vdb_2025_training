import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
part 'video_store.g.dart';

class VideoStore = _VideoStore with _$VideoStore;

abstract class _VideoStore with Store {
  /// Controller
  late PageController pageController;

  @observable
  double currentPage = 0;


  ///
  /// Init
  ///
  Future<void> init() async {
    pageController = PageController();
  }

}
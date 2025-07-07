import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  /// controller.
  final PageController pageController = PageController(initialPage: 0);

  //
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  /// Focus
  final passwordFocusNode = FocusNode();
  final emailFocusNode= FocusNode();

  /// Declare the data.
  @observable
  int currentPageIndex = 0;

  @observable
  bool isRemember = false;

  Timer? _autoScrollTimer;

  /// call in dispose
  void disposeAll() {
    _autoScrollTimer?.cancel();
    pageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  /// call in initState
  void startAutoScroll({int pageCount = 3, Duration interval = const Duration(seconds: 3)}) {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(interval, (_) {
      final current = pageController.page?.round() ?? 0;
      final nextPage = (current + 1) % pageCount;

      pageController.animateToPage(
        nextPage,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );

      onChangePageIndex(index: nextPage);
    });
  }

  ///
  /// On change page index.
  ///
  @action
  void onChangePageIndex({required int index}) {
      currentPageIndex = index;
  }

  @action
  void setRemember() {
    isRemember = !isRemember;
  }

  @action
  void goToForgotPassword() {

  }

}
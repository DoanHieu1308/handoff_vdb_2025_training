// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginStore on _LoginStore, Store {
  late final _$currentPageIndexAtom = Atom(
    name: '_LoginStore.currentPageIndex',
    context: context,
  );

  @override
  int get currentPageIndex {
    _$currentPageIndexAtom.reportRead();
    return super.currentPageIndex;
  }

  @override
  set currentPageIndex(int value) {
    _$currentPageIndexAtom.reportWrite(value, super.currentPageIndex, () {
      super.currentPageIndex = value;
    });
  }

  late final _$isRememberAtom = Atom(
    name: '_LoginStore.isRemember',
    context: context,
  );

  @override
  bool get isRemember {
    _$isRememberAtom.reportRead();
    return super.isRemember;
  }

  @override
  set isRemember(bool value) {
    _$isRememberAtom.reportWrite(value, super.isRemember, () {
      super.isRemember = value;
    });
  }

  late final _$emailSavedAtom = Atom(
    name: '_LoginStore.emailSaved',
    context: context,
  );

  @override
  String get emailSaved {
    _$emailSavedAtom.reportRead();
    return super.emailSaved;
  }

  @override
  set emailSaved(String value) {
    _$emailSavedAtom.reportWrite(value, super.emailSaved, () {
      super.emailSaved = value;
    });
  }

  late final _$passwordSavedAtom = Atom(
    name: '_LoginStore.passwordSaved',
    context: context,
  );

  @override
  String get passwordSaved {
    _$passwordSavedAtom.reportRead();
    return super.passwordSaved;
  }

  @override
  set passwordSaved(String value) {
    _$passwordSavedAtom.reportWrite(value, super.passwordSaved, () {
      super.passwordSaved = value;
    });
  }

  late final _$emailErrorAtom = Atom(
    name: '_LoginStore.emailError',
    context: context,
  );

  @override
  String? get emailError {
    _$emailErrorAtom.reportRead();
    return super.emailError;
  }

  @override
  set emailError(String? value) {
    _$emailErrorAtom.reportWrite(value, super.emailError, () {
      super.emailError = value;
    });
  }

  late final _$passwordErrorAtom = Atom(
    name: '_LoginStore.passwordError',
    context: context,
  );

  @override
  String? get passwordError {
    _$passwordErrorAtom.reportRead();
    return super.passwordError;
  }

  @override
  set passwordError(String? value) {
    _$passwordErrorAtom.reportWrite(value, super.passwordError, () {
      super.passwordError = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_LoginStore.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_LoginStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$logInAsyncAction = AsyncAction(
    '_LoginStore.logIn',
    context: context,
  );

  @override
  Future<void> logIn({
    required dynamic Function(AuthModel) onSuccess,
    required dynamic Function(String) onError,
  }) {
    return _$logInAsyncAction.run(
      () => super.logIn(onSuccess: onSuccess, onError: onError),
    );
  }

  late final _$_LoginStoreActionController = ActionController(
    name: '_LoginStore',
    context: context,
  );

  @override
  void onChangePageIndex({required int index}) {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
      name: '_LoginStore.onChangePageIndex',
    );
    try {
      return super.onChangePageIndex(index: index);
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRemember() {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
      name: '_LoginStore.setRemember',
    );
    try {
      return super.setRemember();
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void goToForgotPassword() {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
      name: '_LoginStore.goToForgotPassword',
    );
    try {
      return super.goToForgotPassword();
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool validate() {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
      name: '_LoginStore.validate',
    );
    try {
      return super.validate();
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void checkSavedData() {
    final _$actionInfo = _$_LoginStoreActionController.startAction(
      name: '_LoginStore.checkSavedData',
    );
    try {
      return super.checkSavedData();
    } finally {
      _$_LoginStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPageIndex: ${currentPageIndex},
isRemember: ${isRemember},
emailSaved: ${emailSaved},
passwordSaved: ${passwordSaved},
emailError: ${emailError},
passwordError: ${passwordError},
errorMessage: ${errorMessage},
isLoading: ${isLoading}
    ''';
  }
}

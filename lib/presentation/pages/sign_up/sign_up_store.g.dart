// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SignUpStore on _SignUpStore, Store {
  late final _$isLoadingAtom =
      Atom(name: '_SignUpStore.isLoading', context: context);

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

  late final _$errorMessageAtom =
      Atom(name: '_SignUpStore.errorMessage', context: context);

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

  late final _$nameErrorAtom =
      Atom(name: '_SignUpStore.nameError', context: context);

  @override
  String? get nameError {
    _$nameErrorAtom.reportRead();
    return super.nameError;
  }

  @override
  set nameError(String? value) {
    _$nameErrorAtom.reportWrite(value, super.nameError, () {
      super.nameError = value;
    });
  }

  late final _$emailErrorAtom =
      Atom(name: '_SignUpStore.emailError', context: context);

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

  late final _$passwordErrorAtom =
      Atom(name: '_SignUpStore.passwordError', context: context);

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

  late final _$confirmPasswordErrorAtom =
      Atom(name: '_SignUpStore.confirmPasswordError', context: context);

  @override
  String? get confirmPasswordError {
    _$confirmPasswordErrorAtom.reportRead();
    return super.confirmPasswordError;
  }

  @override
  set confirmPasswordError(String? value) {
    _$confirmPasswordErrorAtom.reportWrite(value, super.confirmPasswordError,
        () {
      super.confirmPasswordError = value;
    });
  }

  late final _$testConnectionAsyncAction =
      AsyncAction('_SignUpStore.testConnection', context: context);

  @override
  Future<void> testConnection() {
    return _$testConnectionAsyncAction.run(() => super.testConnection());
  }

  late final _$signUpAsyncAction =
      AsyncAction('_SignUpStore.signUp', context: context);

  @override
  Future<void> signUp(
      {required dynamic Function(AuthModel) onSuccess,
      required dynamic Function(String) onError}) {
    return _$signUpAsyncAction
        .run(() => super.signUp(onSuccess: onSuccess, onError: onError));
  }

  late final _$_SignUpStoreActionController =
      ActionController(name: '_SignUpStore', context: context);

  @override
  bool validate() {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.validate');
    try {
      return super.validate();
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void checkSavedData() {
    final _$actionInfo = _$_SignUpStoreActionController.startAction(
        name: '_SignUpStore.checkSavedData');
    try {
      return super.checkSavedData();
    } finally {
      _$_SignUpStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
errorMessage: ${errorMessage},
nameError: ${nameError},
emailError: ${emailError},
passwordError: ${passwordError},
confirmPasswordError: ${confirmPasswordError}
    ''';
  }
}

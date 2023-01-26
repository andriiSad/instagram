// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:instagram/main.dart';

void main() {
  group('AddPostScreen', () {
    test('_selectImage should return a dialog', () {
      BuildContext context;
      expect(
          _AddPostScreenState()._selectImage(context),
          isA<
              Future<
                  String>>()); // changed isNotNull to isA<Future<String>>() since _selectImage should return a Future type
    });

    test('_postImage should return success when valid parameters are passed',
        () async {
      String uid = '123';
      String username = 'test';
      String profImage = 'http://test.com/image.jpg';

      Uint8List? file = Uint8List.fromList([1, 2, 3]);

      expect(
          await _AddPostScreenState()._postImage(
              uid: uid,
              username: username,
              profImage: profImage,
              file: file!), // added missing comma after profImage parameter
          equals('success'));
    });

    test('_clearImage should set _file to null', () {
      _AddPostScreenState state = _AddPostScreenState();
      state._file = Uint8List.fromList([1, 2, 3]);

      state._clearImage();

      expect(
          state._file,
          equals(
              null)); // changed isNull to equals(null) since we are checking if the value of the variable is equal to null
    });
  });
}

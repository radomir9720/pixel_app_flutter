#!/usr/bin/env bash
flutter pub get &&
dart format --set-exit-if-changed lib test &&
flutter analyze lib test &&
flutter test --coverage --test-randomize-ordering-seed random
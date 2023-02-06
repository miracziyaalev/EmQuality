import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp() {
    print("here");
  }

  test("user login fail test", () {
    const isUserLogin = true;

    expect(isUserLogin, isTrue);
  });
}

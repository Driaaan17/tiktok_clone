import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_clone/main.dart';

void main() {
  testWidgets('TikTok Clone smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text('TikTok'), findsWidgets);
  });
}
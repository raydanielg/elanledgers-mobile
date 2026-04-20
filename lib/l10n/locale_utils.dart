import 'package:flutter/widgets.dart';
import 'package:duka_app/main.dart';

bool isSw(BuildContext context) => AppLocale.of(context).languageCode == 'sw';

String tr(BuildContext context, String en, String sw) {
  return isSw(context) ? sw : en;
}

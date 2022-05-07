import 'package:cirilla/models/setting/setting.dart';
import 'package:cirilla/screens/screens.dart';
import 'package:cirilla/store/store.dart';

import 'utility_mixin.dart' show get;

class GeneralMixin {
  String routeCheckout(SettingStore store, AuthStore auth) {
    String data = Checkout.routeName;
    final WidgetConfig widgetConfig = store.data != null ? store.data.settings['general'].widgets['general'] : null;
    final Map<String, dynamic> fields = widgetConfig != null ? widgetConfig.fields : {};
    bool forceLoginCheckout = get(fields, ['forceLoginCheckout'], false);
    if (forceLoginCheckout && !auth.isLogin) {
      data = LoginScreen.routeName;
    }
    return data;
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';

const t1_colorPrimary = Color(0XFF0282d2);
const t1_colorPrimary_light = Color(0XFFFFEEEE);
const t1_colorPrimaryDark = Color(0XFF5bbbf7);
const t1_colorAccent = Color(0XFF5bbbf7);

const t1_textColorPrimary = Color(0XFF333333);
const t1_textColorSecondary = Color(0XFF747474);

const t1_app_background = Color(0XFF5bbbf7);
const t1_view_color = Color(0XFFDADADA);

const t1_sign_in_background = Color(0XFFDADADA);

const t1_white = Color(0XFFffffff);
const t1_icon_color = Color(0XFF747474);
const t1_selected_tab = Color(0XFFFCE9E9);
const t1_red = Color(0XFFF10202);
const t1_blue = Color(0XFF1D36C0);
const t1_edit_text_background = Color(0XFFE8E8E8);
const t1_shadow = Color(0X70E2E2E5);
var t1White = materialColor(0XFFFFFFFF);
var t1TextColorPrimary = materialColor(0XFF212121);
const shadow_color = Color(0X95E9EBF0);
const t1_color_primary_light = Color(0XFFe3f2fc);
const t1_bg_bottom_sheet = Color(0XFFFFF1F1);

Map<int, Color> color = {
  50: Color.fromRGBO(2, 130, 210, .1),
  100: Color.fromRGBO(2, 130, 210, .2),
  200: Color.fromRGBO(2, 130, 210, .3),
  300: Color.fromRGBO(2, 130, 210, .4),
  400: Color.fromRGBO(2, 130, 210, .5),
  500: Color.fromRGBO(2, 130, 210, .6),
  600: Color.fromRGBO(2, 130, 210, .7),
  700: Color.fromRGBO(2, 130, 210, .8),
  800: Color.fromRGBO(2, 130, 210, .9),
  900: Color.fromRGBO(2, 130, 210, 1),
};

MaterialColor materialColor(colorHax) {
  return MaterialColor(colorHax, color);
}

MaterialColor colorCustom = MaterialColor(0XFF5959fc, color);

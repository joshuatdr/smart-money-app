import '../sizes.dart';
import 'package:flutter/material.dart';

class JSpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: JSizes.appBarHeight,
    left: JSizes.defaultLeft,
    bottom: JSizes.defaultSpace,
    right: JSizes.defaultRight,
  );
}

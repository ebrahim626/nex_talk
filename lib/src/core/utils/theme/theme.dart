import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const lightUiConfig = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarColor: Colors.white,
  systemNavigationBarIconBrightness: Brightness.dark,
);

const appbarColor = primaryColor;
const primaryColor = Color(0xff6c63ff);
const secondaryColor = Color(0xffa78bfa);
const backgroundColor = Color(0xff0e0f11);
const _bodyTextColor = Color(0xff6b7280);
const bodyTextColor = _bodyTextColor;
const containerTextColor = Colors.white;
const logoContainerColor = Color(0xff16181c);
const bottomSheetColor = logoContainerColor;
final _shadowColor = _bodyTextColor.withValues(alpha: 0.3);
final _cardBackgroundColor = const Color(0xff1e2128);
final containerColor2 = _cardBackgroundColor;
const _titleTextColor = Color(0xffe8eaf0);
const titleTextColor = _titleTextColor;
const _headLineTextColor = _titleTextColor;
const _primaryLightColor = primaryColor;
const _scaffoldBackgroundColor = backgroundColor;
const _unselectedColor = Color(0xff1e2128);
const _floatingActionButtonColor = primaryColor;
const _backgroundColor = backgroundColor;
const _iconColorSecondary = bodyTextColor;
const _borderColor = Color(0xFF2a2d35);
const greyLightColor = Color(0xff6F6C6A);
const ratingBackgroundColor = Color(0xff9aa596);
const stockColor = _borderColor;
const containerColor = _borderColor;
const hintTextColor = Color(0xff6b7280);
const successColor = Color(0xff34C759);
const warningColor = Color(0xffff3b30);
const errorColor = Color(0xffED6B6B);

bool get isTablet => ScreenUtil().screenWidth >= 600;

const _pageTransitionTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
  },
);

final _cardTheme = CardThemeData(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  shadowColor: _shadowColor,
  color: _cardBackgroundColor,
  elevation: 0,
);

final _textTheme = TextTheme(
  titleSmall: TextStyle(
    fontWeight: FontWeight.w700,
    color: _titleTextColor,
    fontSize: 14.0.sp,
  ),
  titleMedium: TextStyle(
    fontWeight: FontWeight.w700,
    color: _titleTextColor,
    fontSize: 16.0.sp,
  ),
  titleLarge: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 20.0.sp,
    color: _titleTextColor,
  ),
  labelSmall: TextStyle(
    color: _bodyTextColor,
    fontWeight: FontWeight.w600,
    fontSize: 12.sp,
  ),
  labelMedium: TextStyle(
    color: _bodyTextColor,
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
  ),
  labelLarge: const TextStyle(
    color: _bodyTextColor,
    fontWeight: FontWeight.w700,
  ),
  bodySmall: TextStyle(
    color: _bodyTextColor,
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
  ),
  bodyMedium: TextStyle(
    color: _bodyTextColor,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  ),
  bodyLarge: TextStyle(
    color: _bodyTextColor,
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  ),
  headlineLarge: const TextStyle(
    fontWeight: FontWeight.w900,
    color: _headLineTextColor,
  ),
  headlineMedium: const TextStyle(
    fontWeight: FontWeight.w900,
    color: _headLineTextColor,
  ),
  headlineSmall: TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 28.sp,
    color: _headLineTextColor,
  ),
).apply(fontFamily: "Outfit");

final _radioTheme = RadioThemeData(
  fillColor: WidgetStateProperty.all(primaryColor),
  overlayColor: WidgetStateProperty.all(_primaryLightColor),
);

final _appBarTheme = AppBarTheme(
  // shadowColor: _shadowColor,
  // iconTheme: const IconThemeData(color: _scaffoldBackgroundColor),
  backgroundColor: _scaffoldBackgroundColor,
  elevation: 0,
  titleTextStyle: _textTheme.titleLarge,
  surfaceTintColor: Colors.white,
  shadowColor: Colors.white,
  // backgroundColor: primaryColor,
);

final _tabBarTheme = TabBarThemeData(
  labelColor: primaryColor,
  unselectedLabelColor: _unselectedColor,
  indicatorSize: TabBarIndicatorSize.label,
  indicator: BoxDecoration(borderRadius: BorderRadius.circular(30)),
);

final _dialogTheme = DialogThemeData(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
);

final _switchTheme = SwitchThemeData(
  thumbColor: WidgetStateProperty.all(primaryColor),
  trackColor: WidgetStateProperty.all(primaryColor.withValues(alpha: 0.5)),
);

final _tooltipTheme = TooltipThemeData(
  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: _floatingActionButtonColor.withValues(alpha: 0.8),
  ),
  textStyle: _textTheme.titleSmall!.copyWith(color: Colors.white),
);

final _listTileTheme = ListTileThemeData(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
);

final _snackBarTheme = SnackBarThemeData(
  actionTextColor: _textTheme.labelSmall!.color,
  contentTextStyle: _textTheme.labelSmall,
  backgroundColor: Colors.transparent,
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  elevation: 0.0,
);

final _dividerTheme = DividerThemeData(
  color: _unselectedColor.withValues(alpha: 0.4),
  thickness: 0.4,
);

const _bottomNavBar = BottomNavigationBarThemeData(
  unselectedItemColor: _unselectedColor,
  type: BottomNavigationBarType.fixed,
  selectedItemColor: secondaryColor,
  showUnselectedLabels: true,
  elevation: 30,
  selectedLabelStyle: TextStyle(
    fontWeight: FontWeight.w700,
    color: secondaryColor,
    fontSize: 10,
  ),
  unselectedLabelStyle: TextStyle(
    fontWeight: FontWeight.w600,
    color: _unselectedColor,
    fontSize: 10,
  ),
);

const _textSelectionTheme = TextSelectionThemeData(
  cursorColor: primaryColor,
  selectionColor: primaryColor,
  selectionHandleColor: primaryColor,
);

final _outlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    side: BorderSide.none,
    foregroundColor: secondaryColor,
    textStyle: _textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700),
    backgroundColor: _backgroundColor,
    padding: const EdgeInsets.all(0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
  ),
);

final _elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    minimumSize: const Size(double.infinity, 48),
    backgroundColor: primaryColor,
    // textStyle: _textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w700),
    foregroundColor: Colors.white,
    padding: const EdgeInsets.all(0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
);

const _progressIndicatorTheme = ProgressIndicatorThemeData(
  refreshBackgroundColor: _primaryLightColor,
  circularTrackColor: _primaryLightColor,
  linearTrackColor: _primaryLightColor,
  color: primaryColor,
);

final _lightInputDecorationTheme = InputDecorationTheme(
  contentPadding: const EdgeInsets.all(16),
  hintStyle: _textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    gapPadding: 10,
    borderSide: const BorderSide(color: _borderColor, width: 1.0),
    // borderSide: BorderSide.none,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    gapPadding: 10,
    borderSide: const BorderSide(color: _borderColor, width: 1.0),
    // borderSide: BorderSide.none,
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    gapPadding: 10,
    borderSide: const BorderSide(color: _borderColor, width: 1.0),
    // borderSide: BorderSide.none,
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    gapPadding: 10,
    borderSide: const BorderSide(color: Colors.black, width: 1),
    // borderSide: BorderSide.none,
  ),
  floatingLabelStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: primaryColor,
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    gapPadding: 10,
    borderSide: const BorderSide(color: Colors.red, width: 1),
    // borderSide: BorderSide.none,
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    gapPadding: 10,
    borderSide: const BorderSide(color: Colors.red, width: 1),
    // borderSide: BorderSide.none,
  ),
  // filled: true,
  fillColor: _backgroundColor.withValues(alpha: 0.5),
  suffixIconColor: _iconColorSecondary,
  prefixIconColor: _iconColorSecondary,
  errorMaxLines: 3,
  floatingLabelBehavior: FloatingLabelBehavior.never,
);

const _floatingActionButtonTheme = FloatingActionButtonThemeData(
  backgroundColor: _floatingActionButtonColor,
  foregroundColor: Colors.white,
  elevation: 0,
);

final _chipTheme = ChipThemeData(
  backgroundColor: Colors.white,
  labelStyle: _textTheme.bodyMedium!.copyWith(
    color: primaryColor,
    fontWeight: FontWeight.w600,
  ),
  padding: const EdgeInsets.symmetric(horizontal: 5),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  side: BorderSide.none,
  labelPadding: const EdgeInsets.symmetric(horizontal: 5),
  elevation: 5.0,
  shadowColor: primaryColor.withValues(alpha: 0.5),
);

final _datePickerTheme = DatePickerThemeData(
  backgroundColor: _scaffoldBackgroundColor,
  surfaceTintColor: Colors.white,
  elevation: 0,
  headerBackgroundColor: primaryColor,
  headerForegroundColor: Colors.white,
  todayBackgroundColor: WidgetStateProperty.all(
    primaryColor.withValues(alpha: 0.2),
  ),
  todayForegroundColor: WidgetStateProperty.all(primaryColor),
  dayBackgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
    if (states.contains(WidgetState.selected)) {
      return primaryColor; // Blue background for selected dates
    }
    return Colors.transparent; // Default background
  }),

  dayForegroundColor: WidgetStateProperty.resolveWith<Color>((states) {
    if (states.contains(WidgetState.disabled)) {
      return Colors.grey.withValues(alpha: 0.5); // Disabled dates
    }
    if (states.contains(WidgetState.selected)) {
      return Colors.white; // White text for selected dates
    }
    return _bodyTextColor; // Default text color
  }),

  dayOverlayColor: WidgetStateProperty.all(primaryColor.withValues(alpha: 0.1)),
  rangePickerBackgroundColor: greyLightColor,

  dayStyle: const TextStyle(color: _bodyTextColor, fontWeight: FontWeight.w500),
  weekdayStyle: const TextStyle(
    color: _bodyTextColor,
    fontWeight: FontWeight.w600,
  ),
  yearStyle: const TextStyle(
    color: _bodyTextColor,
    fontWeight: FontWeight.w500,
  ),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

  // Customize Cancel button (TextButton)
  cancelButtonStyle: ButtonStyle(
    foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.pressed)) {
        return primaryColor.withValues(alpha: 0.8); // Pressed state
      }
      return primaryColor; // Default color (blue)
    }),
    textStyle: WidgetStateProperty.all(
      const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),

  // Customize OK/Confirm button (TextButton)
  confirmButtonStyle: ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.pressed)) {
        return primaryColor.withValues(alpha: 0.8); // Pressed state
      }
      return primaryColor; // Default fill (blue)
    }),
    foregroundColor: WidgetStateProperty.all(Colors.white), // White text
    textStyle: WidgetStateProperty.all(
      const TextStyle(fontWeight: FontWeight.w600),
    ),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 16),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
);

final lightTheme = ThemeData(
  useMaterial3: true,
  primaryColorDark: const Color(0xff272B35),
  cardTheme: _cardTheme,
  textTheme: _textTheme,
  radioTheme: _radioTheme,
  shadowColor: _shadowColor,
  appBarTheme: _appBarTheme,
  tabBarTheme: _tabBarTheme,
  dialogTheme: _dialogTheme,
  switchTheme: _switchTheme,
  tooltipTheme: _tooltipTheme,
  brightness: Brightness.light,
  listTileTheme: _listTileTheme,
  snackBarTheme: _snackBarTheme,
  primaryColor: primaryColor,

  cardColor: _cardBackgroundColor,
  dividerTheme: _dividerTheme,
  unselectedWidgetColor: _unselectedColor,
  bottomNavigationBarTheme: _bottomNavBar,
  textSelectionTheme: _textSelectionTheme,
  secondaryHeaderColor: _primaryLightColor,
  outlinedButtonTheme: _outlinedButtonTheme,
  elevatedButtonTheme: _elevatedButtonTheme,
  progressIndicatorTheme: _progressIndicatorTheme,
  inputDecorationTheme: _lightInputDecorationTheme,
  scaffoldBackgroundColor: _scaffoldBackgroundColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  floatingActionButtonTheme: _floatingActionButtonTheme,
  iconTheme: const IconThemeData(color: _iconColorSecondary),
  chipTheme: _chipTheme,
  primaryIconTheme: const IconThemeData(color: primaryColor),
  pageTransitionsTheme: _pageTransitionTheme,
  datePickerTheme: _datePickerTheme,
  dividerColor: stockColor,
  cupertinoOverrideTheme: CupertinoThemeData(
    primaryColor: primaryColor,
    barBackgroundColor: _scaffoldBackgroundColor,
    textTheme: CupertinoTextThemeData(
      dateTimePickerTextStyle: TextStyle(
        color: _bodyTextColor,
        fontSize: 16.sp,
      ),
      actionTextStyle: const TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return primaryColor;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(Colors.white),
    side: BorderSide(
      color: _unselectedColor.withValues(alpha: 0.5),
      width: 1.5,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    splashRadius: 0, // No splash effect
    overlayColor: WidgetStateProperty.all(primaryColor.withValues(alpha: 0.1)),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
  ),
  popupMenuTheme: const PopupMenuThemeData(color: Colors.white),
);

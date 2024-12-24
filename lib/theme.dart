import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Color _pGreen = const Color.fromRGBO(0, 122, 64, 1);
Color _pGold = const  Color.fromRGBO(180, 151, 90, 1);
Color colorGold = _pGold;
Color colorGreen = _pGreen;

final ThemeData appTheme = ThemeData(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: _pGreen,
      shadowColor: Color.fromRGBO(169, 169, 169, 0.6),// цвет тени
      elevation: 2, // Высота тени
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),), // Скругление углов
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Отступы внутри кнопки
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: Colors.blue, // Цвет текста кнопки
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Отступы внутри кнопки
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: Colors.blue, // Цвет текста кнопки
      side: BorderSide(color: Colors.blue), // Цвет границы кнопки
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Отступы внутри кнопки
    ),
  ),
);


final ButtonStyle eBtn = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: _pGreen,
    shadowColor: Color.fromRGBO(169, 169, 169, 0.6), // Цвет тени
    elevation: 2, // Высота тени
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Скругление углов
    ),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Отступы внутри кнопки
);
final ButtonStyle eBtnGold = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: _pGold,
    shadowColor: Color.fromRGBO(169, 169, 169, 0.6), // Цвет тени
    elevation: 2, // Высота тени
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Скругление углов
    ),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Отступы внутри кнопки
);

final ButtonStyle eBtnNone = ElevatedButton.styleFrom(
    foregroundColor: Colors.black,
    backgroundColor: Colors.transparent,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0), // Скругление углов
    ),
    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0), // Отступы внутри кнопки
);
final ButtonStyle eBtnNoneTextWhile = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.transparent,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0), // Скругление углов
    ),
    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0), // Отступы внутри кнопки
);

final AlertStyle myAlert = AlertStyle(
  animationType: AnimationType.fromTop,
  isCloseButton: true,
  isOverlayTapDismiss: true,
  descStyle: TextStyle(fontWeight: FontWeight.bold),
  descTextAlign: TextAlign.center,
  titleStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
  backgroundColor: Color.fromRGBO(255, 255, 255, 1),
  animationDuration: Duration(milliseconds: 400),
  alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: _pGold, width: 2)
  ),
  overlayColor: Color(0x55000000),
);

// ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
//         useMaterial3: true,
//       )


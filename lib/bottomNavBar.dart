import 'package:cabinet_mobile/theme.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget{
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavBar({required this.selectedIndex, required this.onItemTapped});


  @override
  Widget build(BuildContext context){
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.add_chart_outlined),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'Уведомления',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Профиль',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: colorGreen,
      onTap: onItemTapped,
    );
  }
}
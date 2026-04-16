import '/pages/pages.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget
{
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body:pages[_selectedIndex].builder(onChangeTab),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(()=> _selectedIndex = index
        ),
        destinations: pages.map((page) => NavigationDestination(
            icon: Icon(page.icon),
            label: page.title,
            key: ValueKey("${page.key}-bottom-bar-item")
        )).toList()
      ),
    );
  }

  void onChangeTab(int index) //Callback for changing tab from other pages
  {
    setState(()
    {
      _selectedIndex = index;
    });
  }
}
import 'package:emkaliteapp/view/kalite/operation/view/operationsCheckStateView.dart';
import 'package:emkaliteapp/view/tezgah/screen/machineStates.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final screens = [
    const OperationCheckStateView(),
    const FinalMachineState(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blueGrey,
        selectedFontSize: 16,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: ((index) => setState(() {
              currentIndex = index;
            })),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.workspace_premium_sharp),
            label: "İş Emirleri",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_mosaic_outlined),
            label: "Operasyon Sahası",
          )
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
    );
  }
}

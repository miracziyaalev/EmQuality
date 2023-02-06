import 'dart:async';

import 'package:emkaliteapp/core/base/state/base_state.dart';
import 'package:emkaliteapp/view/kalite/operation/model/operationModel.dart';
import 'package:emkaliteapp/view/kalite/operation/model/workOrders.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:searchfield/searchfield.dart';

import '../service/getOperationModelService.dart';

enum STATE { loadingScreen, loadedScreen, connectionErrorScreen }

class OperationsScreen extends StatefulWidget {
  final List<OperationModel> operationsModelAll;
  const OperationsScreen({super.key, required this.operationsModelAll});

  @override
  State<OperationsScreen> createState() => _OperationsScreenState();
}

class _OperationsScreenState extends BaseState<OperationsScreen> {
  List<OperationModel?> get operationsModelAll => widget.operationsModelAll;
  late StreamController<STATE> streamControllerSpesific;
  late List<OperationModel> spesificOperationModel;
  final workOrdersDropDownController = TextEditingController();
  @override
  void initState() {
    streamControllerSpesific = BehaviorSubject<STATE>();
    super.initState();
  }

  @override
  void dispose() {
    streamControllerSpesific.close();
    workOrdersDropDownController.dispose();
    super.dispose();
  }

  Future<void> checkDataProsess({required String chosen}) async {
    streamControllerSpesific.add(STATE.loadingScreen);
    await GetOperationsService.fetchChosenOperation(chosenWorkNumber: chosen)
        .then((value) {
      if (value != null) {
        spesificOperationModel = value;
        if (!streamControllerSpesific.isClosed) {
          streamControllerSpesific.add(STATE.loadedScreen);
        }
      } else {
        if (!streamControllerSpesific.isClosed) {
          streamControllerSpesific.add(STATE.connectionErrorScreen);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    String selectedValue = "İE.22.0511";

    List<WorkOrders> openWorkOrders = [
      WorkOrders(
          isOpen: true,
          mmpsNo: "İE.22.0511",
          notes: "KPK16PAUST112 - KAPAK PATLAÇ ÜST 1 1/2"),
      WorkOrders(
          isOpen: true,
          mmpsNo: "İE.22.0557",
          notes: "140240000095-KCR DİPÇİK TÜPÜ MERKEZLEME PARÇASI"),
      WorkOrders(
          isOpen: true,
          mmpsNo: "İE.22.0625",
          notes: "20109201002- SİLİNDİR KAFASI-LD640/820"),
      WorkOrders(
          isOpen: true,
          mmpsNo: "İE.22.0529",
          notes: "20107866011-GAZ KUMANDA KUTUSU KMP"),
      WorkOrders(
          isOpen: true, mmpsNo: "İE.22.0504", notes: "ŞAFT PLASTİK - KAPLİN"),
      WorkOrders(
          isOpen: true,
          mmpsNo: "İE.22.0554",
          notes: "20111540064-KÜLBÜTÖR EGZOS"),
    ];

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: dynamicHeight(0.3),
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: dynamicWidth(0.4),
                            height: dynamicHeight(0.7),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    "İş Emri Seç",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.blueGrey),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: dynamicBorderRadius(20),
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      SearchField<WorkOrders>(
                                        hint: "İş Emri Ara",
                                        searchInputDecoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.blueGrey,
                                                  width: 1),
                                              borderRadius:
                                                  dynamicBorderRadius(20)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.blueGrey,
                                                  width: 1),
                                              borderRadius:
                                                  dynamicBorderRadius(20)),
                                        ),
                                        itemHeight: 50,
                                        maxSuggestionsInViewPort: 4,
                                        suggestionsDecoration: BoxDecoration(
                                          color: Colors.blueGrey,
                                          borderRadius: dynamicBorderRadius(20),
                                        ),
                                        onSuggestionTap: (value) {
                                          selectedValue = value.item!.mmpsNo;
                                          checkDataProsess(
                                              chosen: selectedValue);
                                          print(selectedValue);
                                        },
                                        suggestions: openWorkOrders
                                            .map(
                                              (e) => SearchFieldListItem<
                                                  WorkOrders>(
                                                "${e.mmpsNo} - ${e.notes.trimRight()}",
                                                item: e,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              child: StreamBuilder<STATE>(
                  stream: streamControllerSpesific.stream,
                  builder: (context, snapshot) {
                    switch (snapshot.data) {
                      case STATE.loadingScreen:
                        return const Center(child: CircularProgressIndicator());
                      case STATE.loadedScreen:
                        return Center(
                            child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemCount: spesificOperationModel.length,
                          itemBuilder: (BuildContext context, int index) {
                            var item = spesificOperationModel[index];
                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: dynamicBorderRadius(20)),
                                height: dynamicHeight(0.1),
                                width: dynamicWidth(1),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(width: 2.0),
                                              left: BorderSide(width: 2.0)),
                                          color: Colors.blueGrey,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.blueGrey,
                                                child: Center(
                                                  child: Text(
                                                    item.trnum.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(width: 2.0)),
                                          color: Colors.blueGrey,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.amber,
                                                child: const Center(
                                                  child: Text(
                                                    "Durum",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: item.d7IslemKodu == "U"
                                                    ? Colors.green
                                                    : Colors.red,
                                                child: Center(
                                                  child: Text(
                                                    item.d7IslemKodu == "U"
                                                        ? "Üretim - U"
                                                        : "Duruş - ${item.d7IslemKodu}",
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(width: 2.0)),
                                          color: Colors.blueGrey,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.amber,
                                                child: const Center(
                                                  child: Text(
                                                    "İş Emri",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.blueGrey,
                                                child: Center(
                                                  child: Text(
                                                    item.evrakNo,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(width: 2.0)),
                                          color: Colors.blueGrey,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.amber,
                                                child: const Center(
                                                  child: Text(
                                                    "Tezgah Kodu",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.blueGrey,
                                                child: Center(
                                                  child: Text(
                                                    item.kod,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(width: 2.0)),
                                          color: Colors.blueGrey,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.amber,
                                                child: const Center(
                                                  child: Text(
                                                    "Mamul Kodu",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.blueGrey,
                                                child: Center(
                                                  child: Text(
                                                    item.mamulKod.trimRight(),
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(width: 2.0)),
                                          color: Colors.blueGrey,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.amber,
                                                child: const Center(
                                                  child: Text(
                                                    "Operatör",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.blueGrey,
                                                child: Center(
                                                  child: Text(
                                                    item.operator1,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(width: 2.0)),
                                          color: Colors.blueGrey,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.amber,
                                                child: const Center(
                                                  child: Text(
                                                    "Job No",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.blueGrey,
                                                child: Center(
                                                  child: Text(
                                                    item.jobNo,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(width: 2.0)),
                                          color: Colors.blueGrey,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.amber,
                                                child: const Center(
                                                  child: Text(
                                                    "Süre / dk",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.blueGrey,
                                                child: Center(
                                                  child: Text(
                                                    item.sure
                                                        .toStringAsFixed(2),
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(width: 2.0)),
                                          color: Colors.blueGrey,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.amber,
                                                child: const Center(
                                                  child: Text(
                                                    "İş Emri",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.blueGrey,
                                                child: Center(
                                                  child: Text(
                                                    item.evrakNo,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(width: 2.0)),
                                          color: Colors.blueGrey,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.amber,
                                                child: const Center(
                                                  child: Text(
                                                    "Başlangıç Tarihi",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.blueGrey,
                                                child: Center(
                                                  child: Text(
                                                    "${item.recTarih1}  ${item.recTime1}",
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(width: 2.0)),
                                          color: Colors.blueGrey,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.amber,
                                                child: const Center(
                                                  child: Text(
                                                    "Kapanış Tarihi",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.blueGrey,
                                                child: Center(
                                                  child: Text(
                                                    "${item.recTarih2}  ${item.recTime2}",
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(width: 2.0)),
                                          color: Colors.blueGrey,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.amber,
                                                child: const Center(
                                                  child: Text(
                                                    "Aksiyon",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.blueGrey,
                                                child: Center(
                                                  child: Text(
                                                    item.d7Aksiyon,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(width: 2.0)),
                                          color: Colors.blueGrey,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.amber,
                                                child: const Center(
                                                  child: Text(
                                                    "Durma Sebebi",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.blueGrey,
                                                child: Center(
                                                  child: Text(
                                                    item.durmaSebebi ?? "-",
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(width: 2.0)),
                                          color: Colors.blueGrey,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.amber,
                                                child: const Center(
                                                  child: Text(
                                                    "Tamamlanan Miktar",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.blueGrey,
                                                child: Center(
                                                  child: Text(
                                                    item.d7IslemKodu == "U"
                                                        ? item.tmMiktar
                                                            .toString()
                                                        : "-",
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(width: 2.0)),
                                          color: Colors.blueGrey,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.amber,
                                                child: const Center(
                                                  child: Text(
                                                    "Fire Miktarı",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.blueGrey,
                                                child: Center(
                                                  child: Text(
                                                    item.d7IslemKodu == "U"
                                                        ? item.fire.toString()
                                                        : "-",
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(width: 2.0)),
                                          color: Colors.blueGrey,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.amber,
                                                child: const Center(
                                                  child: Text(
                                                    "Toplam Duruş / dk",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.blueGrey,
                                                child: Center(
                                                  child: Text(
                                                    item.d7IslemKodu == "U"
                                                        ? item.toplamDurus
                                                            .toStringAsFixed(3)
                                                        : "-",
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                              right: BorderSide(width: 2.0)),
                                          color: Colors.blueGrey,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: Colors.amber,
                                                child: const Center(
                                                  child: Text(
                                                    "Performans",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.blueGrey,
                                                child: Center(
                                                  child: Text(
                                                    item.d7IslemKodu == "U"
                                                        ? "%${item.refnum1.toStringAsFixed(0)}"
                                                        : "-",
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ));
                      case STATE.connectionErrorScreen:
                        return const Center(child: Text("error"));
                      default:
                        return const Center(child: Text("İş Emri Seçiniz"));
                    }
                  }),
            ),
          )
        ],
      ),
    ));
  }
}

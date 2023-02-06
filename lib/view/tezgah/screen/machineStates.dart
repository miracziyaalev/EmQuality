import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../model/machineModel.dart';

import '../service/getMachineServices.dart';

enum STATE { loadingScreen, loadedScreen, connectionErrorScreen }

class FinalMachineState extends StatefulWidget {
  const FinalMachineState({Key? key}) : super(key: key);

  @override
  State<FinalMachineState> createState() => _FinalMachineStateState();
}

class _FinalMachineStateState extends State<FinalMachineState> {
  late StreamController<STATE> streamController;
  late List<GetMachineStateModel> machineStates;

  @override
  void initState() {
    streamController = BehaviorSubject<STATE>();
    getMachineState();
    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  void getMachineState() {
    streamController.add(STATE.loadingScreen);
    GetMachineStateService.fetchMachineStatesInfo().then((value) {
      if (value != null) {
        machineStates = value;

        if (!streamController.isClosed) {
          streamController.add(STATE.loadedScreen);
        }
      } else {
        !streamController.isClosed
            ? streamController.add(STATE.connectionErrorScreen)
            : null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var customHeight = MediaQuery.of(context).size.height;
    var customWidth = MediaQuery.of(context).size.width;
    final borderRadius = BorderRadius.circular(20);
    var assetsimagejpg = 'assets/image.jpg';
    var stateMachineWork = Colors.green;
    var stateMachineStop = Colors.red;
    var stateMachineFree = Colors.grey;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Operasyon Sahası"),
        centerTitle: true,
      ),
      body: StreamBuilder<STATE>(
        stream: streamController.stream,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case STATE.loadingScreen:
              return const Center(child: CircularProgressIndicator());
            case STATE.loadedScreen:
              return Padding(
                padding: const EdgeInsets.all(8),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: machineStates.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = machineStates[index];
                    return Container(
                      height: customHeight * 0.20,
                      width: customWidth * 0.1,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color:
                              item.state ? stateMachineWork : stateMachineFree,
                          borderRadius: borderRadius),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: borderRadius,
                              ),
                              child: ClipRRect(
                                borderRadius: borderRadius,
                                child: Image(
                                  image: AssetImage(assetsimagejpg),
                                  fit: BoxFit.cover,
                                  width: customWidth,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 50,
                                    child: Center(
                                        child: Text(
                                      item.personalName ??
                                          "Tanımlı kullanıcı yok.",
                                    )),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 50,
                                    child: Center(
                                        child: Text(
                                      item.isEmri ?? "Tanımlı İE yok.",
                                    )),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 50,
                                    child: Center(
                                        child: Text(
                                      item.workBenchCode,
                                    )),
                                  )),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            case STATE.connectionErrorScreen:
              return const Center(child: Text("Connection Error"));
            default:
              return const Center(child: Text("default returned"));
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getMachineState();
        },
        backgroundColor: const Color.fromARGB(255, 131, 5, 5),
        child: const Icon(Icons.replay),
      ),
    );
  }
}

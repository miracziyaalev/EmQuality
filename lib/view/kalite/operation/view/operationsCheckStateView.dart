import 'dart:async';

import 'package:emkaliteapp/core/base/state/base_state.dart';
import 'package:emkaliteapp/core/base/view/connectionErrorView.dart';
import 'package:emkaliteapp/view/kalite/operation/model/operationModel.dart';
import 'package:emkaliteapp/view/kalite/operation/view/loadedOperationViews.dart';
import 'package:emkaliteapp/view/kalite/operation/service/getOperationModelService.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

enum STATE { loadingScreen, loadedScreen, connectionErrorScreen }

class OperationCheckStateView extends StatefulWidget {
  const OperationCheckStateView({super.key});

  @override
  State<OperationCheckStateView> createState() =>
      _OperationCheckStateViewState();
}

class _OperationCheckStateViewState extends BaseState<OperationCheckStateView> {
  late StreamController<STATE> streamControllerBase;
  late List<OperationModel> operationModel;

  @override
  void initState() {
    streamControllerBase = BehaviorSubject<STATE>();
    checkDataProsess();
    super.initState();
  }

  @override
  void dispose() {
    streamControllerBase.close();
    super.dispose();
  }

  Future<void> checkDataProsess() async {
    streamControllerBase.add(STATE.loadingScreen);
    await GetOperationsService.fetchOperationsAll().then((value) {
      if (value != null) {
        operationModel = value;
        if (!streamControllerBase.isClosed) {
          streamControllerBase.add(STATE.loadedScreen);
        }
      } else {
        if (!streamControllerBase.isClosed) {
          streamControllerBase.add(STATE.connectionErrorScreen);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<STATE>(
          stream: streamControllerBase.stream,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case STATE.loadingScreen:
                return const Center(child: CircularProgressIndicator());
              case STATE.loadedScreen:
                return  OperationsScreen(operationsModelAll: operationModel);
              case STATE.connectionErrorScreen:
                return const ConnectionErrorView();
              default:
                return const Text("default");
            }
          }),
    );
  }
}

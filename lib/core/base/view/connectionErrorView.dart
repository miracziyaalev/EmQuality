import 'package:emkaliteapp/core/base/state/base_state.dart';
import 'package:flutter/material.dart';

class ConnectionErrorView extends StatefulWidget {
  const ConnectionErrorView({super.key});

  @override
  State<ConnectionErrorView> createState() => _ConnectionErrorViewState();
}

class _ConnectionErrorViewState extends BaseState<ConnectionErrorView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Connection Error"),
      ),
    );
  }
}

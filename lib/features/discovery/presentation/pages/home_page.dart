import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/discovery_bloc.dart';
import '../bloc/discovery_event.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<DiscoveryBloc>().add(const StartDiscovery());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: const HomeAppBar(), body: const HomeContent());
  }
}

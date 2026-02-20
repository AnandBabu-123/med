import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import '../../bloc/store_bloc/store_bloc.dart';
import '../../bloc/store_bloc/store_event.dart';
import '../../bloc/store_bloc/store_state.dart';
import '../../utils/enums.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stores")),
      body: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          /// 🔄 Loading
          if (state.status == PostApiStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          /// ❌ Failure
          if (state.status == PostApiStatus.failure) {
            return Center(child: Text(state.message));
          }

          /// 📭 Empty
          if (state.stores.isEmpty) {
            return const Center(child: Text("No Stores Found"));
          }

          /// ✅ Success List
          return ListView.builder(
            itemCount: state.stores.length,
            itemBuilder: (context, index) {
              final storeItem = state.stores[index];

              /// 🛡 SAFE NULL CHECK
              final firstStore = (storeItem.stores?.isNotEmpty ?? false)
                  ? storeItem.stores!.first
                  : null;

              return Card(
                child: ListTile(
                  title: Text(firstStore?.name ?? "No Name"),
                  subtitle: Text(firstStore?.district ?? "No District"),
                  trailing: Text(firstStore?.state ?? "No State"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


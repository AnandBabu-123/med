import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medryder/bloc/confirm_pharmcyorder_bloc/confirm_pharmacyorder_bloc.dart';
import 'package:medryder/bloc/confirm_pharmcyorder_bloc/confirm_pharmacyorder_event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/confirm_pharmcyorder_bloc/confirm_pharmacyorder_state.dart';
import '../../utils/session_manager.dart';


class ConfirmPharmacyOrderScreen extends StatefulWidget {
  final File file;
  final int pharmacyId;
  final String orderType;
  final String language;

  const ConfirmPharmacyOrderScreen({
    super.key,
    required this.file,
    required this.pharmacyId,
    required this.orderType,
    required this.language,
  });

  @override
  State<ConfirmPharmacyOrderScreen> createState() =>
      _ConfirmPharmacyOrderScreenState();
}

class _ConfirmPharmacyOrderScreenState
    extends State<ConfirmPharmacyOrderScreen> {

  String address = "";
  String mobile = "";
  int addressId = 0;
  String name = "";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSession();
  }

  Future<void> loadSession() async {

    final prefs = await SharedPreferences.getInstance();

    address = await SessionManager.getAddress() ?? "";
    mobile = prefs.getInt(SessionManager.mobileKey)?.toString() ?? "";
    addressId = prefs.getInt("id") ?? 0;
    name = await SessionManager.getLanguage() ?? "";

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return BlocConsumer<ConfirmPharmacyOrderBloc,
        ConfirmPharmacyOrderState>(

      listener: (context, state) {

        if (state is ConfirmOrderPharmacySuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }

        if (state is ConfirmOrderPharmacyError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },

      builder: (context, state) {

        return Scaffold(

          appBar: AppBar(
            title: const Text("Confirm Order"),
          ),

          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {

                context.read<ConfirmPharmacyOrderBloc>().add(
                  SubmitConfirmPharmacyOrderEvent(
                    pharmacyId: widget.pharmacyId,
                    file: widget.file,
                    orderType: widget.orderType,
                    language: widget.language,
                    addressId: addressId,
                    name: name,
                    mobile: mobile,
                  ),
                );
              },
              child: state is ConfirmOrderPharmacyLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Confirm"),
            ),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Prescription",
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    widget.file,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Delivery Address",
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [

                      const Icon(Icons.location_on, color: Colors.red),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          address.isEmpty
                              ? "No address selected"
                              : address,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Mobile Number",
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [

                      const Icon(Icons.phone, color: Colors.green),

                      const SizedBox(width: 10),

                      Text(mobile),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
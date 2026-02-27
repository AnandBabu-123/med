import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medryder/config/colors/app_colors.dart';

import '../../bloc/pharmacy_bloc/pharmacy_bloc.dart';
import '../../bloc/pharmacy_bloc/pharmcy_state.dart';

class PharmacyScreen extends StatelessWidget {
  final String selectedLanguage;

  const PharmacyScreen({
    super.key,
    required this.selectedLanguage,
  });

  static const String imageBaseUrl =
      "https://medconnect.org.in/bharosa/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          /// ================= HEADER (APPBAR + SEARCH) =================
          Container(
            color:AppColors.lightblue,
            padding: const EdgeInsets.only(
              top: 40,
              left: 12,
              right: 12,
              bottom: 16,
            ),
            child: Column(
              children: [

                /// AppBar Row
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        "Pharmacy",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48) // balance back icon
                  ],
                ),

                const SizedBox(height: 10),

                /// Search Bar
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search medicines...",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// ================= API LIST =================
          Expanded(
            child: BlocBuilder<PharmacyBloc, PharmacyState>(
              builder: (context, state) {
                if (state.status == PharmacyStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state.status == PharmacyStatus.failure) {
                  return Center(child: Text(state.message));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.categories.length,
                  itemBuilder: (_, index) {
                    final item = state.categories[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 6,
                          )
                        ],
                      ),
                      child: Row(
                        children: [

                          /// ✅ Circular Image
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: NetworkImage(
                              imageBaseUrl + item.image,
                            ),
                          ),

                          const SizedBox(width: 16),

                          /// ✅ Name Right Side
                          Expanded(
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/get_address_bloc/get_address_bloc.dart';
import '../../../bloc/get_address_bloc/get_address_state.dart';
import '../../../config/colors/app_colors.dart';
import '../../../config/routes/routes_name.dart';

class AddressBottomSheet extends StatelessWidget {
  final Function(String) onSelect;

  const AddressBottomSheet({
    super.key,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {

    /// Fixed Height BottomSheet
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),

      child: Column(
        children: [

          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Your Addresses",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),

          const SizedBox(height: 10),

          /// ================= ADDRESS LIST =================
          Expanded(
            child: BlocBuilder<GetAddressBloc, GetAddressState>(
              builder: (context, state) {

                /// LOADING
                if (state.status == GetAddressStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                /// ERROR
                if (state.status == GetAddressStatus.failure) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                /// EMPTY
                if (state.addresses.isEmpty) {
                  return const Center(
                    child: Text("No addresses found"),
                  );
                }

                /// LIST (SCROLLABLE)
                return ListView.separated(
                  itemCount: state.addresses.length,
                  separatorBuilder: (_, __) =>
                  const Divider(height: 1),
                  itemBuilder: (context, index) {

                    final item = state.addresses[index];

                    return ListTile(
                      contentPadding: EdgeInsets.zero,

                      leading: const Icon(
                        Icons.location_on,
                        color: AppColors.lightblue,
                      ),

                      title: Text(
                        item.address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),

                      subtitle: Text(
                        "${item.city}, ${item.state}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.black,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                        ),
                      ),

                      /// ✅ RIGHT SIDE ARROW
                      trailing: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.lightblue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: AppColors.lightblue,
                        ),
                      ),

                      onTap: () {
                        onSelect(item.address);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
          ),

          /// ================= ADD ADDRESS BUTTON =================
          SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {

                  Navigator.pop(context); // close sheet

                  Navigator.pushNamed(
                    context,
                    RoutesName.addAddress,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightblue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Add New Address",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
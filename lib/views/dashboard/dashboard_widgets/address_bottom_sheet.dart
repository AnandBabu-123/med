import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../bloc/get_address_bloc/get_address_bloc.dart';
import '../../../bloc/get_address_bloc/get_address_state.dart';
import '../../../bloc/language_bloc/language_bloc.dart';
import '../../../bloc/language_bloc/language_state.dart';
import '../../../config/colors/app_colors.dart';
import '../../../config/language/app_strings.dart';
import '../../../config/routes/routes_name.dart';
import '../../../models/get_address/get_address_model.dart';

class AddressBottomSheet extends StatelessWidget {
 // final Function(String) onSelect;
  final Function(AddressItem) onSelect;

  const AddressBottomSheet({
    super.key,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, langState) {

        final language = langState.language;

        final yourAddresses =
        AppStrings.get(language, "yourAddresses");

        final useExactLocation =
        AppStrings.get(language, "useExactLocation");

        final noAddressesFound =
        AppStrings.get(language, "noAddressesFound");

        final addNewAddress =
        AppStrings.get(language, "addNewAddress");

        return Container(
          height: MediaQuery.of(context).size.height * 0.65,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(22),
            ),
          ),

          child: Column(
            children: [

              /// ================= HEADER =================
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    yourAddresses,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),

              const SizedBox(height: 10),

              /// ================= USE EXACT LOCATION =================
              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Geolocator.openLocationSettings();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AppColors.lightblue.withOpacity(0.85),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(
                    Icons.my_location,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: Text(
                    useExactLocation,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              /// ================= ADDRESS LIST =================
              Expanded(
                child: BlocBuilder<GetAddressBloc, GetAddressState>(
                  builder: (context, state) {

                    if (state.status == GetAddressStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state.status == GetAddressStatus.failure) {
                      return Center(
                        child: Text(state.message, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    if (state.addresses.isEmpty) {
                      return Center(
                        child: Text(noAddressesFound,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: state.addresses.length,
                      itemBuilder: (context, index) {
                        final item =
                        state.addresses[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white, borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.lightblue.withOpacity(0.15),
                            ),
                          ),

                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            // onTap: () {
                            //   onSelect(item.address);
                            //   Navigator.pop(context);
                            // },
                            onTap: () {
                              onSelect(item);
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [

                                /// ICON
                                Container(padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: AppColors.lightblue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),),
                                  child: Icon(
                                    item.addressType.toLowerCase() =="home" ? Icons.location_on
                                        : Icons.work_rounded, color: AppColors.lightblue, size: 20,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      /// ADDRESS TYPE
                                      Text(
                                        item.addressType,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                                          color: AppColors.lightblue,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      /// ADDRESS
                                      Text(item.address, maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13, fontWeight: FontWeight.w500,
                                          color: AppColors.black,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),

                                      const SizedBox(height: 2),

                                      /// CITY STATE
                                      Text(
                                        "${item.city}, ${item.state}",
                                        style: const TextStyle(fontSize: 13, fontWeight:FontWeight.w500,
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14, color: AppColors.lightblue,
                                ),
                              ],
                            ),
                          ),
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
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        RoutesName.addAddress,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      AppColors.lightblue,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            10),
                      ),
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: Text(
                      addNewAddress,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
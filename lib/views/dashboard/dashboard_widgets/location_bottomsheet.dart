import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/language_bloc/language_bloc.dart';
import '../../../bloc/language_bloc/language_state.dart';
import '../../../config/language/app_strings.dart';

class LocationBottomSheet {

  static void open(BuildContext context, String? address) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {

            final language = state.language;

            final selectAddress =
            AppStrings.get(language, "selectAddress");

            final noAddress =
            AppStrings.get(language, "noAddressFound");

            final addNewAddress =
            AppStrings.get(language, "addNewAddress");

            return Container(
              padding: const EdgeInsets.all(20),
              height: 220,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    selectAddress,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(address ?? noAddress),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                      },
                      child: Text(addNewAddress),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/banner_bloc/banner_bloc.dart';
import '../../../bloc/banner_bloc/banner_event.dart';
import '../../../bloc/banner_bloc/banner_state.dart';


class DashboardBannerList extends StatefulWidget {
  const DashboardBannerList({super.key});

  @override
  State<DashboardBannerList> createState() =>
      _DashboardBannerListState();
}

class _DashboardBannerListState
    extends State<DashboardBannerList> {

  @override
  void initState() {
    super.initState();
    context.read<BannerBloc>().add(FetchBannerEvent());
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<BannerBloc, BannerState>(
      builder: (context, state) {

        if (state is BannerLoading) {
          return const Center(
              child: CircularProgressIndicator());
        }

        if (state is BannerLoaded) {
          return SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.banners.length,
              itemBuilder: (context, index) {

                final banner = state.banners[index];

                return Container(
                  width: 280,
                  margin:
                  const EdgeInsets.only(right: 12),
                  child: Stack(
                    children: [

                      /// IMAGE
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(12),
                        child: Image.network(
                          banner.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder:
                              (_, __, ___) =>
                          const Icon(Icons.error),
                        ),
                      ),

                      /// ✅ SHOW ID (for debug)

                    ],
                  ),
                );
              },
            ),
          );
        }

        if (state is BannerError) {
          return Text(state.message);
        }

        return const SizedBox();
      },
    );
  }
}

// class DashboardBannerList extends StatelessWidget {
//   const DashboardBannerList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     context.read<BannerBloc>().add(FetchBannerEvent());
//
//     return BlocBuilder<BannerBloc, BannerState>(
//       builder: (context, state) {
//
//         if (state is BannerLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (state is BannerLoaded) {
//           return SizedBox(
//             height: 140,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: state.banners.length,
//               itemBuilder: (context, index) {
//
//                 String base64Image =
//                 state.banners[index]['base64'];
//
//                 return Container(
//                   width: 280,
//                   margin: const EdgeInsets.only(right: 12),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.memory(
//                       base64Decode(base64Image),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         }
//
//         if (state is BannerError) {
//           return Text(state.message);
//         }
//
//         return const SizedBox();
//       },
//     );
//   }
// }
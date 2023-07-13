// import 'dart:async';
// import 'package:address_search_field/address_search_field.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// // import 'package:permission_handler/permission_handler.dart';
//
// class autoCompletePlaces extends StatefulWidget {
//   const autoCompletePlaces({Key key}) : super(key: key);
//
//   @override
//   State<autoCompletePlaces> createState() => _autoCompletePlacesState();
// }
//
// class _autoCompletePlacesState extends State<autoCompletePlaces> {
//   final geoMethods = GeoMethods(
//     googleApiKey: 'GOOGLE_API_KEY',
//     language: 'en',
//     countryCode: 'in',
//     countryCodes: ['us', 'es', 'co'],
//     country: 'India'
//     // city: 'New York',
//   );
//   // GeoMethods geoMethods;
//   TextEditingController controller;
//   Address destinationAddress;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: TextField(
//         controller: controller,
//         onTap: () => showDialog(context:context,
//             builder: (BuildContext context) => AddressSearchBuilder(
//               builder: (context)=>,
//               geoMethods: geoMethods,
//               controller: controller,
//               //onDone: (Address address) => destinationAddress = address,
//             )
//         ),
//       )
//     );
//   }
// }

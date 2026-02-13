// import 'package:flutter/material.dart';
// import 'package:flutter_paystack_plus/flutter_paystack_plus.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class PaymentService {
//   // Replace with your actual key (store in .env or secure config, never commit)
//   static const String paystackPublicKey = 'pk_test_your_test_public_key_here';

//   // Your product price in GHS (double)
//   final double productPrice; // e.g. 150.00
//   final String userEmail;    // from auth or form
//   final BuildContext context;

//   PaymentService({
//     required this.productPrice,
//     required this.userEmail,
//     required this.context,
//   });

//   Future<void> showPaymentMethodDialog({
//     required String? selectedSize,
//     required String? selectedColor,
//   }) async {
//     if (selectedSize == null || selectedColor == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select size and color first")),
//       );
//       return;
//     }

//     final int amountInPesewas = (productPrice * 100).toInt();
//     final String reference = "comfi_${DateTime.now().millisecondsSinceEpoch}";

//     showDialog(
//       context: context,
//       builder: (dialogCtx) {
//         return AlertDialog(
//           title: const Text("Choose Payment Method"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.account_balance_wallet),
//                 title: const Text("Mobile Money (MTN, Vodafone, AirtelTigo)"),
//                 subtitle: const Text("Fast & convenient"),
//                 onTap: () {
//                   Navigator.pop(dialogCtx);
//                   _initiatePayment(
//                     amountInPesewas: amountInPesewas,
//                     reference: reference,
//                     preferredChannel: 'mobile_money',
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.credit_card),
//                 title: const Text("Card Payment"),
//                 subtitle: const Text("Visa, Mastercard"),
//                 onTap: () {
//                   Navigator.pop(dialogCtx);
//                   _initiatePayment(
//                     amountInPesewas: amountInPesewas,
//                     reference: reference,
//                     preferredChannel: 'card',
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.money),
//                 title: const Text("Pay on Delivery"),
//                 subtitle: const Text("Cash/Card when item arrives"),
//                 onTap: () {
//                   Navigator.pop(dialogCtx);
//                   _handlePayOnDelivery(reference);
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(dialogCtx),
//               child: const Text("Cancel"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _initiatePayment({
//     required int amountInPesewas,
//     required String reference,
//     String? preferredChannel,
//   }) async {
//     try {
//       // 1. Initialize transaction on YOUR backend (required for security)
//       final initResponse = await http.post(
//         Uri.parse('https://your-backend.com/api/initialize-payment'), // ← Replace!
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email': userEmail,
//           'amount': amountInPesewas, // already in pesewas
//           'reference': reference,
//           'currency': 'GHS',
//           // optional: 'channels': [preferredChannel],
//         }),
//       );

//       if (initResponse.statusCode != 200) {
//         throw Exception('Failed to initialize: ${initResponse.body}');
//       }

//       final initData = jsonDecode(initResponse.body);
//       final accessCode = initData['data']['access_code'];
//       final transactionRef = initData['data']['reference'];

//       // 2. Initialize plugin
//       final paystack = PaystackPlugin();
//       await paystack.initialize(publicKey: paystackPublicKey);

//       // 3. Create charge
//       final charge = Charge()
//         ..amount = amountInPesewas
//         ..email = userEmail
//         ..reference = transactionRef
//         ..accessCode = accessCode
//         ..currency = 'GHS';

//       // 4. Checkout
//       final response = await paystack.checkout(
//         context,
//         charge: charge,
//         method: CheckoutMethod.selectable, // or .card, .bank, etc.
//       );

//       if (response.status == true) {
//         // Success → verify server-side!
//         await _verifyOnBackend(response.reference ?? reference);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Payment successful! Ref: ${response.reference}')),
//         );
//         // Navigate to success, clear cart, etc.
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Payment failed: ${response.message ?? "Unknown error"}'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
//       );
//     }
//   }

//   Future<void> _verifyOnBackend(String reference) async {
//     // Call your backend /verify endpoint
//     // Example:
//     // await http.post(Uri.parse('https://your-backend.com/api/verify-payment'), body: {'reference': reference});
//     // Check response and update order status
//   }

//   void _handlePayOnDelivery(String reference) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Confirm Order"),
//         content: const Text("Your order will be delivered. Pay cash/card on arrival."),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(ctx);
//               // Call backend to create COD order
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Order placed! We'll deliver soon.")),
//               );
//             },
//             child: const Text("Confirm"),
//           ),
//           TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
//         ],
//       ),
//     );
//   }
// }

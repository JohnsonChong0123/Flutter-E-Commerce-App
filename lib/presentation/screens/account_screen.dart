import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../../core/common/utils/show_snackbar.dart';
import '../../../../core/common/widgets/app_alert_dialog.dart';
import '../../core/themes/app_colors.dart';
import '../widgets/account_card.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Account",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            AccountCard(
              name: "Orders History",
              icon: const Icon(Icons.shopping_bag, color: AppColor.primary),
              onTap: () {
                // Navigator.push(context, OrderHistoryScreen.route());
              },
            ),
            const SizedBox(height: 15),
            AccountCard(
              name: "Profile",
              icon: const Icon(Icons.person, color: AppColor.primary),
              onTap: () async {
                // Navigator.push(context, ProfileScreen.route());
              },
            ),
            const SizedBox(height: 15),
            AccountCard(
              name: "Address",
              icon: const Icon(Icons.location_on, color: AppColor.primary),
              onTap: () async {
                // Navigator.push(context, LocationScreen.route());
              },
            ),
            const SizedBox(height: 15),
            AccountCard(
              name: "Wallet",
              icon: const Icon(Icons.wallet, color: AppColor.primary),
              onTap: () async {
                // Navigator.push(context, WalletScreen.route());
              },
            ),
            const SizedBox(height: 15),
            // AccountCard(
            //   name: "Change Password",
            //   icon: const Icon(Icons.password, color: AppColor.primary),
            //   onTap: () async {
            //     Navigator.push(context, ChangePwScreen.route());
            //   },
            // ),
            // const SizedBox(height: 15),
            // BlocConsumer<AuthBloc, AuthState>(
            //   listener: (context, state) {
            //     if (state is AuthFailure) {
            //       showSnackBar(context, state.message);
            //     } else if (state is AuthSuccess) {
            //       showSnackBar(context, state.message);
            //       Navigator.pushReplacement(context, LoginScreen.route());
            //     }
            //   },
            //   builder: (context, state) {
            //     return AccountCard(
            //       name: "Logout",
            //       icon: const Icon(Icons.logout, color: AppColor.primary),
            //       onTap: () async {
            //         showDialog(
            //           context: context,
            //           builder: (context) => AppAlertDialog(
            //             onYesPressed: () {
            //               context.read<AuthBloc>().add(AuthLogout());
            //             },
            //             onNoPressed: () {
            //               Navigator.of(context).pop();
            //             },
            //             title: 'Logout',
            //             content: 'Are you sure you want to logout?',
            //           ),
            //         );
            //       },
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
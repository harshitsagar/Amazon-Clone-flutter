import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/address/services/address_services.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {

  final _addressFormKey = GlobalKey<FormState>();
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  String addressToBeUsed = "";

  final Future<PaymentConfiguration> _applePayConfigFuture =
  PaymentConfiguration.fromAsset('applepay.json');
  final Future<PaymentConfiguration> _googlePayConfigFuture =
  PaymentConfiguration.fromAsset('gpay.json');

  List<PaymentItem> paymentItems = [];
  final AddressServices addressServices = AddressServices();


  @override
  void initState() {
    super.initState();

    paymentItems.add(
        PaymentItem(
            amount: widget.totalAmount,
            label: 'Total Amount',
            status: PaymentItemStatus.final_price
        ),
    );

  }

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
  }

  void onApplePayResult(res) {
    if(Provider.of<UserProvider>(context, listen: false).user.address.isEmpty) {
      addressServices.saveUserAddress(context: context, address: addressToBeUsed);
    }
    addressServices.placeOrder(
        context: context,
        address: addressToBeUsed,
        totalSum: double.parse(widget.totalAmount)
    );
  }

  void onGooglePayResult(res) {
    if(Provider.of<UserProvider>(context, listen: false).user.address.isEmpty) {
      addressServices.saveUserAddress(context: context, address: addressToBeUsed);
    }
    addressServices.placeOrder(
        context: context,
        address: addressToBeUsed,
        totalSum: double.parse(widget.totalAmount)
    );
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = "";

    bool isForm = flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;

    if(isForm) {
      if(_addressFormKey.currentState!.validate()) {
        addressToBeUsed = '${flatBuildingController.text}, ${areaController.text}, ${cityController.text} - ${pincodeController.text}';
      } else {
        throw Exception('Please enter all the values!');
      }
    } else if(addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackBar(context, 'Error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;
    return Scaffold(

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [

              if(address.isNotEmpty)
                Column(
                  children: [

                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          address,
                          style: GoogleFonts.notoSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      child: Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey)),
                          SizedBox(width: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('or', style: TextStyle(color: Colors.grey, fontSize: 20)),
                          ),
                          SizedBox(width: 10),
                          Expanded(child: Divider(color: Colors.grey)),
                        ],
                      ),
                    ),

                  ],
                ),

              Form(
                  key: _addressFormKey,
                  child: Column(
                    children: [

                      CustomTextfield(
                          controller: flatBuildingController,
                          hintText: 'Flat, House no, Building'
                      ),

                      const SizedBox(height: 10,),

                      CustomTextfield(
                          controller: areaController,
                          hintText: 'Area, Street'
                      ),

                      const SizedBox(height: 10,),

                      CustomTextfield(
                          controller: pincodeController,
                          hintText: 'Pincode'
                      ),

                      const SizedBox(height: 10,),

                      CustomTextfield(
                          controller: cityController,
                          hintText: 'Town/City'
                      ),

                      const SizedBox(height: 10,),

                    ],
                  )
              ),

              // Apple Pay Button......
              FutureBuilder<PaymentConfiguration>(
                  future: _applePayConfigFuture,
                  builder: (context, snapshot) => snapshot.hasData
                      ? ApplePayButton(
                    onPressed: () => payPressed(address),
                    width: double.infinity,
                    height: 50,
                    style: ApplePayButtonStyle.whiteOutline,
                    paymentConfiguration: snapshot.data!,
                    paymentItems: paymentItems,
                    type: ApplePayButtonType.buy,
                    margin: const EdgeInsets.only(top: 15.0),
                    onPaymentResult: onApplePayResult,
                    loadingIndicator: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ) : const SizedBox.shrink()
              ),

              const SizedBox(height: 10,),

              // Google Pay Button......
              FutureBuilder<PaymentConfiguration>(
                  future: _googlePayConfigFuture,
                  builder: (context, snapshot) => snapshot.hasData
                      ? GooglePayButton(
                    onPressed: () => payPressed(address),
                    width: double.infinity,
                    height: 50,
                    paymentConfiguration: snapshot.data!,
                    paymentItems: paymentItems,
                    type: GooglePayButtonType.buy,
                    margin: const EdgeInsets.only(top: 15.0),
                    onPaymentResult: onGooglePayResult,
                    loadingIndicator: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ) : const SizedBox.shrink()
              ),

            ],
          ),
        ),
      ),

    );
  }
}

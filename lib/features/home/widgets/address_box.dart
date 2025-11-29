import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressBox extends StatelessWidget {
  const AddressBox({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Container(
      height: 40,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 165, 48),
            Color.fromARGB(255, 255, 191, 0)
          ],
          stops: [0.1, 0.9],
        ),
      ),
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            color: Colors.black,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              'Delivery to ${user.name} - ${user.address}',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 2, top: 2),
            child: Icon(
              Icons.arrow_drop_down_outlined,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
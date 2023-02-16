import 'package:flutter/material.dart';

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 150,
                width: 150,
                child: Image.asset("lib/images/languages.png")),
            SizedBox(
              height: 30,
            ),
            Icon(Icons.signal_wifi_connected_no_internet_4_outlined, size: 80),
            Text(
              "No Internet Connection",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

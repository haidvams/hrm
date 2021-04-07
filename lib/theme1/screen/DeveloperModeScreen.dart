import 'package:flutter/material.dart';
import 'package:hrm/main/utils/SDColors.dart';
import 'package:hrm/main/utils/SDStyle.dart';
import 'package:hrm/smartDeck/Screens/SDHomePageScreen.dart';

class DeveloperModeScreen extends StatefulWidget {
  @override
  _SDCongratulationsScreenState createState() => _SDCongratulationsScreenState();
}

class _SDCongratulationsScreenState extends State<DeveloperModeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: sdAppBackground,
        body: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              padding: EdgeInsets.only(left: 26, right: 26),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage('images/theme1/icons8-artificial_intelligence.png'), height: size.height * 0.18, fit: BoxFit.cover),
                  SizedBox(height: 20),
                  Text("hi!", style: boldTextStyle(size: 20)),
                  SizedBox(height: 16),
                  Text("The feature is being developed by Dbiz", textAlign: TextAlign.center, style: secondaryTextStyle()),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: SDButton(
                textContent: "CLOSE",
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => SDHomePageScreen()));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

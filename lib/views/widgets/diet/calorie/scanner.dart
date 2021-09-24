import 'package:flutter/material.dart';
import 'package:healthy_lifestyle_app/constant.dart';


class Scanner extends StatefulWidget {
  final Function scanQR;
  final bool isWaiting;
  Scanner(this.scanQR, this.isWaiting);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  @override
  Widget build(BuildContext context) {
    

    return widget.isWaiting ? CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(kGreenColor),) :
    ElevatedButton.icon(
      onPressed: widget.scanQR,
      label: Text("Scan with barcode", style: TextStyle(color: kWhiteColor),),
      icon: Icon(
        Icons.qr_code_scanner_rounded,
        color: kWhiteColor,
      ),
      style: ElevatedButton.styleFrom(
        elevation: 2.0,
        primary: kGreenColor,
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20),),
      ),
    );
  }
}
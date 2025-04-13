import 'package:flutter/material.dart';
class LicensingFeesScreen extends StatefulWidget {
  @override
  _LicensingFeesScreenState createState() => _LicensingFeesScreenState();
}

class _LicensingFeesScreenState extends State<LicensingFeesScreen> {
  final TextEditingController _modelController = TextEditingController();
  String _feeResult = '';

  void calculateFee() {
    Map<String, int> fees = {
      '2006': 4600,
      '2007': 4800,
      '2008': 5000,
      '2009': 5200,
      '2010': 5400,
      '2011': 5600,
      '2012': 5800,
      '2013': 6000,
      '2014': 6200,
      '2015': 6400,
      '2016': 6600,
      '2017': 7140,
      '2018': 7700,
      '2019': 8000,
      '2020': 8800,
      '2021': 9360,
      '2022': 9900,
      '2023': 10460,
      '2024': 11000,
      '2025': 12000,
    };
    setState(() {
      _feeResult = fees[_modelController.text] != null ?
      'رسوم الترخيص لموديل ${_modelController.text} هي: ${fees[_modelController.text]} جنيه' :
      'الموديل غير متوفر، الرجاء إدخال موديل صحيح';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('رسوم الترخيص')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _modelController,
              decoration: InputDecoration(
                labelText: 'أدخل موديل السيارة',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: calculateFee,
              child: Text('احسب الرسوم'),
            ),
            SizedBox(height: 10),
            Text(
              _feeResult,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

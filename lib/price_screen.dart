import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'spinner.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: pickerItems,
    );
  }

  String value = '?';
  Map<String, String> coinValues = {};
  bool iswait = false;

  void getData() async {
    iswait = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      iswait = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return iswait
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Bitcoin Calculator'),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    cryptoCard(
                        selectedCrypto: 'BTC',
                        value: iswait ? '?' : coinValues['BTC'],
                        selectedCurrency: selectedCurrency),
                    cryptoCard(
                        selectedCrypto: 'ETH',
                        value: iswait ? '?' : coinValues['ETH'],
                        selectedCurrency: selectedCurrency),
                    cryptoCard(
                        selectedCrypto: 'LTC',
                        value: iswait ? '?' : coinValues['LTC'],
                        selectedCurrency: selectedCurrency)
                  ],
                ),

                Container(
                  height: 150.0,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 30.0),
                  color: Colors.red,
                  child: Platform.isIOS ? iOSPicker() : androidDropdown(),
                )
                //SizedBox(height: 145.0),
              ],
            ),
          );
  }
}

class cryptoCard extends StatelessWidget {
  const cryptoCard({
    Key key,
    @required this.value,
    @required this.selectedCurrency,
    @required this.selectedCrypto,
  }) : super(key: key);

  final String value;
  final String selectedCurrency;
  final String selectedCrypto;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 9.0, 18.0, 0),
      child: Card(
        color: Colors.red,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $selectedCrypto = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

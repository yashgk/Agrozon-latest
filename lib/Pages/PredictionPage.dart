import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PredictionPage extends StatefulWidget {
  const PredictionPage({Key key}) : super(key: key);

  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  TextEditingController nCtrl = TextEditingController();
  TextEditingController pCtrl = TextEditingController();
  TextEditingController kCtrl = TextEditingController();
  TextEditingController phCtrl = TextEditingController();
  TextEditingController humidityCtrl = TextEditingController();
  TextEditingController tempCtrl = TextEditingController();
  TextEditingController rainfallCtrl = TextEditingController();
  TextEditingController stateCtrl = TextEditingController();
  TextEditingController cropCtrl = TextEditingController();
  bool isLoading = false;
  bool cdone = false;
  bool ydone = false;
  String crop = "";
  String iamToken = "";
  String predictedYield = "";
  var n, p, k, temp, ph, humidity, rainfall, state, ycrop;
  Future getAccessToken() async {
    setState(() {
      isLoading = true;
    });
    final response =
        await http.post(Uri.parse("https://iam.cloud.ibm.com/identity/token"),
            body: {
              "grant_type": "urn:ibm:params:oauth:grant-type:apikey",
              "apikey": "jWZ_xbe0joKsCADmU5ipeE6jQdffE2iUVtK-7n9xuQDV"
            },
            headers: <String, String>{
              "Content-Type": "application/x-www-form-urlencoded",
              "Accept": "application/json",
              "Access-Control-Allow-Origin": "*",
            },
            encoding: Encoding.getByName("utf-8"));
    Map res = jsonDecode(response.body);
    print('getting token successfull');
    iamToken = res['access_token'];
    setState(() {
      isLoading = false;
    });
  }

  Future getRecommendedCrop() async {
    setState(() {
      isLoading = true;
    });
    final body = jsonEncode({
      "input_data": [
        {
          "fields": [
            "N",
            "P",
            "K",
            "temperature",
            "humidity",
            "ph",
            "rainfall"
          ],
          "values": [
            [n, p, k, temp, humidity, ph, rainfall]
          ]
        }
      ]
    });
    try {
      final cropres = await http.post(
        Uri.parse(
            "https://us-south.ml.cloud.ibm.com/ml/v4/deployments/c22115ce-b6de-4d38-a2b6-413ae20cfe7b/predictions?version=2021-08-30"),
        body: body,
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Authorization": "Bearer $iamToken",
        },
        encoding: Encoding.getByName("utf-8"),
      );

      Map finalres = jsonDecode(cropres.body);
      crop = finalres['predictions'][0]['values'][0][0].toString();
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    setState(() {
      cdone = true;
      isLoading = false;
    });
  }

  Future getYieldPrediction() async {
    setState(() {
      isLoading = true;
    });
    final body = jsonEncode({
      "input_data": [
        {
          "fields": ["Crop", "State"],
          "values": [
            [ycrop, state]
          ]
        }
      ]
    });
    try {
      final yieldres = await http.post(
        Uri.parse(
            "https://us-south.ml.cloud.ibm.com/ml/v4/deployments/8e82e510-8071-46b6-9918-250906e53165/predictions?version=2021-08-30"),
        body: body,
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
          "Authorization": "Bearer $iamToken",
        },
        encoding: Encoding.getByName("utf-8"),
      );

      Map result = jsonDecode(yieldres.body);

      predictedYield = result['predictions'][0]['values'][0][0].toString();
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      ydone = true;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    cdone
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(width: 2, color: Colors.black)),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.7,
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Recommended Crop :",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    crop,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          cdone = false;
                                          nCtrl.clear();
                                          pCtrl.clear();
                                          kCtrl.clear();
                                          humidityCtrl.clear();
                                          tempCtrl.clear();
                                          tempCtrl.clear();
                                          phCtrl.clear();
                                        });
                                      },
                                      icon: Icon(Icons.refresh))
                                ],
                              ),
                            ))
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(width: 2, color: Colors.black)),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.7,
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  'Crop Recommedation',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: nCtrl,
                                    decoration: InputDecoration(
                                        hintText: "N *",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: pCtrl,
                                    decoration: InputDecoration(
                                        hintText: "P *",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: kCtrl,
                                    decoration: InputDecoration(
                                        hintText: "K *",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: humidityCtrl,
                                    decoration: InputDecoration(
                                        hintText: "Humidity *",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: phCtrl,
                                    decoration: InputDecoration(
                                        hintText: "ph value *",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: tempCtrl,
                                    decoration: InputDecoration(
                                        hintText: "Temperature value *",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: rainfallCtrl,
                                    decoration: InputDecoration(
                                        hintText: "Rainfall *",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                  ),
                                ),
                                InkWell(
                                    onTap: () async {
                                      if (nCtrl.text.isEmpty ||
                                          pCtrl.text.isEmpty ||
                                          kCtrl.text.isEmpty ||
                                          phCtrl.text.isEmpty ||
                                          humidityCtrl.text.isEmpty ||
                                          rainfallCtrl.text.isEmpty ||
                                          tempCtrl.text.isEmpty ||
                                          nCtrl.text == "" ||
                                          pCtrl.text == "" ||
                                          kCtrl.text == " " ||
                                          phCtrl.text == " " ||
                                          humidityCtrl.text == "" ||
                                          rainfallCtrl.text == "" ||
                                          tempCtrl.text == "") {
                                        final snackBar = SnackBar(
                                            content:
                                                Text('Fiels must not be null'));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } else {
                                        try {
                                          n = int.tryParse(nCtrl.text);
                                          p = int.tryParse(pCtrl.text);
                                          k = int.tryParse(kCtrl.text);
                                          temp = double.tryParse(tempCtrl.text);
                                          humidity = double.tryParse(
                                              humidityCtrl.text);
                                          rainfall = double.tryParse(
                                              rainfallCtrl.text);
                                          ph = double.tryParse(phCtrl.text);
                                          if (ph > 7) {
                                            throw Exception(
                                                "Ph value must be within range [0,7]");
                                          }
                                          await getAccessToken();
                                          await getRecommendedCrop();
                                        } catch (e) {
                                          final snackBar = SnackBar(
                                              content: Text(e.toString()));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      }
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Text(
                                          'Submit',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        )))
                              ],
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    ydone
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(width: 2, color: Colors.black)),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.3,
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  'Expected Yield :',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  predictedYield,
                                  style: TextStyle(fontSize: 20),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        ydone = false;
                                        stateCtrl.clear();
                                        cropCtrl.clear();
                                      });
                                    },
                                    icon: Icon(Icons.refresh))
                              ],
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(width: 2, color: Colors.black)),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.35,
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  'Yield Prediction',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: stateCtrl,
                                    decoration: InputDecoration(
                                        hintText: "State *",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: cropCtrl,
                                    decoration: InputDecoration(
                                        hintText: "Crop *",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                    onTap: () async {
                                      if (stateCtrl.text.isEmpty ||
                                          stateCtrl.text == " " ||
                                          cropCtrl.text.isEmpty ||
                                          cropCtrl.text == " ") {
                                        final snackBar = SnackBar(
                                            content:
                                                Text('Fiels must not be null'));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } else {
                                        state = stateCtrl.text;
                                        ycrop = cropCtrl.text;
                                        await getAccessToken();
                                        await getYieldPrediction();
                                      }
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Text(
                                          'Submit',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        )))
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
  }
}

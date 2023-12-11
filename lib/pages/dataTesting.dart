import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:g_p/lots/cbalot1.dart';
import 'package:g_p/lots/chwlot1.dart';
import 'package:g_p/lots/chwlot2.dart';
import 'package:g_p/lots/porta.dart';
import 'dart:io';
import 'package:g_p/lots/hotWheels.dart';
import "package:g_p/pages/dataTesting.dart";
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class TTNDataPage extends StatefulWidget {
  @override
  _TTNDataPageState createState() => _TTNDataPageState();
}

class _TTNDataPageState extends State<TTNDataPage> {

  final controller = TextEditingController();
  //List<int> binaryList = [];
  //List<bool> booleanParkingDataList = [true,];
  List<bool> booleanParkingDataList= [true, true, true, true,true,true,true, true, true, true, true,true,true, true,true,true,true,true,true,true,true,true,true,true,true,true,];

  List<bool> getBooleanParkingDataList() {

    return booleanParkingDataList;
  }




  String frmPayload = '';

  @override
  void initState() {
    super.initState();
    GetParkingData();


  }

  Future<String> GetParkingData() async {
    try {

      String url = "https://api.tago.io/data?variable=payload&query=last_value"; //https://lora.mydevices.com/v1/networks/ttn/uplink    https://storage.googleapis.com/getparked/CHW%20lot1.json
      //https://nam1.cloud.thethings.network/api/v3/as/applications/get-parked-lot-0/devices/eui-70b3d57ed0061863/packages/storage/uplink_message https://storage.googleapis.com/getparked/HotWheelsLot4.json
      final response = await http.get(Uri.parse(url),
          headers: {
            HttpHeaders
                .authorizationHeader: '3a2a6522-9335-491e-addd-63521d380e5d',
          });
      print(response.body);
      if (response.statusCode == 200) {

        // Parse JSON and extract payload
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey("result") &&
            jsonResponse["result"] is List &&
            jsonResponse["result"].isNotEmpty)
        {
          print("if");

          String hexPayload = jsonResponse["result"][0]["value"];
          String binaryPayload = hexToBinary(hexPayload);
          setBooleanParkingDataList(binaryPayload);

          // Set the payload to the state variable
          setState(() {
            frmPayload = hexPayload;
          });

          // Return the payload
          return hexPayload;

        }
        else {
          print("else");
          throw Exception('No valid result in the response');
        }
      } else {
        throw Exception('Failed to load data');
      }
    }
    catch (e) {
      print(e);
      throw e; // Rethrow the exception to handle it in the UI
    }
  }

  void setBooleanParkingDataList(String binaryPayload) {
    // Assuming that booleanParkingDataList should be updated based on binaryPayload
    // You may need to adjust this logic based on your specific requirements
    List<bool> updatedList = binaryPayload
        .split('')
        .map((char) => char == '1')
        .toList();

    setState(() {
      booleanParkingDataList = updatedList;
    });
  }

  String hexToBinary(String hex) {
    // Convert hexadecimal string to binary string
    return BigInt.parse(hex, radix: 16).toRadixString(2);
  }


  @override
  Widget build(BuildContext context) => 
  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            
            Text(
              'TTN Test',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(width: 8),
            Image.network(
              'https://storage.googleapis.com/getparked/logo2.png',
              width: 125,
              height: 1000,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),


      
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 5),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          Text(frmPayload),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              //print('Binary List Values for Parking Availability: $binaryList');

              print(
                  'Boolean List Values for Parking Availability: $booleanParkingDataList');
                  
            },
            child: Text('Show 4-bit Binary Data'),
          ),

          


          Padding(
            // HOT WHEELS
            padding: EdgeInsetsDirectional.fromSTEB(15, 10, 15, 10),
            child: Container(
              width: 100,
              height: 199,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => hotWheels(booleanParkingDataList:
                                    getBooleanParkingDataList())));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(33),
                      child: Image.network(
                        'https://storage.googleapis.com/getparked/HotWheelsLot1.jpg',
                        width: 410,
                        height: 141,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 5),
                        child: Text(
                          'Hot Wheels Lot',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                 Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          'X AVAILABLE SPOTS',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            // CHW LOT 1
            padding: EdgeInsetsDirectional.fromSTEB(15, 10, 15, 10),
            child: Container(
              width: 100,
              height: 194,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      print("Boolean list $booleanParkingDataList");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => chwlot1(
                                booleanParkingDataList:
                                    getBooleanParkingDataList()),
                          ));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(33),
                      child: FittedBox(
                        child: Image.network(
                          'https://storage.googleapis.com/getparked/CHW%20lot1.jpg',
                          width: 425,
                          height: 141,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 6),
                        child: Text(
                          'CHW Lot 1',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          'X AVAILABLE SPOTS',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            // CBA LOT 1
            padding: EdgeInsetsDirectional.fromSTEB(15, 10, 15, 10),
            child: Container(
              width: 100,
              height: 199,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => cbalot1()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(33),
                      child: Image.network(
                        'https://storage.googleapis.com/getparked/CBA%20lot1.jpg',
                        width: 425,
                        height: 141,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 5),
                        child: Text(
                          'CBA Lot 1',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          'X AVAILABLE SPOTS',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            // CHW LOT 2
            padding: EdgeInsetsDirectional.fromSTEB(15, 10, 15, 10),
            child: Container(
              width: 100,
              height: 199,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => chwlot2()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(33),
                      child: Image.network(
                        'https://storage.googleapis.com/getparked/CHW%20lot2.jpg',
                        width: 425,
                        height: 141,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 5),
                        child: Text(
                          'CHW Lot 2',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          'X AVAILABLE SPOTS',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            // PORT A LOT
            padding: EdgeInsetsDirectional.fromSTEB(15, 10, 15, 10),
            child: Container(
              width: 100,
              height: 199,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => frontlot()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(33),
                      child: Image.network(
                        'https://storage.googleapis.com/getparked/PORTA.png',
                        width: 425,
                        height: 141,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 5),
                        child: Text(
                          'Portable A Lot',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Text(
                          'X AVAILABLE SPOTS',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ));
}

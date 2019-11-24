import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:nra/myticket.dart';

import 'model.dart';

String fr_loc, to_loc, t_date, t_duration, st_time, ar_time;

var storage = new AccessTicketFile();

int selectedRadio = 1;

class TicketInfo extends StatelessWidget {
  TicketInfo(
      {String from,
      String to,
      String date,
      String duration,
      String startTime,
      String arrivalTime}) {
    fr_loc = from;
    to_loc = to;
    st_time = startTime;
    ar_time = arrivalTime;
    t_duration = duration;
    t_date = date;
  }

  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Purchase Ticket", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.yellow,
        leading: InkWell(
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              TicketDetail(),
              PaymentType(),
              PaymentFunction(),
            ],
          ),
        ),
      ),
    );
  }
}

class TicketDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      margin: EdgeInsets.all(10),
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 10, left: 10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DecoratedBox(
                  decoration: const BoxDecoration(color: Colors.yellow),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(t_date,
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          fr_loc,
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                          size: 30.0,
                        ),
                        Text(
                          to_loc,
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Departure',
                          style: TextStyle(fontSize: 25.0),
                        ),
                        Text(
                          st_time,
                          style: TextStyle(
                              fontSize: 34.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Arival',
                        style: TextStyle(fontSize: 25.0),
                      ),
                      Text(
                        ar_time,
                        style: TextStyle(
                            fontSize: 34.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "Total Duration: " + t_duration + " hrs",
                    style: TextStyle(fontSize: 25.0),
                  ),
                ],
              ),
            ),
            new Divider(
              color: Colors.black,
            ),
            Row(
              children: <Widget>[
                Text(
                  "Passenger: 1 Adult",
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentFunction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(children: <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  String payOpt = "";
                  if (selectedRadio == 1) {
                    payOpt = "VISA";
                  } else {
                    payOpt = "VIPPS";
                  }

                  return AlertDialog(
                    title: new Text(
                        "Payment Confirmation"),
                    content: new Text(
                        "$payOpt selected as payment option. \nDo you want to continue?"),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog

                      RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text("Yes"),
                        onPressed: () {
                          storage.appendFile(fr_loc +
                              "|" +
                              to_loc +
                              "|" +
                              st_time +
                              "|" +
                              ar_time +
                              "|" +
                              t_duration +
                              "|" +
                              t_date);

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyTicket()),
                          );
                        },
                      ),
                      RaisedButton(
                        textColor: Colors.white,
                        color: Colors.grey,
                        child: Text("No"),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                    ],
                  );
                },
              );

//              Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => MyTicket()),
//              );
            },
            child: const DecoratedBox(
              decoration: const BoxDecoration(color: Colors.yellow),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 50, right: 50, top: 10, bottom: 10),
                child: Text('Pay now (NOK 200)',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
//          RaisedButton(
//            child: Text("Read From File"),
//            onPressed: () {
//              storage.readFileAsString().then((String value) {
//                print(value);
//              });
//            },
//          ),
//          RaisedButton(
//            child: Text("delete"),
//            onPressed: () {
//              storage.deleteFile();
////              storage.readFileAsString().then((String value){
////                print(value);
////              });
//            },
//          ),
        ],
      ),
    ]);
  }
}

class PaymentType extends StatefulWidget {
  @override
  SelectPaymentType createState() => SelectPaymentType();
}

class SelectPaymentType extends State<PaymentType> {
  @override
  void initState() {
    super.initState();
    selectedRadio = 1;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'Choose Payment Option',
            style: new TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Radio(
                value: 1,
                groupValue: selectedRadio,
                activeColor: Colors.green,
                onChanged: (val) {
                  setSelectedRadio(val);
                },
              ),
              new Text(
                'VISA',
                style: new TextStyle(fontSize: 20.0),
              ),
              new Radio(
                value: 2,
                groupValue: selectedRadio,
                activeColor: Colors.green,
                onChanged: (val) {
                  setSelectedRadio(val);
                },
              ),
              new Text(
                'VIPPS',
                style: new TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

fetchTicketDetail(context) {
  storage.readFileAsString().then((String value) {
    var eachTicket = (value.split('\n'));
    print(eachTicket.length.toString() + "@@@@@@@@@@@@@");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyTicket()),
    );
  });
}

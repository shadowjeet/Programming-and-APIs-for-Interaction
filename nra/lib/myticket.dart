import 'dart:io';
import 'package:intl/intl.dart';

import 'splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:nra/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'purchaseticket.dart';

List purchased_ticket_list = List();
int count = 0;

DateTime _dateTime = DateTime.now();

var readFile = AccessTicketFile();
String ticketList, ticketList2;

class MyTicket extends StatefulWidget {
  @override
  MyTicketList createState() => MyTicketList();
}

class MyTicketList extends State<MyTicket> {
  @override
  List initState() {
    // TODO: implement initState
    super.initState();
    readFile.readFileAsString().then((String value) {
      ticketList = value;
      purchased_ticket_list = ticketList.split("\n");

    });
    return purchased_ticket_list;
    //Timer(Duration(seconds: 5), () => MyNavigator.goToIntro(context));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Tickets", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.yellow,
          leading: InkWell(
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SplashScreen()),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, index) {
                  print(purchased_ticket_list.length);

                  return purchased_ticket(index, context);
                },
                itemCount: purchased_ticket_list.length - 1,
              ),
              MyInactiveTicket(),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
    );
  }
}

purchased_ticket(int position, context) {
  var tickets_data = purchased_ticket_list[position];
  var ticket_data = tickets_data.split("|");
  var from = ticket_data[0].toString();
  var to = ticket_data[1].toString();
  var startTime = ticket_data[2].toString();
  var endTime = ticket_data[3].toString();
  var duration = ticket_data[4].toString();
  var date = ticket_data[5].toString();

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
                  child: Text(date,
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
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        from,
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                        size: 25.0,
                      ),
                      Text(
                        to,
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Departure',
                      style: TextStyle(fontSize: 25.0),
                    ),
                    Text(
                      startTime,
                      style: TextStyle(
                          fontSize: 34.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Arrival',
                      style: TextStyle(fontSize: 25.0),
                    ),
                    Text(
                      endTime,
                      style: TextStyle(
                          fontSize: 34.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  "Total Duration: " + duration + " hrs",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
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
          new Divider(
            color: Colors.black,
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Active",
                      style: TextStyle(fontSize: 40.0, color: Colors.green),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Form(
                                  //key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: <Widget>[
                                            Text(

                                    new DateFormat('HH:mm:ss').format(_dateTime).toString(),
                                              style: TextStyle(
                                                  fontSize: 34.0, fontWeight: FontWeight.bold),
                                            ),
                                            QrImage(
                                                data:
                                                "This is info of the ticket of the passanger" + "\n" +
                                                    "From: " + from + "\n" +
                                                    "To: " + to + "\n" +
                                                    "Date: " + date + "\n" +
                                                    "Total dutration : " + duration + "hr" + "\n" +
                                                    "Departure: " + startTime + "\n" +
                                                    "Arrival: " + endTime + "\n"
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: new Column(children: <Widget>[
                        Icon(Icons.fullscreen, size: 40),
                        Text(
                          "Show to control",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ]),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    ),
  );
}

class MyInactiveTicket extends StatelessWidget {
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
                const DecoratedBox(
                  decoration: const BoxDecoration(color: Colors.yellow),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text('Monday, 4 Nov',
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
                    padding: EdgeInsets.only(top:10.0, bottom: 10.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Bergen',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                          size: 25.0,
                        ),
                        Text(
                          ' Dal',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Departure',
                        style: TextStyle(fontSize: 25.0),
                      ),
                      Text(
                        '5:07',
                        style: TextStyle(
                            fontSize: 34.0, fontWeight: FontWeight.bold),
                      ),
                    ],
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
                        '13:07',
                        style: TextStyle(
                            fontSize: 34.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    "Total Duration: 6 hrs",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
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
            new Divider(
              color: Colors.black,
            ),
            Row(
              children: <Widget>[
                Text(
                  "Inactive",
                  style: TextStyle(fontSize: 40.0, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


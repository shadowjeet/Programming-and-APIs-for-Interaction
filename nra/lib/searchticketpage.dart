
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'splashscreen.dart';
import 'purchaseticket.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'schedule.dart';

//Variables of start and destination location
String from_location = '';
String to_location = '';
bool found = false;

//List of stations
final List<String> locations = [
  "Alesund",
  "Bergen",
  "Dal",
  "Fetsund",
  "Frydenlund",
  "Lillestrom",
  "Oslo",
  "Stavenger",
];

//Text edit controller for selecting TypeAheadFormField
TextEditingController controllerFrom = new TextEditingController();
TextEditingController controllerTo = new TextEditingController();

//Current date and time
DateTime _dateTime = DateTime.now();
String picked_date = new DateFormat.yMMMd().format(_dateTime);
String picked_time = new DateFormat('HH:mm').format(_dateTime);
var durationTime = "";

// List of departure and ticket.
List<locInfo> dep_ticket_main_list = List();
List<locInfo> ticket_details = List();

// A. Main class for the ticket search page
class SearchTicketPage extends StatelessWidget {
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //The app bar on the top
      appBar: AppBar(
        title: Text("Search Ticket", style: TextStyle(color: Colors.black)),
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
//            _dateTime = DateTime.now();
            controllerTo.clear();
            controllerFrom.clear();
          },
        ),
      ),

      //Main body of the page
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LocationSearchCard(),
            // input for from and to location
            ToPickDateTime(),
            // Pick data and time for travel
            NoPassengerCard(),

            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, index) {
                String foundString =
                    duration_of_travel(from_location, to_location);
                if (foundString.contains(from_location) &&
                    foundString.contains(to_location)) {
                  return new GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TicketInfo(
                              from: from_location,
                              to: to_location,
                              date: picked_date,
                              duration: durationTime,
                              startTime: ticket_details[index]._time,
                              arrivalTime: ticket_details[index]._arrivalInfo,
                            ), // Needs to be changed
                          ));
                    },
                    child: ticketListItem(index),
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DecoratedBox(
                        decoration: const BoxDecoration(color: Colors.black),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Schedule not found!\nPlease search for another station.',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
              itemCount: dep_ticket_main_list.length,
            ),
          ],
        ),
      ),
    );
  }
}

// A.1 Main class for selecting start and destination location
class LocationSearchCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FromToCard();
  }
}

// A.1.1 Child class for selecting start and destination location
class _FromToCard extends State<LocationSearchCard> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      margin: EdgeInsets.all(10.0),
      elevation: 10.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Column(
                children: <Widget>[
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: controllerFrom,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'From..',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 13.0),
                          )),
                      suggestionsCallback: (pattern) {
                        pattern = pattern[0].toUpperCase() +
                            pattern.substring(1, pattern.length);
                        return locations
                            .where((p) => p.startsWith(pattern))
                            .toList();
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (suggestion) {
                        controllerFrom.text = suggestion;
                        ticket_info_to_list();
                      },
                    ),
                  ),
                  new Divider(
                    color: Colors.black,
                  ),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: controllerTo,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'To..',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 13.0),
                          )),
                      suggestionsCallback: (pattern) {
                        pattern = pattern[0].toUpperCase() +
                            pattern.substring(1, pattern.length);

                        return locations
                            .where((p) => p.startsWith(pattern))
                            .toList();
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (suggestion) {
                        controllerTo.text = suggestion;
                        ticket_info_to_list();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ToPickDateTime extends StatefulWidget {
  @override
  DateAndTimePickerCard createState() => DateAndTimePickerCard();
}

class DateAndTimePickerCard extends State<ToPickDateTime> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      margin: EdgeInsets.all(10.0),
      elevation: 10.0,
      child: Row(
//        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Date: " + picked_date + " " + "Time: " + picked_time + " ",
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FlatButton(
//                  color: Colors.blue,
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.edit),
                      Text("Edit"),
                    ],
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext builder) {
                          return Container(
                            height:
                                MediaQuery.of(context).copyWith().size.height /
                                    2,
                            child: Column(
                              children: <Widget>[
                                Row(children: <Widget>[
                                  Expanded(
                                    child: FlatButton(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.refresh),
                                          Text("Now"),
                                        ],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _dateTime = DateTime.now();
                                          picked_date = new DateFormat.yMMMd()
                                              .format(_dateTime);
                                          picked_time = new DateFormat('HH:mm')
                                              .format(_dateTime);
                                          print(picked_date + picked_time);

                                          ticket_info_to_list();

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SplashScreen()),
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SearchTicketPage()),
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Icon(Icons.done),
                                          Text("Done"),
                                        ],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          ticket_info_to_list();

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SplashScreen()),
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SearchTicketPage()),
                                          );
                                        });
                                      },
                                    ),
                                  ),
                                ]),
                                Expanded(
                                  child: CupertinoDatePicker(
                                    minimumDate: new DateTime(
                                      _dateTime.year,
                                      _dateTime.month,
                                      _dateTime.day,
                                    ),
                                    initialDateTime: _dateTime,
                                    onDateTimeChanged: (DateTime newdate) {
                                      setState(() {
                                        picked_date = new DateFormat.yMMMd()
                                            .format(newdate);
                                        picked_time = new DateFormat('HH:mm')
                                            .format(newdate);
                                        print(picked_date + picked_time);
                                      });
                                    },
                                    mode: CupertinoDatePickerMode.dateAndTime,
                                    use24hFormat: true,
                                    minuteInterval: 1,
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// A.3 Main class to pick number of passenger
class NoPassengerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      margin: EdgeInsets.all(10.0),
      elevation: 10.0,
      child: Row(
//        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Passenger: 1 Adult",
                    style: TextStyle(fontSize: 24.0),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                FlatButton(
//                  color: Colors.blue,
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.edit),
                      Text("Edit"),
                    ],
                  ),
                  onPressed: () {
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
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.remove_circle,
                                          color: Colors.black,
                                          size: 24.0,
                                        ),
                                        Text('  1  ',
                                            style: TextStyle(
                                              fontSize: 24.0,
                                            )),
                                        Icon(
                                          Icons.add_circle,
                                          color: Colors.black,
                                          size: 24.0,
                                        ),
                                        Text('  Adult',
                                            style: TextStyle(
                                              fontSize: 24.0,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.remove_circle,
                                          color: Colors.black,
                                          size: 24.0,
                                        ),
                                        Text('  0  ',
                                            style: TextStyle(
                                              fontSize: 24.0,
                                            )),
                                        Icon(
                                          Icons.add_circle,
                                          color: Colors.black,
                                          size: 24.0,
                                        ),
                                        Text('  Student',
                                            style: TextStyle(
                                              fontSize: 24.0,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.remove_circle,
                                          color: Colors.black,
                                          size: 24.0,
                                        ),
                                        Text('  0  ',
                                            style: TextStyle(
                                              fontSize: 24.0,
                                            )),
                                        Icon(
                                          Icons.add_circle,
                                          color: Colors.black,
                                          size: 24.0,
                                        ),
                                        Text('  Senior',
                                            style: TextStyle(
                                              fontSize: 24.0,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.remove_circle,
                                          color: Colors.black,
                                          size: 24.0,
                                        ),
                                        Text('  0  ',
                                            style: TextStyle(
                                              fontSize: 24.0,
                                            )),
                                        Icon(
                                          Icons.add_circle,
                                          color: Colors.black,
                                          size: 24.0,
                                        ),
                                        Text('  Child',
                                            style: TextStyle(
                                              fontSize: 24.0,
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//A.4 Function to generate list of departure tickets
ticketListItem(int position) {
  locInfo model = dep_ticket_main_list[position];

  return Stack(
    children: <Widget>[
      Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(color: Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 10.0, bottom: 5.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          model._time,
                          style: TextStyle(
                              fontSize: 34.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          model._from,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                  //Spacer(),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: <Widget>[
                        Text(
                          model._durationTime + ' hr',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.chevron_right,
                              color: Colors.black,
                              size: 30.0,
                            ),
                            Icon(
                              Icons.train,
                              color: Colors.black,
                              size: 30.0,
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.black,
                              size: 30.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //Spacer(),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          model._arrivalInfo,
                          style: TextStyle(
                              fontSize: 34.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          model._to,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              new Divider(
                color: Colors.black,
              ),
              Row(
                children: <Widget>[
                  Spacer(),
                  DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.yellow),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(model._price,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

//F.1.A.2 Function to select date and time for the ticket

//F.2.A.3 Function to select number of passenger

//F.3.A.1.1 Function to add ticket info to departure and ticket list
ticket_info_to_list() {
  dep_ticket_main_list.clear();
  from_location = controllerFrom.text.toString();
  to_location = controllerTo.text.toString();
  String duration = duration_of_travel(from_location, to_location);
  String price = "NOK 200";

  if (from_location == '' || to_location == '') {
  } else if (duration.contains("null")) {
    ticket_details = [
      locInfo(from_location, to_location, picked_date, picked_time,
          durationTime, "0", price),
    ];
    dep_ticket_main_list.addAll(ticket_details);
  } else {
    durationTime = duration.split("|")[2];
    var arrival_info = arrival_time(picked_time, durationTime);
    ticket_details = [
      locInfo(from_location, to_location, picked_date, picked_time,
          durationTime, arrival_info, price),
      locInfo(
          from_location,
          to_location,
          picked_date,
          arrival_time(picked_time, "1"),
          durationTime,
          arrival_time(arrival_info, "1"),
          price),
      locInfo(
          from_location,
          to_location,
          picked_date,
          arrival_time(picked_time, "2"),
          durationTime,
          arrival_time(arrival_info, "2"),
          price),
      locInfo(
          from_location,
          to_location,
          picked_date,
          arrival_time(picked_time, "3"),
          durationTime,
          arrival_time(arrival_info, "3"),
          price),
    ];
    dep_ticket_main_list.addAll(ticket_details);
  }
}

arrival_time(picked_time, durationTime) {
  var calulation_time = picked_time.split(":");
  int arrival_cal = int.parse(calulation_time[0]) + int.parse(durationTime);

  if (arrival_cal >= 24) {
    arrival_cal = arrival_cal - 24;
  }
  var arrival_time = arrival_cal.toString() + ":" + calulation_time[1];

  return arrival_time;
}

duration_of_travel(from_loc, to_loc) {
  String scheduleDetail = 'null|null|0';
  schedule.forEach((station) {
    if (station.contains(from_loc) && station.contains(to_loc)) {
      scheduleDetail = station;
    } else {}
  });
  return scheduleDetail;
}

//C.1.A.4 Main getter setter class for ticket list
class locInfo {
  String _from, _to, _date, _time, _durationTime, _arrivalInfo, _price;

  String get from => _from;

  set from(String value) {
    _from = value;
  }

  String get to => _to;

  set to(String value) {
    _to = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  String get time => _time;

  set time(String value) {
    _time = value;
  }

  String get durationTime => _durationTime;

  set durationTime(String value) {
    _durationTime = value;
  }

  String get arrivalInfo => _arrivalInfo;

  set arrivalInfo(String value) {
    _arrivalInfo = value;
  }

  String get price => _price;

  set price(String value) {
    _price = value;
  }

  locInfo(this._from, this._to, this._date, this._time, this._durationTime,
      this._arrivalInfo, this._price);
}

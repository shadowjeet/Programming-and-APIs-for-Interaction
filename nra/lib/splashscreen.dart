import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'myticket.dart';
import 'searchticketpage.dart';

int currentIndex = 0;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Timer(Duration(seconds: 5), () => MyNavigator.goToIntro(context));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.yellow),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Flexible(
                  flex: 5,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.train,
                          size: 200.0,
                        ),
                        Text(
                          'NRA',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0),
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        elevation: 30,
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.yellow,
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.add_shopping_cart, size: 40),
                                Text(
                                  'Purchase Ticket',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchTicketPage()),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: Colors.yellow,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              title: Text('My Tickets'),
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                  onTap: () {
                    _onBackPressed();
                  },
                  child: Icon(Icons.close)),
              title: Text('Close'),
            )
          ],
          onTap: (index) {
            setState(() {
              currentIndex = index;
              if (currentIndex == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyTicket()),
                );
              } else if (currentIndex == 1) {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => LocationInformation()),
//                );
              }
            });
          },
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you really want to exit the app?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("<No>", style: TextStyle(color: Colors.black,fontSize: 20),),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text("<Yes>", style: TextStyle(color: Colors.black,fontSize: 20),),
                  onPressed: () => SystemNavigator.pop(),
                ),
              ],
            ));
  }
}

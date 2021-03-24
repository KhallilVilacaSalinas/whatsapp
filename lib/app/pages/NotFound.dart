import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotFound extends StatefulWidget {
  @override
  _NotFoundState createState() => _NotFoundState();
}

class _NotFoundState extends State<NotFound> {

  @override
  void initState() {
    super.initState(); 
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
 ));
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              width: 484.0,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment(0.53, -8.0),
                    child: Container(
                      width: 90.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(1000),
                              bottomRight: Radius.circular(1000),
                            ),
                        color: const Color(0xFFFF0000).withOpacity(0.76),
                       
                      ),
                    ),
                  ),
                  Spacer(flex: 70),                  
                  Align(
                    alignment: Alignment(-0.5, 0.0),
                    child: Container(
                      width: 27.0,
                      height: 27.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFF0000).withOpacity(0.62),
                        
                      ),
                    ),
                  ),
                  
                  Align(
                    alignment: Alignment(-2.9,-1.44),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/notfound.png',
                          width: MediaQuery.of(context).size.width * 0.99,
                          
                        )
                      ],
                    ),
                  ),
                  
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 150.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Spacer(flex: 113),
                        Align(                       
                          alignment: Alignment(2.0, 0.44),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 44.0,
                            child: Text(
                              'Not found',
                              style: TextStyle(
                                fontFamily: 'MeriendaBold',
                                fontSize: 37.0,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Spacer(flex: 30),
                        Container(
                          width: 70.0,
                          height: 137.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(1000),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(1000),
                              bottomRight: Radius.circular(0),
                            ),
                            color: const Color(0xFFFF0000).withOpacity(0.84),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(flex: 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 200.0,
                      height: 200.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(1000),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(0),
                        ),
                        color: const Color(0xFFFF0000).withOpacity(0.84),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

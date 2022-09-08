import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'tab_options.dart';

import 'add.dart';
import 'feed.dart';
import 'feed2.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  int nn = 2;
  late PageController pageController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = true;
  var durationInDay = 0;
  var durationForMinutes = 0;
  var durationForHours = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    _getStartTime();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // body: ,
      body: AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        child: isLoading ?
        const Center(
          child: CircularProgressIndicator(),
        )
        :
        PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChanged,
          children: [
            Feed(durationInDay: durationInDay),
            Feed2(durationForMinutes: durationForMinutes,durationForHours: durationForHours),
            AddPost(durationInDay: durationInDay)
          ],
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
          inactiveColor: Colors.grey,
          activeColor: Colors.black,
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                  padding: const EdgeInsets.only(top: 3.0, right: 0),
                  // child: Icon(MyFlutterApp.home, size: 23.5),
                  child: Icon(
                    Icons.message,
                  )),
              label: 'Posts',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                  padding: const EdgeInsets.only(top: 3.0, right: 0),
                  // child: Icon(MyFlutterApp.home, size: 23.5),
                  child: Icon(
                    Icons.message,
                  )),
              label: 'Posts 2',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: Icon(
                  Icons.add_circle,
                ),
              ),
              label: 'Add',
            ),
          ],
          currentIndex: _page,
          onTap: navigationTapped),
    );
  }

  _getStartTime() {

    firestore.collection('startTime').get()
        .then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((doc)  {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        var timeStr = doc["time"];
        var dateTime = DateFormat('dd/MM/yy').parse(timeStr);
       // var dateTime = DateFormat('dd/MM/yy').parse('06/09/2018');
        var dateNow = DateTime.now();
        var duration = dateNow.difference(dateTime);
        var _dd = duration.inDays;
        durationInDay = _dd;
        if(_dd < 60){
          setState(() {
            durationForMinutes = _dd;
            isLoading = false;
          });
        }
        else{
          var _fd = _dd % 60; // for getting time
          var _hd = _dd / 60;  // getting how much minute cycle done
          var _hhd = _hd.toInt();
           // print('startTime $_dd');
           // print('startTime $_fd');
           // print('घंटेटेक्स्टस्ट्रिंग $_hhd');

          // check hours cycle getter 24
          if(_hhd < 24) {
           // print('घंटेटेक्स्टस्ट्रिंग if $_hhd');

            setState(() {
              durationForMinutes = _fd;
              durationForHours = _hhd;
              isLoading = false;
            });
          }
          else {
            var _hhhd = _hhd % 24; // getting how much hours cycle done
           // print('घंटेटेक्स्टस्ट्रिंग else $_hhhd');

            setState(() {
              durationForMinutes = _fd;
              durationForHours = _hhhd;
              isLoading = false;
            });
          }
        }

       // print('duration.inDays ${duration.inDays}');

      });
    });
  }
}

import 'package:flutter/material.dart';

class ImageSwipe extends StatefulWidget {
  final List imageList;
  ImageSwipe({this.imageList});

  @override
  _ImageSwipeState createState() => _ImageSwipeState();
}

class _ImageSwipeState extends State<ImageSwipe> {
  int _selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Stack(
        children: <Widget>[
          PageView(
            onPageChanged: (num) {
              setState(() {
                _selectedPage = num;
              });
            },
            children: <Widget>[
              for (var i = 0; i < widget.imageList.length; i++)
                Container(
                  child: Image.network(
                    '${widget.imageList[i]}',
                    fit: BoxFit.cover,
                  ),
                )
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (var i = 0; i < widget.imageList.length; i++)
                  AnimatedContainer(
                    duration: Duration(
                      milliseconds: 300
                    ),
                    curve: Curves.easeInCubic,
                    margin: EdgeInsets.symmetric(horizontal: 6.0),
                    width: _selectedPage == i ? 30 : 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12)
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}

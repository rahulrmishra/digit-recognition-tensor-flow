import 'package:digit_recognizer_ml/screens/drawing_painter.dart';
import 'package:digit_recognizer_ml/services/recognizer.dart';
import 'package:digit_recognizer_ml/utils/constants.dart';
import 'package:flutter/material.dart';

class DrawScreen extends StatefulWidget {
  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final _points = List<Offset>();
  final _recognizer = Recognizer();

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Digit Recognizer'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "MNIST database of handwrittern digits",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Digits have been size normalized and centered in fixed size images (28 x 28)",
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(
            decoration: BoxDecoration(
              border:
                  Border.all(color: Colors.black, width: Constants.borderSize),
            ),
            width: Constants.canvasSize + Constants.borderSize * 2,
            height: Constants.canvasSize + Constants.borderSize * 2,
            child: GestureDetector(
              onPanUpdate: (DragUpdateDetails details) {
                Offset _localPosition = details.localPosition;
                if (_localPosition.dx >= 0 &&
                    _localPosition.dx <= Constants.canvasSize &&
                    _localPosition.dy >= 0 &&
                    _localPosition.dy <= Constants.canvasSize) {
                  setState(() {
                    _points.add(_localPosition);
                  });
                }
              },
              onPanEnd: (DragEndDetails details) {
                _points.add(null);
                _recognize();
              },
              child: CustomPaint(
                painter: DrawingPainter(points: _points),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _points.clear();
          });
        },
        child: Icon(Icons.clear),
      ),
    );
  }

  void _initModel() async {
    var res = await _recognizer.loadModel();
    print(res);
  }

  void _recognize() async {
    List<dynamic> pred = await _recognizer.recognize(_points);
    print(pred);
  }
}

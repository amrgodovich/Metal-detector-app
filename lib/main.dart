import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

Color primaryColor = Color.fromARGB(255, 33, 65, 123);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magnetometer',
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: const MyHomePage(
        title: 'Magnetometer',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<double>? _magnetometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  late double xx, yy, zz;
  late double xxx;
  late double yyy;
  late double zzz;
  late double? mag;
  late double sum;

  String? textshown;

  double RangeValue = 60.0;
  late String screenvalue = 'll';

  void playmusic(String musicnum) {
    final player = AudioPlayer();
    player.play(AssetSource('$musicnum'));
  }

  Widget _getGauge() {
    return _getRadialGauge();
  }

  @override
  Widget build(BuildContext context) {
    final magnetometer =
        _magnetometerValues?.map((double v) => v.toStringAsFixed(1)).toList();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 18, 90, 135),
        appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/magnet.png',
                  fit: BoxFit.contain,
                  height: 32,
                ),
                Text('Metal Detector'),
              ],
            ),
            backgroundColor: primaryColor),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              _getGauge(),
              Text('Magnetometer: $magnetometer',
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text('$textshown',
                    style: TextStyle(
                        wordSpacing: 4,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor)),
              ),
            ],
          ),
        ));
  }

  Widget _getRadialGauge() {
    return SfRadialGauge(
        title: GaugeTitle(
            text: 'Percentage',
            textStyle: const TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        axes: <RadialAxis>[
          RadialAxis(minimum: 0, maximum: 100, ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: 33,
                color: Colors.red,
                startWidth: 10,
                endWidth: 10),
            GaugeRange(
                startValue: 33,
                endValue: 66,
                color: Colors.orange,
                startWidth: 10,
                endWidth: 10),
            GaugeRange(
                startValue: 66,
                endValue: 100,
                color: Colors.green,
                startWidth: 10,
                endWidth: 10)
          ], pointers: <GaugePointer>[
            NeedlePointer(value: RangeValue)
          ], annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: Container(
                    child: Text('$screenvalue %',
                        style: TextStyle(
                            fontSize: 25,
                            color: primaryColor,
                            fontWeight: FontWeight.bold))),
                angle: 90,
                positionFactor: 0.5)
          ])
        ]);
  }

  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      magnetometerEvents.listen(
        (MagnetometerEvent event) {
          setState(() {
            _magnetometerValues = <double>[event.x, event.y, event.z];

            xx = event.x;
            yy = event.y;
            zz = event.z;

            final xxx = pow(xx, 2);
            final yyy = pow(yy, 2);
            final zzz = pow(zz, 2);

            final sum = xxx + yyy + zzz;

            final mag = pow(sum, 1 / 2);

            if (mag > 45) {
              textshown = "METAL DETECTED";
              print('$textshown');
              primaryColor = Colors.green;
              RangeValue = ((100 - 66) * (mag - 45) / (100 - 45)) + 66;
              if (RangeValue >= 100) {
                RangeValue = 100;
                playmusic('sound1.mp3');
              }
            } else if (mag < 45 && mag > 40) {
              textshown = "MOVE CLOSER";
              print('$textshown');
              primaryColor = Colors.orange;
              RangeValue = ((66 - 33) * (mag - 40) / (45 - 40)) + 33;
            } else {
              textshown = 'NO SUCH METAL';
              print('$textshown');
              primaryColor = Colors.red;
              RangeValue = ((33 - 1) * (mag - 1) / (40 - 1)) + 1;
            }
            screenvalue = RangeValue.toStringAsFixed(1);
            if (RangeValue >= 100) {
              screenvalue = '100.0';
            }

            print('mag=$mag');
            print('RangeValue=$RangeValue');
            print('---------------');
          });
        },
      ),
    );
  }
}

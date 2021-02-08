import 'package:flutter/material.dart';
import 'package:climnate_app/consatantsFile.dart';
import '../utils/apiFile.dart' as util;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Climate extends StatefulWidget {
  @override
  _ClimateState createState() => _ClimateState();
}

class _ClimateState extends State<Climate> {

  void showStuff() async{

    Map data = await getWeather(util.apiID, util.defaultCity);
    print(data.toString());
  }

  String _cityEntered;

  Future _goToNextScreen(BuildContext buildContext) async{

    Map result = await Navigator.of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context)
    {
      return new ChangeCity();
    }));
    
    if(result != null && result.containsKey('enter'))
      {
        _cityEntered = result['enter'];
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Climate App'),
        backgroundColor: Colors.red,
        actions: [IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _goToNextScreen(context);
            })],
      ),
      body: Stack(
        children: [
          Center(
            child: Image(
              image: AssetImage('images/umbrella.png'),
              height: 1200.0,
              width: 500.0,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: Text('${_cityEntered == null ? util.defaultCity : _cityEntered}',
              style: kCityStyle,
            ),
          ),
          Center (
            child: Image(
              image: AssetImage('images/light_rain.png'),
              height: 80.0,
              width: 80.0,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30.0, 300.0, 0.0, 0.0),
            child: updateTempWidget('${_cityEntered == null ? util.defaultCity : _cityEntered}'),
          )
        ],),
    );
  }

  Future<Map> getWeather(String appId, String city) async{

    String apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=$city"
        "&appid=${util.apiID}&units=metric";

    http.Response response = await http.get(apiUrl);

    return json.decode(response.body);
  }

  Widget updateTempWidget(String city){

    print('getWeather called....');
    return FutureBuilder(future: getWeather(util.apiID, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapShot){

          if(snapShot.hasData)
          {
            print('Data called....');
            Map content = snapShot.data;

            return Container(
              margin: EdgeInsets.fromLTRB(20.0, 200.0, 0.0, 0.0),
              child: Column(
                children: [new ListTile(
                  title: Text(
                  content['main']['temp'].toString() + ' F',
                  style: kTempStyle,
                ),
                  subtitle: new ListTile(title: Text(
                    'Humidity: ${content['main']['humidity'].toString()}\n'
                    'Min: ${content['main']['temp_min'].toString()} F\n'
                    'Max: ${content['main']['temp_max'].toString()} F ',
                    style: kNewTextStyle,
                  ),)
                )
                ],
              ),
            );
          }
          else
          {
            return Container();
          }
        });
  }
}

class ChangeCity extends StatelessWidget {

  var _cityFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change City'),
        backgroundColor: Colors.red,
        centerTitle: true,),
      body: Stack(children: [
        Center(
          child: Image.asset('images/white_snow.png',
            width: 590.0,
            height: 1200.0,
            fit: BoxFit.fill,),
        ),
        ListView(
          children: [
            ListTile(
              title: TextField(
                decoration: InputDecoration(hintText: 'Enter City'),
                controller: _cityFieldController,
                keyboardType: TextInputType.text,
              )
            ),
            ListTile(
                title: FlatButton(
                  onPressed: () {
                    Navigator.pop(context, {'enter': _cityFieldController.text});
                  },
                  textColor: Colors.white,
                  color: Colors.redAccent,
                  child: Text('Get Weather',),
                )
            )
          ],
        )
      ],)
    );
  }
}


import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map _data;
List _features;

void main() async {

  _data = await getQuakes();
 _features = _data['features'];

  print(_features.toString());

  runApp(new MaterialApp(
    title: 'quakes',
    home: new Quakes(),
  ));

}

class Quakes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: new AppBar(
        title: new Text('Quakes'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      
      body: new Center(
        child: new ListView.builder(
          itemCount: _features.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (BuildContext context, int position){
            //rows of the list
            if(position.isOdd) return new Divider();
            final index = position ~/2;

            var format = DateFormat.yMMMMd("en_US").add_jm();
            var date = format.format(new DateTime.fromMicrosecondsSinceEpoch(_features[index]['properties']['time']*1000, isUtc: true));

            return new ListTile(
              title: new Text("$date",
                style: new TextStyle(fontSize: 19.5, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic, color: Colors.orange)),

              subtitle: new Text("${_features[index]['properties']['place']}", 
                style: new TextStyle(fontSize: 14.5, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic)),

                leading: new CircleAvatar(

                  backgroundColor: Colors.green,

                  child: new Text("${_features[index]['properties']['mag']}", 
                    style: new TextStyle(fontSize: 14.5, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.white),),
                    
                ),

                onTap: () {_showAlertMessage(context, "${_features[index]['properties']['title']}");},
            );

          },
        ),
      ),
      
    );
  }
}

Future<Map> getQuakes() async{
  String apiURL = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';

  http.Response response = await http.get(apiURL);

  return JSON.decode(response.body);

}

void _showAlertMessage(BuildContext context, String message){
  var alert = new AlertDialog(
    title: new Text('Quakes'),
    content: new Text(message),
    actions: <Widget>[
      new FlatButton(onPressed: (){Navigator.pop(context);},
        child: new Text("ok"),)
    ],
  );
  showDialog(context: context,children: <Widget>[alert]);

}

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:travel/sign-in.dart';


void main() {
  runApp(MaterialApp(
      home: TabLayout(),
    ));
}
Color getColorFromHex(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll('#', '');

  if (hexColor.length == 6) {
    hexColor = 'FF' + hexColor;
  }

  return Color(int.parse(hexColor, radix: 16));
}
class TabLayout extends StatefulWidget {
  const TabLayout({Key key}) : super(key: key);
  @override
  _StateHome createState() => new _StateHome();
}
enum SingingCharacter { economy, business }

class _StateHome extends State<TabLayout> with SingleTickerProviderStateMixin {

  TabController _tabController;
  SingingCharacter _character = SingingCharacter.economy;
  String _selectedCityFrom;
  String _selectedCityTo;
  String _selectedHotel;
  String _selectedPointFrom;
  String _selectedPointTo;
  String _selectedCity;
  String _selectedCruise;
  String _selectedLocationAd; // Option 2
  String _selectedLocationDuration; // Option 2
  String _selectedLocationCh; // Option 2
  String _selectedLocationChAges; // Option 2
  var _selectedLocationChAgeCount;
  String valueDate;
  String valueDateHotel;
  String valueDateTransfer;
  String valueDateEx;
  String valueDateCruise;
  String valueDateAge1;
  String valueDateAge2;
  String valueDateAge3;
  String valueDateAge4;

  List<String> _locationsAd = ['1','2','3','4','5'];
  List<String> _locationsCh = ['0','1','2','3','4'];
  List<String> _locationsChAges = ['0','1','2','3','4','5','6','7','8'
  ,'9','10'];
  List<String> _durations = ['1','2','3','4','5','6','7','8','9','10'];

  final _selectedDay = DateTime.now();
  final TextEditingController _typeAheadControllerFrom =
  TextEditingController();
  final TextEditingController _typeAheadControllerTo =
  TextEditingController();
  final TextEditingController _typeAheadControllerHotel =
  TextEditingController();
  final TextEditingController _typeAheadControllerPointFrom =
  TextEditingController();
  final TextEditingController _typeAheadControllerPointTo =
  TextEditingController();
  final TextEditingController _typeAheadControllerEx =
  TextEditingController();
  final TextEditingController _typeAheadControllerCru =
  TextEditingController();


  DateTime _valueFlight;
  DateTime _valueHotel;
  DateTime _valueTransfer;
  DateTime _valueEx;
  DateTime _valueCruise;
  DateTime _valueAge1;
  DateTime _valueAge2;
  DateTime _valueAge3;
  DateTime _valueAge4;
  var vAgeOut;

  List<String> cities = [];

  Future _selectDateByColumn(String s, index) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1900),
      lastDate: new DateTime.now(),
    );
    if(picked != null) {
//      print(picked);
      if(s=="flight")
        setState(() => _valueFlight = picked);
      if(s=="hotel")
        setState(() => _valueHotel = picked);
      if(s=="transfer")
        setState(() => _valueTransfer = picked);
      if(s=="ex")
        setState(() => _valueEx = picked);
      if(s=="cruise")
        setState(() => _valueCruise = picked);
      if(s=="age"){
        ageState(index,picked);
      }
    }
  }

  Future _selectDate(String s) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime.now(),
      lastDate: new DateTime(2025),
    );
    if(picked != null) {
//      print(picked);
      if(s=="flight")
        setState(() => _valueFlight = picked);
      if(s=="hotel")
        setState(() => _valueHotel = picked);
      if(s=="transfer")
        setState(() => _valueTransfer = picked);
      if(s=="ex")
        setState(() => _valueEx = picked);
      if(s=="cruise")
        setState(() => _valueCruise = picked);
      if(s=="age"){
        print(vAgeOut);
        setState(() => _valueAge1 = picked);
        setState(() => _valueAge2 = picked);
        setState(() => _valueAge3 = picked);
        setState(() => _valueAge4 = picked);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 0, length: 6);
  }

  @override
  Container titleOut (name){
    return new Container(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      decoration: new BoxDecoration(color: getColorFromHex
        ("#ffffff")),
      child: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  void ageState(index,picked){
    switch(index) {
      case 0:
        setState(() => _valueAge1 = picked);
        break;
      case 1:
        print(picked);
        setState(() => _valueAge2 = picked);
        break;
      case 2:
        setState(() => _valueAge3 = picked);
        break;
      case 3:
        setState(() => _valueAge4 = picked);
        break;
      default:
        break;
    }
  }

  ageOut(index){
    String s = "";
    switch(index) {
      case 1:
        s=valueDateAge1;
        break;
      case 2:
        s=valueDateAge2;
        break;
      case 3:
        s=valueDateAge3;
        break;
      case 4:
        s=valueDateAge4;
        break;
      default:
        s=valueDateAge1;
        break;
    }
    return s;
  }

  chCount(_selectedLocationChAgeCount,_selectedLocationChAges,_locationsChAges) {
    if(_selectedLocationChAgeCount==0) return new Text('');
    else
      return new Container(
        padding: EdgeInsets.all(0.0),
        height: 70,
        child: GridView.count(
          shrinkWrap: true,
          padding: EdgeInsets.all(0.0),
//          shrinkWrap: true,
          crossAxisCount: _selectedLocationChAgeCount,
          children: List.generate
            (_selectedLocationChAgeCount,
                  (index) {
              vAgeOut = ageOut((index+1));
              return new Column(
                children: <Widget>[
                  Text("child "+(index+1).toString()),
                  RaisedButton(
                    onPressed: () {
                      _selectDateByColumn("age",index);
                    },
                    child: Text(vAgeOut,
                      style:
                    TextStyle
                      (fontSize: 9.0),),
                  ),
                ],
              );
            }),
        ),
      );
  }

  Future<List<String>> _fetchData(String query, String action) async {
    List<String> matches = List();
    List<String> cities = List();
    if (query.length > 0) {
      final response = await http.get("http://tr.telenet.ru:81/skycatch"
          ".php?action="+action+"&query=" + query);
      print(response.body);
      if (response.statusCode == 200) {
        var d = json.decode(response.body)["result1"];
        if (d.length > 0) {
          for (var i = 0; i < d.length; i++) {
            cities.add(d[i]["name"]);
          }
          matches.addAll(cities);
          matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
        }
      }
    }
    return matches;
  }
  _chData(){
    return;
  }
  _loadFlightRequest(String From, String To){
    String message = "";
    String reqCityFrom = "";
    if(null==From){
      message="No From! ";
    } else {
      reqCityFrom = From;
    }
    if(null==To){
      message="No To! ";
    }
    return new Container(
      height:200,
      child: ListView(
        padding: EdgeInsets.all(0.0),
        children: [
          Text(
            "From: "+From.toString(),
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          Text("To: "+To.toString(),
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          SizedBox(height: 10.0,),
          Text("Flight Date: "+valueDate,
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          SizedBox(height: 10.0,),
          Text("Adults: "+_selectedLocationAd.toString(),
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          Text("Children: "+_selectedLocationCh.toString(),
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          Text("Child 1 birthdate: "+valueDateAge1,
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          Text("Child 2 birthdate: "+valueDateAge2,
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          Text("Child 3 birthdate: "+valueDateAge3,
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          Text("Child 4 birthdate: "+valueDateAge4,
            style: TextStyle(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
  _loadHotelRequest(String Item){
    String message = "";
    String reqHotel = "";
    if(null==Item){
      message="No Name! ";
    } else {
      reqHotel = Item;
    }
    return new Container(
      height:200,
      child: ListView(
        padding: EdgeInsets.all(0.0),
        children: [
          Text(
            "Location: "+Item.toString(),
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          SizedBox(height: 10.0,),
          Text("Check In Date: "+valueDate,
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          SizedBox(height: 10.0,),
          Text("Adults: "+_selectedLocationAd.toString(),
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          Text("Children: "+_selectedLocationCh.toString(),
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          Text("Child 1 birthdate: "+valueDateAge1,
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          Text("Child 2 birthdate: "+valueDateAge2,
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          Text("Child 3 birthdate: "+valueDateAge3,
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          Text("Child 4 birthdate: "+valueDateAge4,
            style: TextStyle(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if(_valueFlight==null) valueDate = DateFormat('MM/dd/yyyy').format(new
    DateTime.now());
    else valueDate = DateFormat('MM/dd/yyyy').format(_valueFlight);

    if(_valueHotel==null) valueDateHotel = DateFormat('MM/dd/yyyy').format(new
    DateTime.now());
    else valueDateHotel = DateFormat('MM/dd/yyyy').format(_valueHotel);

    if(_valueTransfer==null) valueDateTransfer = DateFormat('MM/dd/yyyy').format
      (new
    DateTime.now());
    else valueDateTransfer = DateFormat('MM/dd/yyyy').format(_valueTransfer);

    if(_valueEx==null) valueDateEx = DateFormat('MM/dd/yyyy').format
      (new
    DateTime.now());
    else valueDateEx = DateFormat('MM/dd/yyyy').format(_valueEx);

    if(_valueCruise==null) valueDateCruise = DateFormat('MM/dd/yyyy').format
      (new
    DateTime.now());

    if(_valueAge1==null) valueDateAge1 = DateFormat('MM/dd/yyyy').format
      (new
    DateTime.now());
    else valueDateAge1 = DateFormat('MM/dd/yyyy').format(_valueAge1);

    if(_valueAge2==null) valueDateAge2 = DateFormat('MM/dd/yyyy').format
      (new
    DateTime.now());
    else valueDateAge2 = DateFormat('MM/dd/yyyy').format(_valueAge2);

    if(_valueAge3==null) valueDateAge3 = DateFormat('MM/dd/yyyy').format
      (new
    DateTime.now());
    else valueDateAge3 = DateFormat('MM/dd/yyyy').format(_valueAge3);

    if(_valueAge4==null) valueDateAge4 = DateFormat('MM/dd/yyyy').format
      (new
    DateTime.now());
    else valueDateAge4 = DateFormat('MM/dd/yyyy').format(_valueAge4);

    if(null==_selectedLocationAd) _selectedLocationAd="1";
    if(null==_selectedLocationCh) _selectedLocationCh="0";
    if(null==_selectedLocationChAges) _selectedLocationChAges="0";
    if(null==_selectedLocationChAgeCount) _selectedLocationChAgeCount=0;

    return new MaterialApp(
      title: 'Map',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      color: Colors.yellow,
      home: DefaultTabController(
        length: 6,
        child: new Scaffold(
          appBar: AppBar(
            title: Text('Search'),
            backgroundColor: getColorFromHex("#d14d5e"),
          ),
          body: TabBarView(
            dragStartBehavior: DragStartBehavior.down,
            controller: _tabController,
            children: [
              new Container(
                decoration: new BoxDecoration(color: getColorFromHex
                  ("#fdb998")),
                padding: EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 0.0),
                child: Form(
                  key: new GlobalKey<FormState>(),
                  child: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: new ListView(
                      children: <Widget>[
                        titleOut('Direction'),
//                        SizedBox(height: 10.0,),
                        TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                            scrollPadding: EdgeInsets.all(0.0),
                              controller: _typeAheadControllerFrom,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                ),
                                contentPadding: EdgeInsets.fromLTRB(10.0, 5.0,
                                    10.0, 0.0),
                                labelText: 'From',
                              )
                          ),
                          suggestionsCallback: (pattern) {
                            if(pattern!=''){
                              return _fetchData(pattern,"airports");
                            } else return null;
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion),
                              contentPadding: EdgeInsets.fromLTRB(10.0, 0.0,
                                  10.0, 0.0),
                            );
                          },
                          transitionBuilder: (context, suggestionsBox, controller) {
                            return suggestionsBox;
                          },
                          onSuggestionSelected: (suggestion) {
                            _typeAheadControllerFrom.text = suggestion;
                            setState(() {
                              _selectedCityFrom = suggestion;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please select a departure';
                            } else return null;
                          },
                          onSaved: (value) => _selectedCityFrom = value,
                        ),
//                        SizedBox(height: 10.0,),
                        TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: _typeAheadControllerTo,
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 5.0,
                                      10.0, 0.0),
                                  labelText: 'To'
                              )
                          ),
                          suggestionsCallback: (pattern) {
                            if(pattern!=''){
                              return _fetchData(pattern,"airports");
                            } else return null;
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion),
                              contentPadding: EdgeInsets.fromLTRB(10.0, 0.0,
                                  10.0, 0.0),
                            );
                          },
                          transitionBuilder: (context, suggestionsBox, controller) {
                            return suggestionsBox;
                          },
                          onSuggestionSelected: (suggestion) {
                            _typeAheadControllerTo.text = suggestion;
                            setState(() {
                              _selectedCityTo = suggestion;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please select a arrival';
                            } else return null;
                          },
                          onSaved: (value) => _selectedCityTo = value,
                        ),
//                        SizedBox(height: 10.0,),
                        titleOut('Class'),
                        Container(
                          padding: EdgeInsets.all(0.0),
                          height: 50,
                          child: GridView.count(
                            padding: EdgeInsets.all(0.0),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: List.generate(2, (index) {
                              List<String> classes = ['Economy','Business'];
                              List<SingingCharacter> values = [SingingCharacter
                                  .economy,SingingCharacter.business];
                              return ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.all(0.0),
                                title: Text(classes[index]),
                                leading: Radio(
                                  activeColor: Colors.white,
                                  materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                                  value: values[index],
                                  groupValue: _character,
                                  onChanged: (SingingCharacter value) {
                                    setState(() {
                                      _character = value;
                                    });
                                  },
                                ),
                              );
                            }),
                          ),
                        ),
//                        SizedBox(height: 10.0,),
                        titleOut('Adults/Children'),
                        Container(
                          padding: EdgeInsets.all(0.0),
                          height: 45,
                          child: GridView.count(
                            padding: EdgeInsets.all(0.0),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: List.generate(2, (index) {
                              List<String> values = [_selectedLocationAd,
                                _selectedLocationCh];
                              List<List<String>> lists = [_locationsAd,
                                _locationsCh];
                              return Container(
                                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0,
                                    0.0),
                                child: DropdownButton(
//                          hint: Text('1'), // Not necessary for Option 1
                                  value: values[index],
                                  onChanged: (newValue) {
                                    setState(() {
//                                      print(lists[index]);
                                      if(index==0){
                                        _selectedLocationAd = newValue;
                                      } else {
                                        _selectedLocationChAgeCount=int.parse
                                          (newValue);
                                        _selectedLocationCh = newValue;
                                      }
                                    });
                                  },
                                  items: lists[index].map((location) {
                                    return DropdownMenuItem(
                                      child: new Text(location),
                                      value: location,
                                    );
                                  }).toList(),
                                ),
                              );
                            }),
                          ),
                        ),
                        new Visibility(
                          visible: true,
                          child: chCount(_selectedLocationChAgeCount,_selectedLocationChAges,_locationsChAges),
                        ),
                        titleOut('Date'),
                        RaisedButton(
                          onPressed: () {
                            _selectDate("flight");
                          },
                          child: new Text(valueDate),
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
//                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: getColorFromHex("#d14d5e"),
                            child: Text('Search'),
                            onPressed: () {
                              _loadFlightRequest(_selectedCityFrom,
                                  _selectedCityTo);
//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(builder: (context) =>
//                                      TabLayout())
//                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              new Container(
                decoration: new BoxDecoration(color: getColorFromHex
                  ("#fdb998")),
                padding: EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 0.0),
                child: Form(
                  key: new GlobalKey<FormState>(),
                  child: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: new ListView(
                      children: <Widget>[
                        titleOut('Destination'),
                        TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: _typeAheadControllerHotel,
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 5.0,
                                      10.0, 0.0),
                                  labelText: 'Country/City/Area/Hotel'
                              )
                          ),
                          suggestionsCallback: (pattern) {
                            if(pattern!=''){
                              return _fetchData(pattern,"hotels");
                            } else return null;
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion),
                              contentPadding: EdgeInsets.fromLTRB(10.0, 0.0,
                                  10.0, 0.0),

                            );
                          },
                          transitionBuilder: (context, suggestionsBox, controller) {
                            return suggestionsBox;
                          },
                          onSuggestionSelected: (suggestion) {
                            _typeAheadControllerHotel.text = suggestion;
                            setState(() {
                              _selectedHotel = suggestion;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please select a departure';
                            } else return null;
                          },
                          onSaved: (value) => _selectedHotel = value,
                        ),
//                        SizedBox(height: 20.0,),
                        titleOut('Duration (nights)'),
                        Container(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0,
                              0.0),
                          child: DropdownButton(
                            hint: Text('1'), // Not necessary for
                            // Option 1
                            value: _selectedLocationDuration,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedLocationDuration = newValue;
                              });
                            },
                            items: _durations.map((location) {
                              return DropdownMenuItem(
                                child: new Text(location),
                                value: location,
                              );
                            }).toList(),
                          ),
                        ),
//                        SizedBox(height: 20.0,),
                        titleOut('Adults/Children'),
                        Container(
                          padding: EdgeInsets.all(0.0),
                          height: 45,
                          child: GridView.count(
                            padding: EdgeInsets.all(0.0),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: List.generate(2, (index) {
                              List<String> values = [_selectedLocationAd,
                                _selectedLocationCh];
                              List<List<String>> lists = [_locationsAd,
                                _locationsCh];
                              return Container(
                                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0,
                                    0.0),
                                child: DropdownButton(
//                          hint: Text('1'), // Not necessary for Option 1
                                  value: values[index],
                                  onChanged: (newValue) {
                                    setState(() {
//                                      print(lists[index]);
                                      if(index==0){
                                        _selectedLocationAd = newValue;
                                      } else {
                                        _selectedLocationChAgeCount=int.parse
                                          (newValue);
                                        _selectedLocationCh = newValue;
                                      }
                                    });
                                  },
                                  items: lists[index].map((location) {
                                    return DropdownMenuItem(
                                      child: new Text(location),
                                      value: location,
                                    );
                                  }).toList(),
                                ),
                              );
                            }),
                          ),
                        ),
                        new Visibility(
                          visible: true,
                          child: chCount(_selectedLocationChAgeCount,_selectedLocationChAges,_locationsChAges),
                        ),
                        titleOut('Check In'),
                        RaisedButton(
                          onPressed: () {
                            _selectDate("hotel");
                          },
                          child: new Text(valueDateHotel),
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
//                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: getColorFromHex("#d14d5e"),
                            child: Text('Search'),
                            onPressed: () {
//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(builder: (context) =>
//                                      TabLayout())
//                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              new Container(
//                color: Colors.lightGreen,
//                child: mMap,
                decoration: new BoxDecoration(color: getColorFromHex
                  ("#fdb998")),
                padding: EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 0.0),
                  child: Form(
                    key: new GlobalKey<FormState>(),
                    child: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: new ListView(
                        children: <Widget>[
                          titleOut('Transfer'),
                          TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                                controller: _typeAheadControllerPointFrom,
                                decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(10.0, 5.0,
                                        10.0, 0.0),
                                    labelText: 'From'
                                )
                            ),
                            suggestionsCallback: (pattern) {
                              if(pattern!=''){
                                return _fetchData(pattern,"transfers");
                              } else return null;
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                                contentPadding: EdgeInsets.fromLTRB(10.0, 0.0,
                                    10.0, 0.0),
                              );
                            },
                            transitionBuilder: (context, suggestionsBox, controller) {
                              return suggestionsBox;
                            },
                            onSuggestionSelected: (suggestion) {
                              _typeAheadControllerPointFrom.text = suggestion;
                              setState(() {
                                _selectedPointFrom = suggestion;
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please select a departure';
                              } else return null;
                            },
                            onSaved: (value) => _selectedPointFrom = value,
                          ),
//                          SizedBox(height: 10.0,),
                          TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                                controller: _typeAheadControllerPointTo,
                                decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(10.0, 5.0,
                                        10.0, 0.0),
                                    labelText: 'To'
                                )
                            ),
                            suggestionsCallback: (pattern) {
                              if(pattern!=''){
                                return _fetchData(pattern,"transfers");
                              } else return null;
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                                contentPadding: EdgeInsets.fromLTRB(10.0, 0.0,
                                    10.0, 0.0),
                              );
                            },
                            transitionBuilder: (context, suggestionsBox, controller) {
                              return suggestionsBox;
                            },
                            onSuggestionSelected: (suggestion) {
                              _typeAheadControllerPointTo.text = suggestion;
                              setState(() {
                                _selectedPointTo = suggestion;
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please select a arrival';
                              } else return null;
                            },
                            onSaved: (value) => _selectedPointTo = value,
                          ),
//                          SizedBox(height: 20.0,),
                          titleOut('Adults/Children'),
                          Container(
                            padding: EdgeInsets.all(0.0),
                            height: 45,
                            child: GridView.count(
                              padding: EdgeInsets.all(0.0),
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              children: List.generate(2, (index) {
                                List<String> values = [_selectedLocationAd,
                                  _selectedLocationCh];
                                List<List<String>> lists = [_locationsAd,
                                  _locationsCh];
                                return Container(
                                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0,
                                      0.0),
                                  child: DropdownButton(
//                          hint: Text('1'), // Not necessary for Option 1
                                    value: values[index],
                                    onChanged: (newValue) {
                                      setState(() {
//                                      print(lists[index]);
                                        if(index==0){
                                          _selectedLocationAd = newValue;
                                        } else {
                                          _selectedLocationChAgeCount=int.parse
                                            (newValue);
                                          _selectedLocationCh = newValue;
                                        }
                                      });
                                    },
                                    items: lists[index].map((location) {
                                      return DropdownMenuItem(
                                        child: new Text(location),
                                        value: location,
                                      );
                                    }).toList(),
                                  ),
                                );
                              }),
                            ),
                          ),
                          new Visibility(
                            visible: true,
                            child: chCount(_selectedLocationChAgeCount,_selectedLocationChAges,_locationsChAges),
                          ),
                          titleOut('Date'),
                          RaisedButton(
                            onPressed: () {
                              _selectDate("transfer");
                            },
                            child: new Text(valueDateTransfer),
                          ),
                          Container(
                            height: 50,
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
//                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: RaisedButton(
                              textColor: Colors.white,
                              color: getColorFromHex("#d14d5e"),
                              child: Text('Search'),
                              onPressed: () {
//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(builder: (context) =>
//                                      TabLayout())
//                              );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              new Container(
                decoration: new BoxDecoration(color: getColorFromHex
                  ("#fdb998")),
                padding: EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 0.0),
                child: Form(
                  key: new GlobalKey<FormState>(),
                  child: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: new ListView(
                      children: <Widget>[
                        titleOut('Excursions'),
                        TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: _typeAheadControllerEx,
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 5.0,
                                      10.0, 0.0),
                                  labelText: 'City'
                              )
                          ),
                          suggestionsCallback: (pattern) {
                            if(pattern!=''){
                              return _fetchData(pattern,"excursions");
                            } else return null;
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
                            _typeAheadControllerEx.text = suggestion;
                            setState(() {
                              _selectedCity = suggestion;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please select a city';
                            } else return null;
                          },
                          onSaved: (value) => _selectedCity = value,
                        ),
//                        SizedBox(height: 20.0,),
                        titleOut('Adults/Children'),
                        Container(
                          padding: EdgeInsets.all(0.0),
                          height: 45,
                          child: GridView.count(
                            padding: EdgeInsets.all(0.0),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: List.generate(2, (index) {
                              List<String> values = [_selectedLocationAd,
                                _selectedLocationCh];
                              List<List<String>> lists = [_locationsAd,
                                _locationsCh];
                              return Container(
                                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0,
                                    0.0),
                                child: DropdownButton(
//                          hint: Text('1'), // Not necessary for Option 1
                                  value: values[index],
                                  onChanged: (newValue) {
                                    setState(() {
//                                      print(lists[index]);
                                      if(index==0){
                                        _selectedLocationAd = newValue;
                                      } else {
                                        _selectedLocationChAgeCount=int.parse
                                          (newValue);
                                        _selectedLocationCh = newValue;
                                      }
                                    });
                                  },
                                  items: lists[index].map((location) {
                                    return DropdownMenuItem(
                                      child: new Text(location),
                                      value: location,
                                    );
                                  }).toList(),
                                ),
                              );
                            }),
                          ),
                        ),
                        new Visibility(
                          visible: true,
                          child: chCount(_selectedLocationChAgeCount,_selectedLocationChAges,_locationsChAges),
                        ),
                        titleOut('Date'),
                        RaisedButton(
                          onPressed: () {
                            _selectDate("ex");
                          },
                          child: new Text(valueDateEx),
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
//                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: getColorFromHex("#d14d5e"),
                            child: Text('Search'),
                            onPressed: () {
//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(builder: (context) =>
//                                      TabLayout())
//                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              new Container(
                decoration: new BoxDecoration(color: getColorFromHex
                  ("#fdb998")),
                padding: EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 0.0),
                child: Form(
                  key: new GlobalKey<FormState>(),
                  child: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: new ListView(
                      children: <Widget>[
                        titleOut('Cruise'),
                        TypeAheadFormField(
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: _typeAheadControllerCru,
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 5.0,
                                      10.0, 0.0),
                                  labelText: 'Region'
                              )
                          ),
                          suggestionsCallback: (pattern) {
                            if(pattern!=''){
                              return _fetchData(pattern,"cruises");
                            } else return null;
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
                            _typeAheadControllerCru.text = suggestion;
                            setState(() {
                              _selectedCruise = suggestion;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please select a region';
                            } else return null;
                          },
                          onSaved: (value) => _selectedCruise = value,
                        ),
//                        SizedBox(height: 20.0,),
                        titleOut('Adults/Children'),
                        Container(
                          padding: EdgeInsets.all(0.0),
                          height: 45,
                          child: GridView.count(
                            padding: EdgeInsets.all(0.0),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: List.generate(2, (index) {
                              List<String> values = [_selectedLocationAd,
                                _selectedLocationCh];
                              List<List<String>> lists = [_locationsAd,
                                _locationsCh];
                              return Container(
                                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0,
                                    0.0),
                                child: DropdownButton(
//                          hint: Text('1'), // Not necessary for Option 1
                                  value: values[index],
                                  onChanged: (newValue) {
                                    setState(() {
//                                      print(lists[index]);
                                      if(index==0){
                                        _selectedLocationAd = newValue;
                                      } else {
                                        _selectedLocationChAgeCount=int.parse
                                          (newValue);
                                        _selectedLocationCh = newValue;
                                      }
                                    });
                                  },
                                  items: lists[index].map((location) {
                                    return DropdownMenuItem(
                                      child: new Text(location),
                                      value: location,
                                    );
                                  }).toList(),
                                ),
                              );
                            }),
                          ),
                        ),
                        new Visibility(
                          visible: true,
                          child: chCount(_selectedLocationChAgeCount,_selectedLocationChAges,_locationsChAges),
                        ),
                        titleOut('Date'),
                        RaisedButton(
                          onPressed: () {
                            _selectDate("cruise");
                          },
                          child: new Text(valueDateCruise),
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
//                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: getColorFromHex("#d14d5e"),
                            child: Text('Search'),
                            onPressed: () {
//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(builder: (context) =>
//                                      TabLayout())
//                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              new Container(
                decoration: new BoxDecoration(color: getColorFromHex
                  ("#fdb998")),
                padding: EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 0.0),
                child: new ListView (
                  children: <Widget>[
                    titleOut('Flight'),
                    SizedBox(height: 10.0,),
                    Container(
//                      height: 160,
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: _loadFlightRequest(_selectedCityFrom,
                          _selectedCityTo),
                    ),
                    titleOut('Hotel'),
                    SizedBox(height: 10.0,),
                    Container(
//                      height: 160,
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: _loadHotelRequest(_selectedHotel),
                    ),
                    titleOut('Transfer'),
                    SizedBox(height: 10.0,),
                    Container(
//                      height: 160,
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: _loadFlightRequest(_selectedPointFrom,
                          _selectedPointTo),
                    ),
                    titleOut('Excursion'),
                    SizedBox(height: 10.0,),
                    Container(
//                      height: 160,
                      child: _loadHotelRequest(_selectedCity),
                    ),
                    titleOut('Cruise'),
                    SizedBox(height: 10.0,),
                    Container(
//                      height: 50,
                      child: _loadHotelRequest(_selectedCruise),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: new Container(
            alignment: Alignment.bottomCenter,
            height: 50,
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.only(left:0.0,top:0.0,right: 0.0,
                bottom: 0.0),
            decoration: new BoxDecoration(
                color: getColorFromHex("#ffffff"), //new Color.fromRGBO(255, 0, 0, 0.0),
                borderRadius: new BorderRadius.all(Radius.circular(5.0))
            ),
            child: new TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  icon: new Icon(Icons.flight),
                ),
                Tab(
                  icon: new Icon(Icons.hotel),
                ),
                Tab(
                  icon: new Icon(Icons.local_taxi),
                ),
                Tab(icon: new Icon(Icons.group),),
                Tab(icon: new Icon(Icons.announcement),),
                Tab(icon: new Icon(Icons.fingerprint),),
              ],
              labelColor: getColorFromHex("#acaaab"),
              unselectedLabelColor: getColorFromHex("#4b4446"),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.all(5.0),
              indicatorColor: getColorFromHex("#d14d5e"),
            ),

          ),
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomPadding: true,
        ),
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:place_finder/models/place.dart';

class PlacesPage extends StatefulWidget {
  final List<Place> places;
  final String imagePath;
  PlacesPage({this.places, @required this.imagePath});
  @override
  _PlacesPageState createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {
  List<ListTile> buildMapTiles(List<AvailableMap> installedMaps, Place place) {
    List<ListTile> mapTiles = [];

    for (var map in installedMaps) {
      var tile = ListTile(
        onTap: () => map.showMarker(
          coords: Coords(place.latitude, place.longitude),
          title: place.name,
          description: '',
        ),
        title: Text(map.mapName),
        leading: Image(
          image: map.icon,
          height: 30.0,
          width: 30.0,
        ),
      );
      mapTiles.add(tile);
    }
    return mapTiles;
  }

  Widget noData() => Center(
        child: Text(
          'Unfortunately, we could not find any recommendations',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.width - 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0, 2.0),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  child: Image(
                    image: AssetImage(widget.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 25,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 18,
          ),
          widget.places.length == 0
              ? noData()
              : Center(
                  child: Text(
                    'Here are a few recommendations',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.places.length,
              itemBuilder: (BuildContext context, int index) {
                final place = widget.places[index];
                return ListTile(
                  onTap: () async {
                    try {
                      final availableMaps = await MapLauncher.installedMaps;

                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SafeArea(
                            child: SingleChildScrollView(
                              child: Container(
                                child: Wrap(
                                  children: buildMapTiles(availableMaps, place),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } catch (e) {
                      print(e);
                    }
                  },
                  title: Text(place.name),
                  trailing: Icon(Icons.arrow_forward_ios),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

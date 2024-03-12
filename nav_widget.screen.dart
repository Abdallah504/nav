import 'package:car/control/mainAppProvider.dart';
import 'package:car/view/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../screens/home__widget.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({Key? key}) : super(key: key);

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  MainAppProvider mainAppProvider = MainAppProvider();

  late GoogleMapController _googleMapController;
  var  lat;
  var long;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    mainAppProvider.determinePosition().then((value) {
      setState(() {
        lat = value.latitude;
        long = value.longitude;
        myMarkers = [
          Marker(markerId: MarkerId('MyLocation'),
              position: LatLng(lat, long)
          )
        ];
      });
    });
    super.initState();
  }
  List<Marker> myMarkers = [];

  @override
  Widget build(BuildContext context) {

    return Consumer<MainAppProvider>(builder: (context,mainAppProvider,child){
      return Padding(
          padding: EdgeInsets.only(left: 95),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child:lat!=null &&
                  long!=null?
              Scaffold(
                resizeToAvoidBottomInset: true,
                body: GoogleMap(
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(myMarkers),
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(lat,long),
                      zoom: 13),
                  onMapCreated: (controller) => _googleMapController = controller,
                ),
                floatingActionButton: FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.location_pin,color: Theme.of(context).primaryColor,),
                    onPressed: () => _googleMapController.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                            target: LatLng(lat, long), zoom: 150)
                        )
                    )
                ),
              )
                  :Center(
                child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.white, size: 50),
              )

          ));
    });
  }

}
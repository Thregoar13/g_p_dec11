import 'package:flutter/material.dart';
import 'package:g_p/format/LotLayout.dart';
import 'package:flexible/flexible.dart';
import 'package:g_p/pages/dataTesting.dart';



String jsonURL = "https://storage.googleapis.com/getparked/HotWheelsLot4.json";
class hotWheels extends StatelessWidget {
   hotWheels({required this.booleanParkingDataList});

   ParkingLot? parkingLot = ParkingLot(
     lotName: "Default Lot",
     lotURL: "https://example.com/default-lot.jpg",
     totalStalls: 0,
     parkingStalls: [],
   );

   Future<ParkingLot> futureParkingLot = ParkingLot().setupDetailed(jsonURL);

   double imageHeight = 1080;
   double imageWidth = 1920;
   int rotation = 0;

   int countAvailable = 0;
   int countOccupied = 0;

   
   List<bool> booleanParkingDataList = [];



   @override
 Widget build(BuildContext context) {


     if (MediaQuery.of(context).orientation == Orientation.portrait ){
       rotation = 1;
     }else{
       rotation = 0;
     }

     for (bool value in booleanParkingDataList) {
      if (value) {
        // true
        countAvailable++;
      } else {
        countOccupied++;
      }
     }

     return Scaffold(
         resizeToAvoidBottomInset: false,
         appBar:
         AppBar(backgroundColor: Colors.black12, title: Text('Hot Wheels Parking Lot')),
         //

         body: SingleChildScrollView(
           child: Column(
             children: [
               Container(
                 child: FutureBuilder<ParkingLot>(
                   future: futureParkingLot,
                   builder: (context, snapshot) {
                     if (snapshot.connectionState == ConnectionState.waiting) {
                       return CircularProgressIndicator();
                     } else if (snapshot.hasData) {
                       parkingLot = snapshot.data;
                       return Padding(
                         padding: EdgeInsetsDirectional.fromSTEB(22, 0, 22, 0),
                         child: Container(
                           decoration: BoxDecoration(
                             border: Border.all(
                               width: 4,
                             ),
                             borderRadius: BorderRadius.circular(12),
                           ),
                           child: FittedBox(
                             fit: BoxFit.fitHeight,
                             child: RotatedBox(
                               quarterTurns: rotation,
                               child: CustomPaint(
                                 size: Size(imageWidth, imageHeight),
                                 child: Image.network(parkingLot!.lotURL),
                                 // Set the size as per your image dimensions
                                 foregroundPainter: RectanglePainter(
                                   parkingLot!.parkingStalls,
                                   imageWidth,
                                   imageHeight,
                                   booleanParkingDataList,
                                 ),
                               ),
                             ),
                           ),
                         ),
                       );
                     } else {
                       return Text('Error: ${snapshot.error}');
                     }
                   },
                 ),
               ),
               Row(
                 // mainAxisSize: MainAxisSize.max,
                 mainAxisAlignment: MainAxisAlignment.center,
                 //crossAxisAlignment: CrossAxisAlignment.end,
                 children: [
                   Center(

                     child: Text(
                       'Parking Lot Availability',
                       style: TextStyle(
                         fontSize: 22,
                         fontFamily: 'Readex Pro',
                         color: Colors.black,
                         fontWeight: FontWeight.w800,
                       ),
                     ),
                   ),
                 ],
               ),
               Row(
                 mainAxisSize: MainAxisSize.max,
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.end,
                 children: [
                   Padding(
                     padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 8),
                     child: Text(
                       'Available: ',
                       style: TextStyle(
                         fontFamily: 'Readex Pro',
                         color: Colors.black,
                         fontWeight: FontWeight.w600,
                       ),
                     ),
                   ),
                   Padding(
                     padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                     child: Text(
                       '$countAvailable',
                       style: TextStyle(
                         fontFamily: 'Readex Pro',
                         color: Color(0xFF5AEF39),
                       ),
                     ),
                   ),
                 ],
               ),
               Row(
                 mainAxisSize: MainAxisSize.max,
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Padding(
                     padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                     child: Text(
                       'Occupied: ',
                       style: TextStyle(
                         fontFamily: 'Readex Pro',
                         color: Colors.black,
                         fontWeight: FontWeight.w600,
                       ),
                     ),
                   ),
                   Padding(
                     padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                     child: Text(
                       '$countOccupied',
                       style: TextStyle(
                         fontFamily: 'Readex Pro',
                         color: Color(0xFFEF393C),
                       ),
                     ),
                   ),
                 ],
               ),
               Row(
                 mainAxisSize: MainAxisSize.max,
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Padding(
                     padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                     child: Text(
                       'Handicapped:',
                       textAlign: TextAlign.center,
                       style: TextStyle(
                         fontFamily: 'Readex Pro',
                         color: Colors.black,
                         fontWeight: FontWeight.w600,
                       ),
                     ),
                   ),
                   Padding(
                     padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                     child: Text(
                       ' 3',
                       textAlign: TextAlign.center,
                       style: TextStyle(
                         fontFamily: 'Readex Pro',
                         color: Colors.blueGrey,
                         fontWeight: FontWeight.normal,
                       ),
                     ),
                   ),
                 ],
               ),
             ],
           ),
         )
     );
   }
}



class RectanglePainter extends CustomPainter {
  final List<ParkingStalls> parkingStalls;
  final double imageWidth;
  final double imageHeight;
  final List<bool> avab; // List of availability statuses

  RectanglePainter(this.parkingStalls,  this.imageWidth, this.imageHeight, this.avab);

  @override

  void paint(Canvas canvas, Size size) {
    print("oopsie");
    for (int i = 0; i < parkingStalls.length; i++) {
      final paint = Paint()
        ..style = PaintingStyle.fill;

      final paint2 = Paint()
        ..color = Colors.black87
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0;


      final x = ((parkingStalls[i].x + 2) / imageWidth) * size.width;
      final y = ((parkingStalls[i].y + 2) / imageHeight) * size.height;
      final x2 = (parkingStalls[i].x / imageWidth) * size.width;
      final y2 = (parkingStalls[i].y / imageHeight) * size.height;

      final rect = Rect.fromPoints(Offset(x, y), Offset(x + parkingStalls[i].OffsetX, y + parkingStalls[i].OffsetY));


      final rect2 = Rect.fromPoints(Offset(x2, y2), Offset(x2 + parkingStalls[i].OffsetX, y2 + parkingStalls[i].OffsetY));

      paint.color = avab[i] ? Colors.green : Colors.red;
      canvas.drawRect(rect, paint);
      canvas.drawRect(rect2, paint2);
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
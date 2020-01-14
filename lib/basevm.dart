
import 'package:connectivity/connectivity.dart';

class BaseVm{ 

   Future<bool> hasNet()async{
    var netStat =  await Connectivity().checkConnectivity(); 
    return netStat != ConnectivityResult.none;
  }

}
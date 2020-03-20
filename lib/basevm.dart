
import 'dart:io';

import 'package:connectivity/connectivity.dart';

class BaseVm{ 

   Future<bool> hasNet()async{
     try{ 
       var netStat =  await Connectivity().checkConnectivity(); 
       return netStat != ConnectivityResult.none;
     }catch(e){
       print(e.toString()); 
       return true;
     }
  }

}
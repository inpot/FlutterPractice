import 'package:flutter/material.dart';

class Observable<T> with ChangeNotifier{
  T _value;

  Observable(this._value);

  void set(T newValue){
    if(_value == newValue){
      return;
    }
    _value = newValue;
    notifyListeners(); 
  } 

  T get() => _value;

}

class Observable2<T,R> with ChangeNotifier{
  T _v1;
  R _v2;

  Observable2(this._v1,this._v2);
  

  set(T newV1, R newV2){
    if(_v1 == newV1 && _v2 == newV2){
      return;
    }
    _v1 = newV1;
    _v2 = newV2;
    notifyListeners(); 
  } 

  set V2(R newV2){ 
    if(_v2 == newV2 ){
      return;
    }
    _v2 = newV2;
    notifyListeners(); 
  }

  set V1(T newV1){ 
    if(_v1 == newV1 ){
      return;
    }
    _v1 = newV1;
    notifyListeners(); 
  }
  T get V1 => _v1;
  R get V2 => _v2; 
}

class Observable3<T,R,S> with ChangeNotifier{
  T _v1;
  R _v2;
  S _v3;

   Observable3(this._v1, this._v2,this._v3);

  set(T newV1, R newV2, S newV3){
    if(_v1 == newV1 && _v2 == newV2 && _v3 == newV3){
      return;
    }
    _v1 = newV1;
    _v2 = newV2;
    _v3 = newV3;
    notifyListeners(); 
  } 

  set V3(S newV3){ 
    if(_v3 == newV3 ){
      return;
    }
    _v3 = newV3;
    notifyListeners(); 
  }
  set V2(R newV2){ 
    if(_v2 == newV2 ){
      return;
    }
    _v2 = newV2;
    notifyListeners(); 
  }

  set V1(T newV1){ 
    if(_v1 == newV1 ){
      return;
    }
    _v1 = newV1;
    notifyListeners(); 
  }
  T get V1 => _v1;
  R get V2 => _v2; 
  S get V3 => _v3;

  }
  
  class Test{
  
    Observable<int> age = Observable(0);
    var aaaa= Observable("aaaaa");
    var ob2 = Observable2(10,"Strrrr");
    var ob3 = Observable3(10,"Strrrr", "Sttttt");
  
    void updateOb2(){
      ob2.set(15, "98999");
      ob3.set(15, "98999","aadfa");

      ob3.V3 = "aaaaa";
  }


}

class User{
  
  String state;
  int id;
  color leftHandColor;
  color rightHandColor;
  
  // variables to keep track of the previous hand positions. 
  float pRightHandX;
  float pRightHandY;
  float pLeftHandX;
  float pLeftHandY;
  
  // keep track of if each hand is active or not
  boolean leftActive;
  boolean rightActive;
  
  
  
  User(int user_id){
    id = user_id;
    state = "traditional";
    leftHandColor =  color(random(0,255), 255,255,100);
    rightHandColor = color(random(0,255), 255,255,100);
    leftActive = false;
    rightActive = false;
  }
  
  void setState(String newState){
    state = newState;
  }
  
  String getState(){
    return state;
  }
  
  color getLeftHandColor(){
    return leftHandColor;
  }
  
  color getRightHandColor(){
    return rightHandColor;
  }
  
}

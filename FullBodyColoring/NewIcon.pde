class NewIcon{
  
  float xPos;
  float yPos;
  float w; 
  float h;
  
  boolean isHandOver; // for keeping track of if a user is hovering over the icon
  float timer; // for keeping track of how long the user's hand is over it
  boolean timerFull; 
  
  PImage img;
  
  
  NewIcon(float x, float y){
    xPos = x;
    yPos = y;
    w = 50;
    h = 50;
    timer = 0;
    isHandOver = false;
    timerFull = false;
    img = loadImage("new.jpg");
  }
  
  
  void display(PGraphics layer){
    //layer.stroke(100,255,255);
    //layer.strokeWeight(30);
    //layer.line(xPos,yPos-12,xPos+80, yPos-12);
    //layer.text("[CLEAR]", xPos,yPos);
    layer.image(img,xPos,yPos, img.width/8, img.height/8);
    
    
    if(timer>0){
      layer.fill(125, 255, 255);
      layer.strokeWeight(10);
      layer.pushMatrix();
      layer.translate(xPos+w/2, yPos);
      if(timer<=2){
        rotateFillIcon(layer, 1,12);
      }else if (timer<=4){
        rotateFillIcon(layer,2,12);
      }else if (timer<=6){
        rotateFillIcon(layer,3,12);
      }else if (timer<=8){
        rotateFillIcon(layer,4,12);
      }else if (timer<=10){
        rotateFillIcon(layer,5,12);
      }else if (timer<=12){
        rotateFillIcon(layer,6,12);
      }else if (timer<=14){
        rotateFillIcon(layer,7,12);
      }else if (timer<=16){
        rotateFillIcon(layer,8,12);
      }else if (timer<=18){
        rotateFillIcon(layer,9,12);
      }else if (timer<=20){
        rotateFillIcon(layer,10,12);
      }else if (timer<=22){
        rotateFillIcon(layer,11,12);
      }else {
        rotateFillIcon(layer,12,12);
        timerFull = true;
      }
      layer.popMatrix();
    }
    
  }
  
  
    // helper function to fill the circles that show up around the icon when the user is hovering. 
  void rotateFillIcon(PGraphics layer, int filled, int total){
    // draw filled circles. 
    layer.fill(125,255,255);
    layer.noStroke();
    for (int i=0; i<filled; i++){
      layer.rotate((2*PI)/12);
      layer.ellipse(30,30,14,14);
    }
    // draw rest of the circles empty
    layer.noFill();
    layer.stroke(0);
    layer.strokeWeight(6);
    for (int i=0; i<total-filled; i++){
      layer.rotate((2*PI)/12);
      layer.ellipse(30,30,14,14);
    }
      
  }
  
  
}

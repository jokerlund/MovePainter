class PrintIcon{
  
  float xPos;
  float yPos;
  float w; 
  float h;
  
  boolean isHandOver; // for keeping track of if a user is hovering over the icon
  float timer; // for keeping track of how long the user's hand is over it
  boolean timerFull; 
  
  PImage img;
  PImage imgFull;
  
  boolean printConfirmation;
  int printConfCount;
  
  
  PrintIcon(float x, float y){
    xPos = x;
    yPos = y;
    w = 50;
    h = 50;
    timer = 0;
    isHandOver = false;
    timerFull = false;
    img = loadImage("print.jpg");
    imgFull = loadImage("printGreen.jpg");
    printConfirmation = false;
    printConfCount = printConfCount + 1;
  }
  
  
  void display(PGraphics layer){
    //layer.text("[PRINT]", xPos,yPos);
    if (printConfirmation){
      layer.image(imgFull,xPos,yPos, img.width/8, img.height/8);
    }
    else{
      layer.image(img,xPos,yPos, img.width/8, img.height/8);
    }
    
    if(timer>0){
      layer.fill(125, 255, 255);
      layer.strokeWeight(10);
      layer.pushMatrix();
      layer.translate(xPos+w/2, yPos);
      if(timer<=2){
        rotateFillIcon(layer, 1,12);
      }else if (timer<=8){
        rotateFillIcon(layer,2,12);
      }else if (timer<=16){
        rotateFillIcon(layer,3,12);
      }else if (timer<=24){
        rotateFillIcon(layer,4,12);
      }else if (timer<=28){
        rotateFillIcon(layer,5,12);
      }else if (timer<=32){
        rotateFillIcon(layer,6,12);
      }else if (timer<=36){
        rotateFillIcon(layer,7,12);
      }else if (timer<=40){
        rotateFillIcon(layer,8,12);
      }else if (timer<=44){
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

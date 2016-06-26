class BrushMenuIcon{
  
  float xPos;
  float yPos;
  float w; // width
  float h; // height
  String type;
  
  boolean isHandOver; // for keeping track of if a user is hovering over the icon
  float timer; // for keeping track of how long the user's hand is over it
  boolean timerFull; 
  
  
   BrushMenuIcon(float x, float y, float wdt, float hgt, String t){
    xPos = x;
    yPos = y;
    w = wdt;
    h = hgt;
    type = t;
    timer = 0;

  }
  
  void display(PGraphics layer){
    
    //layer.fill(10,255,255, 50);
    //layer.noStroke();
    //layer.ellipse(xPos, yPos, 70,70);
    
    
    // old traditional
    /*if (type == "traditional"){
      layer.fill(50,50,50);
      layer.strokeWeight(30);
      layer.line(xPos,yPos,xPos,yPos+15);// the horizontal bit
      layer.strokeWeight(10);
      layer.line(xPos,yPos,xPos,yPos+40); // the handle
      layer.strokeWeight(1);
      for (int i=int(xPos)-15; i<=xPos+15; i=i+3){
        layer.line(i,yPos,i,yPos-15);
      }
    }*/
    
    if (type == "traditional"){
      
      iconOutline(layer, xPos,yPos);
      
      layer.fill(50,50,50);
      layer.ellipse(xPos,yPos,30,30);
    }
    
    else if (type == "thin"){
      iconOutline(layer, xPos,yPos);
      layer.fill(50,50,50);
      layer.ellipse(xPos,yPos,8,8);
    }
    
    // old thin
    /*if (type == "thin"){
      layer.fill(50,50,50);
      layer.strokeWeight(15);
      layer.line(xPos,yPos,xPos,yPos+15);// the horizontal bit
      layer.strokeWeight(10);
      layer.line(xPos,yPos,xPos,yPos+40); // the handle
      layer.strokeWeight(1);
      for (int i=int(xPos)-7; i<=xPos+8; i=i+3){
        layer.line(i,yPos,i,yPos-15);
      }
    }*/
    
    // PROGRESS: looks more like the brush it gives.  Similar to a jax
    else if (type == "spike"){
      iconOutline(layer, xPos,yPos);
      layer.fill(50,50,50);
      layer.stroke(50,50,50);
      layer.strokeWeight(15);
      layer.ellipse(xPos, yPos, 3, 3);
      layer.strokeWeight(2);
      layer.line(xPos, yPos, xPos - 12, yPos - 12);
      layer.noFill();
      layer.ellipse(xPos - 12, yPos - 12, 6, 6);
      layer.line(xPos, yPos, xPos - 12, yPos + 12);
      layer.ellipse(xPos - 12, yPos +12, 6, 6);
      layer.line(xPos, yPos, xPos + 12, yPos + 12);
      layer.ellipse(xPos + 12, yPos + 12, 6, 6);
      layer.line(xPos, yPos, xPos + 12, yPos - 20);
      layer.ellipse(xPos + 12, yPos - 20, 6, 6);
    }
    
    else if (type == "connect"){
      iconOutline(layer, xPos,yPos);
      layer.fill(50,50,50);
      layer.stroke(50,50,50);
      layer.strokeWeight(6);
      //layer.ellipse(xPos, yPos, 30,30);
      layer.line(xPos-15, yPos-10, xPos + 15, yPos-10);
      layer.line(xPos-10, yPos, xPos + 10, yPos);
      layer.line(xPos-5, yPos+10, xPos + 5, yPos+10);
    }
    
    else{
    }
    
    if(timer>0){
      layer.fill(125, 255, 255);
      layer.strokeWeight(10);
      layer.pushMatrix();
      layer.translate(xPos, yPos);
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
  
  void iconOutline(PGraphics layer, float xPos, float yPos){
    layer.fill(0,0,125);
    layer.stroke(0);

    layer.strokeWeight(0);
    layer.noStroke();

    layer.ellipse(xPos+10, yPos+10, 70,70);
    layer.fill(0,0,150);
    layer.ellipse(xPos, yPos, 70,70);
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



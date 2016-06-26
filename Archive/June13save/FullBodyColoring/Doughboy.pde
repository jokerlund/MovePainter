import gifAnimation.*;

class Doughboy{
  
  float xPos;
  float yPos;
  float initY;
  float w; // width
  float h; // height
  boolean visible;
  PImage img;
  PFont f;
  
  Animation jump;
  
  float deltaY;
  String mode;
  
  Doughboy(float x, float y){
    xPos = x;
    import gifAnimation.*;
    yPos = y;
    initY = y;
    w = 100;
    h = 100;
    //colorMode(HSB);
    //c = color(hue(col), saturation(col), brightness(col), 255);
    visible = false;
    img = loadImage("doughboy.png");
    
    // for making it jump
    deltaY = 0;
    
    f = createFont("Chalkboard", 40);
    mode = "jump";
    
    frameRate(10);
    jump = new Animation("jump/jump_", 13);

  }
  
  void display(PGraphics layer){
    //layer.colorMode(HSB);
    //layer.fill(color(255,255,255));
    //layer.ellipse(xPos + 60, yPos, 30,30);
    
    //layer.image(img, xPos, yPos, w, h);
    jump.display(xPos-40, yPos, layer);
    
    if(mode=="jump"){
      if (yPos <= initY - (h)){
        //deltaY = 5;
      }
      
      if(yPos >= initY){
        //deltaY = -5;
      }
      yPos = yPos + deltaY;
      
      // text
      layer.textFont(f);
      layer.fill(0);
      layer.text("Paint with me!", xPos-100, initY+80);
    }
    
    else if (mode=="closer"){
              layer.textFont(f);
      layer.fill(0);
      if (xPos >= 0){
        xPos=xPos-5;
      }
      jump.display(xPos-40, yPos, layer);
      if(xPos >= width*.15){
      layer.text("Come closer!", xPos-100, initY+80);
      }
      if(xPos < width*.15){
        layer.text("Good job!", xPos+100, initY+80);
      }
      
    }
  }
  
}


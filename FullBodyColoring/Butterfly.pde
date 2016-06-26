class Butterfly {
  float x, y, z, l, theta, t1, t2, t3, r, g, b, c;
  float noiseValue = 0.005;
  float w;
  
  
  // these variables are for making the butterfly do a random movement when it is touched. 
  float xDir;
  float yDir;
  boolean flyingAway;
  float flyCount;

  Butterfly(float tempT1, float tempT2, float tempT3) {
    t1 = tempT1;
    t2 = tempT2;
    t3 = tempT3;
    l = 0.0;
    theta = 0.0;
    r = random(255);
    g = random(255);
    b = random(255);
    c = random(255);
    x=100;
    y=200;
    w = 50;
    xDir = 0;
    yDir = 0;
    flyingAway = false;
    flyCount = 0;
  }


  void move() {    
    //x = (noise(t1)*width);
    //y = (noise(t2)*height);
    //float 
    //x = x + random(-10,10);
    //y = y + random(-10,10);
    z = (noise(t3)*height);
    t1+=noiseValue;
    t2+=noiseValue; 
    t3+=0.008;

    /*//println("MOVE");
     //println("t1 " + t1);
     //println("t2 " + t2);
     //println(noise(t1));*/
  }
  
  
  // makes the butterfly fly away a certain distance
  void flyAway(float count, float xDir, float yDir){
    
    
    
  }
  
  
  void display(PGraphics layer) {
    
    // make the butterfly go in random directions if flying away. 
    if (flyingAway){
      flyCount = flyCount + 1;
      x = x + random(0,20)* xDir;
      y = y + random(0,20) * yDir;
    } if (flyCount >= 20){
      flyingAway = false;
      flyCount = 0;
    }
    
    if (x<=10){
      x = x+20;
    }
    if (y<=10){
      y= y+20;
    } 
    if (y>=height-50){
      y = y-50;
    }
    if(x>=width-50){
      x = x-50;
    }
    
   //background(255, 0);
   theta+=0.7;
   l = sin(theta)*5;
   //layer.pushMatrix();
   //layer.translate(0,0,z-200);
   layer.noStroke();
   layer.fill(r,g,b);
   layer.bezier(x,y,x+20-l,y+45+l,x+20-l,y-15+l,x,y);
   layer.bezier(x,y,x+25-l,y-45-l,x+25-l,y+15-l,x,y);
   layer.bezier(x,y,x-20+l,y+45+l,x-20+l,y-15+l,x,y);
   layer.bezier(x,y,x-25+l,y-45-l,x-25+l,y+15-l,x,y);
   layer.strokeWeight(4);
   layer.stroke(0);
   layer.line(x,y-10,x,y+10);
   layer.strokeWeight(1);
   layer.line(x,y-9,x-5,y-19);
   layer.line(x,y-9,x+5,y-19);
   //layer.popMatrix();
   }
}


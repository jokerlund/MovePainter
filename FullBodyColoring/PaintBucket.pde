
class PaintBucket{
  
  float xPos;
  float yPos;
  float w; // width
  float h; // height
  color c; 
  boolean isSelected;
  
  PaintBucket(float x, float y, float wdt, float hgt, color col){
    xPos = x;
    yPos = y;
    w = wdt;
    h = hgt;
    colorMode(HSB);
    //c = color(hue(col), saturation(col), brightness(col), 255);
    c = col;
    isSelected = false;
  }
  
  void display(PGraphics layer){
    //colorMode(HSB);
    layer.colorMode(HSB);
    layer.fill(c);
    //layer.ellipse(xPos, yPos, w, h);
    //Green bucket start
    int x = 110;
    int y = 490;
  
    //bottom of paint bucket
    layer.stroke(0,0,0);
    layer.noStroke();
    if(isSelected == false)
    {
    layer.fill(133, 133, 133);
    }
    else
    {
    layer.fill(133, 133, 200);
    }
    layer.rect(xPos, yPos, 50,50);
  
    //top of paint bucket (has color)
    layer.stroke(0, 0, 0);
    layer.strokeWeight(1);
    layer.fill(color(hue(c), saturation(c), brightness(c), 255));
    //layer.fill(155,255,255);
    if(isSelected){
      layer.ellipse(xPos+25, yPos+1, 50, 38);
    }
   else{ 
    layer.ellipse(xPos+25, yPos+ 1, 50, 30);
    }
  //Green bucket end
  
 /* //Red bucket start
  x = 210;
  y = 490;
  
  //bottom of bucket
  stroke(0, 0, 0);
  fill(133, 133, 133);
  rect(x - 20, y, 50, 50);
  
  //top of paint bucket
  stroke(0, 0, 0);
  fill(248, 17, 0);
  ellipse(x + 5, y + 1, 50, 30);
  
  //Red bucket end
  
  //Blue bucket start
  x = 310;
  y = 490;
  
  //bottom of bucket
  stroke(0, 0, 0);
  fill(133, 133, 133);
  rect(x - 20, y, 50, 50);

  //top of bucket
  stroke(0, 0, 0);
  fill(0, 17, 248);
  ellipse(x + 5, y + 1, 50, 30);

  //Blue bucket end  
  
  //Yellow bucket start
  x = 410;
  y = 490;
  
  //bottom of bucket
  stroke(0, 0, 0);
  fill(133, 133, 133);
  rect(x - 20, y, 50, 50);  
  
  //top of bucket
  stroke(0, 0, 0);
  fill(255, 255, 0);
  ellipse(x + 5, y + 1, 50, 30);
  
  //End yellow
  
  //Brown start
  x = 510;
  y = 490;
  
  //bottom of bucket
  stroke(0, 0, 0);
  fill(133, 133, 133);
  rect(x - 20, y, 50, 50);
  
  //top of bucket
  stroke(0, 0, 0);
  fill(139, 69, 19);
  ellipse(x + 5, y + 1, 50, 30);
  
  //End brown
  
  //Black start
  x = 610;
  y = 490;
  
  //bottom of bucket
  stroke(0, 0, 0);
  fill(133, 133, 133);
  rect(x - 20, y, 50, 50);
  
  //top of bucket
  stroke(0, 0, 0);
  fill(0, 0, 0);
  ellipse(x + 5, y + 1, 50, 30);
  
  //End black
  
  //Purple start
  x = 710;
  y = 490;
  
  //bottom of bucket
  stroke(0, 0, 0);
  fill(133, 133, 133);
  rect(x - 20, y, 50, 50);

  //top of bucket
  stroke(0, 0, 0);
  fill(139, 0 ,139);
  ellipse(x + 5, y + 1, 50, 30);  
  
  //End purple
  
  //white start
  
  x = 810;
  y = 490;
  
  //bottom of bucket
  stroke(0, 0, 0);
  fill(133, 133, 133);
  rect(x - 20, y, 50, 50);

  //top of bucket
  stroke(0, 0, 0);
  fill(255, 255, 255);
  ellipse(x + 5, y + 1, 50, 30);  
  
  //End white*/
}
  }
  
 


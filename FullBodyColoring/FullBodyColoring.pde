/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/174694*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
/* --------------------------------------------------------------------------
By Aatish Bhatia, using code by Daniel Shiffman (recursive tree code) and Max Rheiner (SimpleOpenNI library example)
Oct 27 2014
 */
 
import gifAnimation.*;

// change these to change the condition. 
boolean brushOnly = false;
boolean coloringBook = false;
boolean doughboy = false;
boolean coloringFill = true;

boolean scene1On = false;
boolean scene2On = false;

float theta1;
float theta2;
float yval;
float xval;

int saveCount;

PGraphics artLayer;
PGraphics skeletonLayer;
PGraphics objectLayer;
PGraphics pageLayer;

PImage brushUp;
PImage brushTransp;
PImage coloringPage;
PImage seurat;

PImage scene1;
PImage scene2;

boolean isCurrentlyFilling = false; // TO DO: This is really bad. big hack to get it to stop calling fill area so many times and overflowing the stack. 

PFont f;
//PrintIcon printIcon;
ClearIcon clearIcon;

ModeMenuIcon color1Icon;
ModeMenuIcon color2Icon;
ModeMenuIcon scene1Icon;
ModeMenuIcon scene2Icon;
//NewIcon newIcon;

Doughboy doughy; 

import SimpleOpenNI.*;

SimpleOpenNI  context;
color[]       userClr = new color[]{ color(255,0,0),
                                     color(0,255,0),
                                     color(0,0,255),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };
                                   
                               
//PVector com = new PVector();                                   
//PVector com2d = new PVector();       

// keep track of all the user objects representing the users in the view. 
HashMap<Integer, User> allPresentUsers = new HashMap<Integer, User>(); 

// keep track of all the paint buckets on the screen
ArrayList<PaintBucket> paintBuckets = new ArrayList<PaintBucket>();

// keep track of all the paint brush menu items on the screen 
ArrayList<BrushMenuIcon> brushMenuIcons = new ArrayList<BrushMenuIcon>();

// keep track of all the butterflies on the screen 
//ArrayList<Butterfly> butterflies = new ArrayList<Butterfly>();




void setup()
{
  size(825,540,P2D);
  
  saveCount = 0; // TO DO - make this better. 
  
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }

  context.setMirror(true);
  
  // enable depthMap generation 
  context.enableDepth();
   
  // enable skeleton generation for all joints
  context.enableUser();
 
  background(255);
  frameRate(20);

  stroke(0,255,0);
  strokeWeight(3);
  smooth();  
  
  artLayer = createGraphics(width,height,OPENGL);
  skeletonLayer = createGraphics(width,height,OPENGL);
  objectLayer = createGraphics(width,height,OPENGL);
  pageLayer = createGraphics(width,height,OPENGL);
  
  // set all layers in the correct color mode
  artLayer.beginDraw();
  artLayer.colorMode(HSB);
  artLayer.noStroke();
  artLayer.endDraw();
  
  objectLayer.beginDraw();
  objectLayer.colorMode(HSB);
  f = createFont("Georgia", 24);
  objectLayer.textFont(f);
  objectLayer.endDraw();
  
  skeletonLayer.beginDraw();
  skeletonLayer.colorMode(HSB);
  skeletonLayer.endDraw();
    
  colorMode(HSB);
  
  
  
  // initialize paint buckets and add to paint bucket array
  /*PaintBucket pot1 = new PaintBucket(width*.11, height-height*.1, 70,70, color(25,255,255,120)); //orange
  PaintBucket pot8 = new PaintBucket(width*.21, height-height*.1, 70,70, color(225,255,255,120)); //pink
  PaintBucket pot2 = new PaintBucket(width*.31, height-height*.1, 70,70, color(75,255,255,120)); //light green
  PaintBucket pot7 = new PaintBucket(width*.41, height-height*.1, 70, 70, color(127, 255, 255, 120));//turquoise
  PaintBucket pot3 = new PaintBucket(width*.51, height-height*.1, 70,70, color(0,255,255,120)); //red
  PaintBucket pot6 = new PaintBucket(width*.61, height-height*.1, 70, 70, color(39, 255, 255, 120)); //yeller
  PaintBucket pot4 = new PaintBucket(width*.71, height-height*.1, 70,70, color(175,255,255,120)); //dark blue
  PaintBucket pot9 = new PaintBucket(width*.81, height-height*.1, 70,70, color(200,255,255,120)); //purple  
  PaintBucket pot5 = new PaintBucket(width*.01, height-height*.1, 70,70, color(0,0,255,80)); //white*/
  
  PaintBucket pot5 = new PaintBucket(width*.12, height-height*.1, 70,70, color(208,44,45,200));
  PaintBucket pot1 = new PaintBucket(width*.22, height-height*.1, 70,70, color(234,138,25,200)); 
  PaintBucket pot8 = new PaintBucket(width*.42, height-height*.1, 70,70, color(243,214,88,200)); 
  PaintBucket pot2 = new PaintBucket(width*.32, height-height*.1, 70,70, color(157,203,81,200)); 
  PaintBucket pot7 = new PaintBucket(width*.52, height-height*.1, 70, 70, color(40, 190, 191, 200));
  PaintBucket pot3 = new PaintBucket(width*.62, height-height*.1, 70,70, color(129,83,148,200)); 
  //PaintBucket pot6 = new PaintBucket(width*.61, height-height*.1, 70, 70, color(181, 133, 95, 200)); 
  PaintBucket pot4 = new PaintBucket(width*.72, height-height*.1, 70,70, color(77,75,76,200));
  PaintBucket pot9 = new PaintBucket(width*.82, height-height*.1, 70,70, color(251,119,166,200));  
   
  
  paintBuckets.add(pot1);
  paintBuckets.add(pot2);
  paintBuckets.add(pot3);
  paintBuckets.add(pot4);
  paintBuckets.add(pot5);
  //paintBuckets.add(pot6);
  paintBuckets.add(pot7);
  paintBuckets.add(pot8);
  paintBuckets.add(pot9);
  
  
  // initialize brush menu
  BrushMenuIcon brushIcon1 = new BrushMenuIcon(width*.95, height*.1, 40,40, "traditional");
  BrushMenuIcon brushIcon2 = new BrushMenuIcon(width*.95, height *.3, 40,40, "thin");
  BrushMenuIcon brushIcon3 = new BrushMenuIcon(width*.95, height * .5, 40, 40, "spike");
  BrushMenuIcon brushIcon4 = new BrushMenuIcon(width*.95, height *.7, 40, 40, "connect");
  brushMenuIcons.add(brushIcon1);
  brushMenuIcons.add(brushIcon2);
  brushMenuIcons.add(brushIcon3);
  brushMenuIcons.add(brushIcon4);
  
  // create print icon
  //printIcon = new PrintIcon(width-100,height-115);
  //create clear icon
  clearIcon = new ClearIcon(10,30);
   
  color1Icon = new ModeMenuIcon(10, height*.2, "color1");
  color2Icon = new ModeMenuIcon(10,height*.35, "color2");
  scene1Icon = new ModeMenuIcon(10,height*.5, "scene1");
  scene2Icon = new ModeMenuIcon(10,height*.65, "scene2");
 
  //newIcon = new NewIcon(150, 30);
  
  // make a doughboy object 
  doughy = new Doughboy(width*.35, height*.3);
  
  // initialize butterflies
  /*Butterfly b1 = new Butterfly(random(width), random(height), random(height));
  Butterfly b2 = new Butterfly(random(width), random(height), random(height));
  butterflies.add(b1);
  butterflies.add(b2);*/
  
  brushUp = loadImage("paintbrushUP.png");
  brushTransp = loadImage("paintbrushTransp.png");
  coloringPage = loadImage("turtle4.png");
  
  scene1 = loadImage("a.png");
  scene2 = loadImage("b.jpg");
  
  // load the coloring fill image in so that it is see through where there are no lines. 
    seurat = loadImage("seurat.png");  // Load the image into the program  
    print(seurat.width);
    print("\n");
    print(seurat.height);
    print("\n");
    colorMode(RGB);
  //size(seurat.width, seurat.height);
    seurat.loadPixels(); 
  for (int y = 0; y < seurat.height; y++) {
    for (int x = 0; x < seurat.width; x++) {
      int loc = x + y*seurat.width;
      
      // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
      float r = red(seurat.pixels[loc]);
      float g = green(seurat.pixels[loc]);
      float b = blue(seurat.pixels[loc]);
      
      // take everything that is not completely white and make it black. ie flatten the greyscale 
      if (!((r==255) && (g==255) && (b==255))){
        r = 0;
        g = 0;
        b = 0;
         //seurat.pixels[loc] =  color(r,g,b);
         //seurat.pixels[loc] = 0x00FFFFFF;
      }
      else{
         //seurat.pixels[loc] =  color(255,255,255,0);
         //seurat.pixels[loc] &= 0x00FFFFFF;
      }
     
               
    
      }
  }
  seurat.updatePixels();
  
}

void draw()
{
  // update the cam
  context.update();
  //background(255,255,255);
   textSize(20);
   
     
   
   
   int[] userList = context.getUsers();
   
   if (userList.length == 0){
          
          
       
          
          // if in doughboy mode, draw doughboy 
         if (doughboy){
           skeletonLayer.beginDraw();
           skeletonLayer.clear();
           skeletonLayer.background(0,0,255);
           if(scene1On){
            skeletonLayer.image(scene1, 0,0, width, height);
            }
           doughy.display(skeletonLayer);
           skeletonLayer.endDraw();
          image(skeletonLayer,0,0);
         }
         else{
           if(scene1On){ // scene is on and no doughboy 
             skeletonLayer.beginDraw();
             skeletonLayer.image(scene1, 0,0, width, height);
             skeletonLayer.endDraw();
             image(skeletonLayer,0,0);
           }
         }
        
      }
      

   
   if (userList.length == 0 && coloringBook){ // if the application is in coloring book mode, place coloring book image on top of the lines. 
        pageLayer.beginDraw();
        pageLayer.image(coloringPage, width*.05,height*.05, width*.8, height*.8);
        pageLayer.endDraw();
        image(pageLayer,0,0);
      }
      
       if (userList.length == 0 && coloringFill){ // if the application is in coloring book mode, place coloring book image on top of the lines. 
        pageLayer.beginDraw();
        //pageLayer.image(seurat, width*.05,height*.05, width*.8, height*.8); // TO DO don't just put seurat here. 
        pageLayer.image(seurat, width*.2,height*.05, seurat.width, seurat.height);
        pageLayer.endDraw();
        image(pageLayer,0,0);
      }
      
   
   // iterate through the brush menu icons and see if they are being hovered over. 
   // (moved this code from inside the user loop since it was messing up when there were multiple users in the scene. 
   for (int j=0; j<brushMenuIcons.size(); j++){
       BrushMenuIcon b = brushMenuIcons.get(j);
       
       boolean brushHasHand = false; // assume there is no hand, prove otherwise. 
       
       for(int i=0;i<userList.length;i++){
         User u = allPresentUsers.get(userList[i]);
        PVector rightHand = new PVector();
        context.getJointPositionSkeleton(userList[i],SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);
        PVector convertedRightHand = new PVector();
        context.convertRealWorldToProjective(rightHand,convertedRightHand);
        float rightHandMappedX = map(convertedRightHand.x, 0, 640, 0, width);
        float rightHandMappedY = map(convertedRightHand.y, 0, 480, 0, height);
  
        
        PVector leftHand = new PVector();
        context.getJointPositionSkeleton(userList[i],SimpleOpenNI.SKEL_LEFT_HAND,leftHand);
        PVector convertedLeftHand = new PVector();
        context.convertRealWorldToProjective(leftHand,convertedLeftHand);
        float leftHandMappedX = map(convertedLeftHand.x, 0, 640, 0, width);
        float leftHandMappedY = map(convertedLeftHand.y, 0, 480, 0, height);
       
        if(abs(rightHandMappedX - b.xPos) <= b.w*.75 && abs(rightHandMappedY - b.yPos) <= b.w*.75){
          
          //println("TYPE: " + b.type);
          b.isHandOver = true;
          b.timer = b.timer+1;
          brushHasHand = true;
          if(b.timerFull){
             allPresentUsers.get(userList[i]).state = b.type;
             b.isHandOver = false;
             b.timer = 0;
           }
        }
        else if(abs(leftHandMappedX - b.xPos) <= b.w*.75 && abs(leftHandMappedY - b.yPos) <= b.w*.75){
          
         // println("TYPE: " + b.type);
         b.isHandOver = true;
         b.timer= b.timer+1;
         brushHasHand = true;
         if(b.timerFull){
           allPresentUsers.get(userList[i]).state = b.type;
           b.isHandOver = false;
           b.timer = 0;
           }
         } 
         /*else{
             b.isHandOver = false;
             b.timer = 0;
             b.timerFull = false;
         }*/
      }
      if (!brushHasHand){ // this means there is no hand over that brush. 
             b.isHandOver = false;
             b.timer = 0;
             b.timerFull = false;
      }
   }

  
  // draw depthImageMap
  //image(context.depthImage(),0,0);
  //image(context.userImage(),0,0);
  
  // draw the skeleton if it's available
  
  boolean handOverPrint = false;
  boolean handOverClear = false;
  boolean handOverNew = false;
  
  boolean handOverColor1 = false;
  boolean handOverColor2 = false;
  boolean handOverScene1 = false;
  boolean handOverScene2 = false;
  
  
  for(int i=0;i<userList.length;i++)
  {
    if(context.isTrackingSkeleton(userList[i]))
    //if(true)
    {
      
      //stroke(userClr[ (userList[i] - 1) % userClr.length ] );
      stroke(255,0,0);
      //drawSkeleton(userList[i]);  
      
      
      
      if(brushOnly){
        drawBrushesNoAngle(userList[i]);
      }else{
        drawPointCloud(userList[i]);
      }
      
      
      User user = allPresentUsers.get(userList[i]);
      
       
      // update art layer based on hand position
      PVector rightHand = new PVector();
      context.getJointPositionSkeleton(userList[i],SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);
      PVector convertedRightHand = new PVector();
      context.convertRealWorldToProjective(rightHand,convertedRightHand);
      float rightHandMappedX = map(convertedRightHand.x, 0, 640, 0, width);
      float rightHandMappedY = map(convertedRightHand.y, 0, 480, 0, height);
      float rightHandZ = convertedRightHand.z;

      
      PVector leftHand = new PVector();
      context.getJointPositionSkeleton(userList[i],SimpleOpenNI.SKEL_LEFT_HAND,leftHand);
      PVector convertedLeftHand = new PVector();
      context.convertRealWorldToProjective(leftHand,convertedLeftHand);
      float leftHandMappedX = map(convertedLeftHand.x, 0, 640, 0, width);
      float leftHandMappedY = map(convertedLeftHand.y, 0, 480, 0, height);
      float leftHandZ = convertedLeftHand.z;
      
      PVector torso = new PVector();
      context.getJointPositionSkeleton(userList[i],SimpleOpenNI.SKEL_TORSO,torso);
      PVector convertedTorso = new PVector();
      context.convertRealWorldToProjective(torso,convertedTorso);
      float torsoMappedX = map(convertedTorso.x, 0, 640, 0, width);
      float torsoMappedY = map(convertedTorso.y, 0, 480, 0, height);
      float torsoZ = convertedTorso.z;
      
      // calculate the depth of each hand relative to the torso and decide whether to make the dot transparent or not. 
      float depthLeftHand = torsoZ - leftHandZ;
      float depthRightHand = torsoZ - rightHandZ;
      int leftTransparent = 0;
      int rightTransparent = 0;
      if (depthLeftHand <= 70){
        // transparent 
         user.leftActive = false;
      }
      else{
         user.leftActive = true;
      }
      
      if (depthRightHand <= 70){
        // transparent 
         user.rightActive = false;
       }
      else{
         user.rightActive = true;
      }
      
      // check if left hand and right hand is over one of the paint buckets
      for (int j=0; j<paintBuckets.size(); j++){
        PaintBucket p = paintBuckets.get(j);
        if(abs(rightHandMappedX - p.xPos) <= p.w*.40 && abs(rightHandMappedY - p.yPos) <= p.w*.40){
          allPresentUsers.get(userList[i]).rightHandColor = p.c;
          p.isSelected=true;
        }
        else if(abs(leftHandMappedX - p.xPos) <= p.w*.40 && abs(leftHandMappedY - p.yPos) <= p.w*.40){
          allPresentUsers.get(userList[i]).leftHandColor = p.c;
          p.isSelected=true;
        }
        else{
          p.isSelected=false;
        }
      }
      
      
      
      // check if left and right hand are over one of the paint brush menu icons
      /*for (int j=0; j<brushMenuIcons.size(); j++){
       BrushMenuIcon b = brushMenuIcons.get(j);
        if(abs(rightHandMappedX - b.xPos) <= b.w*.75 && abs(rightHandMappedY - b.yPos) <= b.w*.75){
          
          //println("TYPE: " + b.type);
          b.isHandOver = true;
          b.timer = b.timer+1;
          if(b.timerFull){
             allPresentUsers.get(userList[i]).state = b.type;
             b.isHandOver = false;
             b.timer = 0;
           }
        }
        else if(abs(leftHandMappedX - b.xPos) <= b.w*.75 && abs(leftHandMappedY - b.yPos) <= b.w*.75){
          
         // println("TYPE: " + b.type);
         b.isHandOver = true;
         b.timer= b.timer+1;
         if(b.timerFull){
           allPresentUsers.get(userList[i]).state = b.type;
           b.isHandOver = false;
           b.timer = 0;
           }
         } 
         else{
             b.isHandOver = false;
             b.timer = 0;
             b.timerFull = false;
         }
      }*/
      
      /*
      // check if left and right hands are over the print icon
      if ((abs(leftHandMappedX - printIcon.xPos) <=printIcon.w && abs(leftHandMappedY-printIcon.yPos) <=printIcon.h) || 
        (abs(rightHandMappedX - printIcon.xPos) <=printIcon.w && abs(rightHandMappedY-printIcon.yPos) <=printIcon.h)) {
          handOverPrint=true;
          printIcon.isHandOver = true;
          printIcon.timer = printIcon.timer+1;
          if(printIcon.timerFull){
              artLayer.save("Images/image-" + saveCount + ".png");
              saveCount = saveCount +1;
              printIcon.timer = 0;
              printIcon.timerFull = false;
              printIcon.isHandOver = false;
              printIcon.printConfirmation = true;
            }
            
            if(printIcon.printConfirmation){
              printIcon.printConfCount = printIcon.printConfCount + 1;
              if (printIcon.printConfCount >= 5){
                printIcon.printConfCount = 0;
                printIcon.printConfirmation = false;
              }
            }
      }*/
      /*else{
        printIcon.isHandOver = false;
        printIcon.timer = 0;
        printIcon.timerFull = false;
        printIcon.printConfirmation = false;
      }*/
      
      artLayer.beginDraw();
      artLayer.colorMode(RGB);
      
      /// TO DO: this code needs to go in the previous section- there is a bug when two people are using the system! 
      
      //Check if either hand is hovering on "clear"
      if ((abs(leftHandMappedX - clearIcon.xPos) <= clearIcon.w && abs(leftHandMappedY-clearIcon.yPos) <= clearIcon.h) ||
        (abs(rightHandMappedX - clearIcon.xPos) <= clearIcon.w && abs(rightHandMappedY-clearIcon.yPos) <=clearIcon.h)) {
          handOverClear = true;
          clearIcon.isHandOver = true;
          clearIcon.timer = clearIcon.timer+1;
          if(clearIcon.timerFull){
            artLayer.clear();
            }
          }
          
          // check if hand is hovering on coloring item 1
          if ((abs(leftHandMappedX - color1Icon.xPos) <= color1Icon.w && abs(leftHandMappedY-color1Icon.yPos) <= color1Icon.h) ||
        (abs(rightHandMappedX - color1Icon.xPos) <= color1Icon.w && abs(rightHandMappedY-color1Icon.yPos) <=color1Icon.h)) {
          handOverColor1 = true;
          color1Icon.isHandOver = true;
          color1Icon.timer = clearIcon.timer+1;
          if(color1Icon.timerFull){
            //artLayer.clear();
            // TO DO: Change the background, however that needs to happen. 
            }
          }
          
          // TO DO: Check if hand is over the other coloring items etc. 

          
          //Check if either hand is hovering on "new"
      /*if ((abs(leftHandMappedX - newIcon.xPos) <= newIcon.w && abs(leftHandMappedY-newIcon.yPos) <= newIcon.h) ||
        (abs(rightHandMappedX - newIcon.xPos) <= newIcon.w && abs(rightHandMappedY-newIcon.yPos) <=newIcon.h)) {
          handOverNew = true;
          newIcon.isHandOver = true;
          newIcon.timer = newIcon.timer+1;
          if(newIcon.timerFull){
            // artLayer.clear();
            coloringPage = loadImage("turtle5.png");
            artLayer.clear();
            pageLayer.clear();
            }
          }*/
          
       /*else{
        clearIcon.isHandOver = false;
        clearIcon.timer = 0;
        clearIcon.timerFull = false;
      }   */  
      
      if (coloringBook){ // if the application is in coloring book mode, place coloring book image on top of the lines. 
        //artLayer.beginDraw();
        artLayer.image(coloringPage, width*.05,height*.05, width*.8, height*.8);
        //artLayer.endDraw();
        //image(artLayer,0,0);
      }
      
      
      // check if left and right hands are near butterfly
      /*for (int j=0; j<butterflies.size(); j++){
        Butterfly b = butterflies.get(j);
        
        float old_b_x = b.x;
        float old_b_y = b.y; 
        
        // check if both left and right hands are near the butterfly (i.e. its caught)
        if ((abs(rightHandMappedX - b.x) <= b.w*2 && abs(rightHandMappedY - b.y) <= b.w*2) && 
            (abs(leftHandMappedX - b.y) <= b.w*2 && abs(leftHandMappedY - b.y) <= b.w*2)){
              //println("CAUGHT");
               capturedButterflyTrail(artLayer, old_b_x, old_b_y, b.x, b.y, b.c);
               // set thecaptu butterfly to be in the middle of the two hands
               b.x = (rightHandMappedX + leftHandMappedX)/2;
               b.y = (rightHandMappedY + leftHandMappedY)/2;
             }
            
            
        else{ // else check if only one hand is over the butterfly
        
        // check if right hand is over the butterfly
        if(abs(rightHandMappedX - b.x) <= b.w*.75 && abs(rightHandMappedY - b.y) <= b.w*.75){
          if ((rightHandMappedX - user.pRightHandX) > 0){
          b.x += random(0,20);
          b.xDir = -1;
          //bf1.t1 = bf1.x;
          } else{
            b.x += random(-20,0);
            b.xDir = 1;
            //bf1.t1 = bf1.x;
          }
          if ((rightHandMappedY - user.pRightHandY) > 0){
            b.y += random(0,20);
            b.yDir = 1;
            //bf1.t2 = bf1.y;
          } else {
            b.y += random(-20,0);
            b.yDir = -1;
            //bf1.t2 = bf1.y;
          }
          butterflyTrail(artLayer, old_b_x, old_b_y, b.x, b.y, b.c);
          b.flyingAway = true;
          }
          
        // check if left hand is over the butterfly 
        if(abs(leftHandMappedX - b.x) <= b.w*.75 && abs(leftHandMappedY - b.y) <= b.w*.75){
          if ((leftHandMappedX - user.pLeftHandX) > 0){
          b.x += random(0,20);
          b.xDir = 1;
          //bf1.t1 = bf1.x;
          } else{
            b.x += random(-20,0);
            b.xDir = -1;
            //bf1.t1 = bf1.x;
          }
          if ((leftHandMappedY - user.pLeftHandY) > 0){
            b.y += random(0,20);
            b.yDir = 1;
            //bf1.t2 = bf1.y;
          } else {
            b.y += random(-20,0);
            b.yDir = -1;
            //bf1.t2 = bf1.y;
          }
          butterflyTrail(artLayer, old_b_x, old_b_y, b.x, b.y, b.c);
          b.flyingAway = true;
          }
        }
      }
     */
      
      
      if(!coloringFill){
      
      // draw dot wherever hand is. 
      
      if(user.state == "traditional"){
        if (user.rightActive){
          artLayer.fill(allPresentUsers.get(userList[i]).getRightHandColor());
          float bubbleSize = sqrt(sq(rightHandMappedX - user.pRightHandX) + sq(rightHandMappedY - user.pRightHandY));
          if(bubbleSize<100){
            artLayer.noStroke();
          artLayer.ellipse(rightHandMappedX, rightHandMappedY, bubbleSize,bubbleSize);
          }
        }
        // check if distance from torso is great enough. if close to torso, don't draw a dot. 
        if (user.leftActive){
          artLayer.fill(allPresentUsers.get(userList[i]).getLeftHandColor());
          float bubbleSize = sqrt(sq(leftHandMappedX - user.pLeftHandX) + sq(leftHandMappedY - user.pLeftHandY));
          if(bubbleSize<100){
            artLayer.noStroke();
          artLayer.ellipse(leftHandMappedX, leftHandMappedY, bubbleSize,bubbleSize);
          }
        }
      } 
      if(user.state == "thin"){ // TO DO: use the same logic as the previous case to check if the user's hand is near their torso 
        
        //artLayer.ellipse(rightHandMappedX, rightHandMappedY, 20,20);
        artLayer.fill(allPresentUsers.get(userList[i]).getLeftHandColor());
        
        //artLayer.ellipse(leftHandMappedX, leftHandMappedY, 20,20);
        if (user.rightActive){
          color userRightColor = user.getRightHandColor();
          artLayer.stroke(color(hue(userRightColor), saturation(userRightColor), brightness(userRightColor),200));
          //artLayer.stroke(color(allPresentUsers.get(userList[i]).getRightHandColor().hue(),allPresentUsers.get(userList[i]).getRightHandColor().saturation(),allPresentUsers.get(userList[i]).getRightHandColor().brightness(), 200));
          artLayer.strokeWeight(8);
          artLayer.line(rightHandMappedX, rightHandMappedY, allPresentUsers.get(userList[i]).pRightHandX, allPresentUsers.get(userList[i]).pRightHandY);
        }
        
        if(user.leftActive){
          color userLeftColor = user.getLeftHandColor();
          artLayer.stroke(color(hue(userLeftColor), saturation(userLeftColor), brightness(userLeftColor),200));
          //artLayer.stroke(allPresentUsers.get(userList[i]).getLeftHandColor());
          artLayer.strokeWeight(8);
          artLayer.line(leftHandMappedX, leftHandMappedY, allPresentUsers.get(userList[i]).pLeftHandX, allPresentUsers.get(userList[i]).pLeftHandY);
        }
      }
      if(user.state == "spike"){
        // draw right hand art
        color userRightColor = user.getRightHandColor();
        artLayer.stroke(color(hue(userRightColor), saturation(userRightColor), brightness(userRightColor),200));
        //artLayer.stroke(allPresentUsers.get(userList[i]).getRightHandColor());
        //artLayer.fill(allPresentUsers.get(userList[i]).getRightHandColor(), 255,255, 150);
        artLayer.noFill();
        float rightBubbleSize = sqrt(sq(rightHandMappedX - user.pRightHandX) + sq(rightHandMappedY - user.pRightHandY));
        artLayer.pushMatrix();
        artLayer.translate(rightHandMappedX, rightHandMappedY);
        for (int j=0; j<10; j++){
          artLayer.rotate(random(0,2*PI));
          float lineLen = random(0, rightBubbleSize*1.2);
          //println("SPIKE");
          artLayer.strokeWeight(2);
          artLayer.line(0,0,lineLen,lineLen);
          //artLayer.noStroke();
          artLayer.ellipse(lineLen,lineLen, 10,10);
          //artLayer.ellipse(rightHandMappedX, rightHandMappedY, 10,10);
        }
        artLayer.popMatrix();


         // draw left hand art
         color userLeftColor = user.getLeftHandColor();
        artLayer.stroke(color(hue(userLeftColor), saturation(userLeftColor), brightness(userLeftColor),200));
        //artLayer.stroke(allPresentUsers.get(userList[i]).getLeftHandColor());
        //artLayer.fill(allPresentUsers.get(userList[i]).getRightHandColor(), 255,255, 150);
        artLayer.noFill();
        float leftBubbleSize = sqrt(sq(leftHandMappedX - user.pLeftHandX) + sq(leftHandMappedY - user.pLeftHandY));
        artLayer.pushMatrix();
        artLayer.translate(leftHandMappedX, leftHandMappedY);
        for (int j=0; j<10; j++){
          artLayer.rotate(random(0,2*PI));
          float lineLen = random(0, leftBubbleSize*1.2);
          //println("SPIKE");
          artLayer.strokeWeight(2);
          artLayer.line(0,0,lineLen,lineLen);
          //artLayer.noStroke();
          artLayer.ellipse(lineLen,lineLen, 10,10);
          //artLayer.ellipse(rightHandMappedX, rightHandMappedY, 10,10);
        }
        artLayer.popMatrix();
      }
      
      
      if (user.state == "connect"){
        color userRightColor = user.getRightHandColor();
        artLayer.stroke(color(hue(userRightColor), saturation(userRightColor), brightness(userRightColor),200));
        //artLayer.stroke(allPresentUsers.get(userList[i]).getRightHandColor());
        artLayer.strokeWeight(5);
        artLayer.line(rightHandMappedX, rightHandMappedY, leftHandMappedX, leftHandMappedY);
        artLayer.noStroke();
      }
      
      
      
      
      artLayer.endDraw();
      image(artLayer,0,0);
      
      }
      
      if (coloringFill){ // don't draw line where hand is. instead fill the part of the image. 
          if (user.rightActive){
          color cRight = allPresentUsers.get(userList[i]).getRightHandColor();
          //float bubbleSize = sqrt(sq(rightHandMappedX - user.pRightHandX) + sq(rightHandMappedY - user.pRightHandY));
          float rightHandPosInImageX = rightHandMappedX - .2*width; // TO DO: make a variable for how far the image is from the edge. 
          float rightHandPosInImageY = rightHandMappedY - .05*height;
          //print("RIGHT HAND MAPPED: " + rightHandMappedX + " " + rightHandMappedY + "\n");
          //print("IN IMAGE: " + rightHandPosInImageX + " " + rightHandPosInImageY + "\n");
          //colorArea(rightHandPosInImageX, rightHandPosInImageY, cRight);
          if(!isCurrentlyFilling){
            isCurrentlyFilling=true;
            fillImage(rightHandPosInImageX, rightHandPosInImageY, cRight);
            isCurrentlyFilling = false;
          }
          //fillImage(100,100,cRight);
          //testChangeImage();
        }
        // check if distance from torso is great enough. if close to torso, don't draw a dot. 
        if (user.leftActive){
          artLayer.fill(allPresentUsers.get(userList[i]).getLeftHandColor());
          float bubbleSize = sqrt(sq(leftHandMappedX - user.pLeftHandX) + sq(leftHandMappedY - user.pLeftHandY));
          if(bubbleSize<100){
            artLayer.noStroke();
          artLayer.ellipse(leftHandMappedX, leftHandMappedY, bubbleSize,bubbleSize);
          }
        }
        
        artLayer.image(seurat, width*.2,height*.05, seurat.width, seurat.height);
      
      artLayer.endDraw();
      image(artLayer,0,0);
     
        
      }
     
     
      // set the variables for the user to keep track of the previous hand positions. 
      user.pRightHandX = rightHandMappedX;
      user.pRightHandY = rightHandMappedY;
      user.pLeftHandX = leftHandMappedX;
      user.pLeftHandY = leftHandMappedY;
      
    }      
    else{
        /*skeletonLayer.beginDraw();
        //skeletonLayer.fill(255,0,0);
        skeletonLayer.background(255,255,255);
        skeletonLayer.endDraw();
        image(skeletonLayer,0,0);
        image(artLayer,0,0);*/
    }
  }   
  
  

 
 if(!handOverClear){
      clearIcon.isHandOver = false;
      clearIcon.timer = 0;
      clearIcon.timerFull = false;
 } 
 
 if(!handOverColor1){
   color1Icon.isHandOver = false;
   color1Icon.timer = 0;
   color1Icon.timerFull = false;
 } 
 
 /*if(!handOverNew){
      newIcon.isHandOver = false;
      newIcon.timer = 0;
      newIcon.timerFull = false;
 } */
 
 /*
 if(!handOverPrint){
   printIcon.isHandOver = false;
        printIcon.timer = 0;
        printIcon.timerFull = false;
        printIcon.printConfirmation = false;
        printIcon.printConfCount = 0;
   
 }*/
  
 
     // draw the object layer on top  
     objectLayer.beginDraw();
     objectLayer.clear();
     //objectLayer.background(0,0,255,0);
     
     // draw print icon
     //printIcon.display(objectLayer);
     
     //draw clear icon
     clearIcon.display(objectLayer);
     
     //draw mode menu icons
     color1Icon.display(objectLayer);
     color2Icon.display(objectLayer);
     scene1Icon.display(objectLayer);
     scene2Icon.display(objectLayer);
     
     //draw new icon
     //newIcon.display(objectLayer);
     
     
     
     // draw paint buckets by iterating through the paintbuckets list
     for (int i =0; i<paintBuckets.size(); i++){
       PaintBucket p = paintBuckets.get(i);
      
       //objectLayer.fill(p.c,255,255);
       //objectLayer.ellipse(p.xPos, p.yPos, p.w, p.h); 
       p.display(objectLayer);
     }
     // end draw pots
     
     
     // draw brushMenuIcons 
     for (int i=0; i<brushMenuIcons.size(); i++){
       BrushMenuIcon b = brushMenuIcons.get(i);
       b.display(objectLayer);
     }
     
     // draw butterflies 
     /*for (int i=0; i<butterflies.size(); i++){
       Butterfly b = butterflies.get(i);
       b.move();
       b.display(objectLayer);
     }     */
     
     objectLayer.endDraw();
     image(objectLayer,0,0); 
     
     
     
 
 
}


//test for drawing point cloud-- just draws a dot in the center of the torso. 
void drawPointCloudTest(int userId){
 
 /*
  PVector torso = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_TORSO,torso);
  PVector convertedTorso = new PVector();
  context.convertRealWorldToProjective(torso,convertedTorso);
  */
 
  skeletonLayer.beginDraw();
  skeletonLayer.fill(255,0,0);
  skeletonLayer.background(255,255,255,0);
  //skeletonLayer.ellipse(convertedTorso.x, convertedTorso.y, 20,20);
  skeletonLayer.endDraw();
  image(skeletonLayer,0,0);
 
 
}


void drawBrushes(int userId){
  skeletonLayer.beginDraw();
  skeletonLayer.background(0,0,255);
  
  //int[] userList = context.getUsers();
  
  User u = allPresentUsers.get(userId);
  
  
   // update art layer based on hand position
    PVector torso = new PVector();
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_TORSO,torso);
    PVector convertedTorso = new PVector();
    context.convertRealWorldToProjective(torso,convertedTorso);
    float torsoMappedX = map(convertedTorso.x, 0, 640, 0, width);
    float torsoMappedY = map(convertedTorso.y, 0, 480, 0, height);
    float torsoZ = convertedTorso.z;
    
    PVector rightHand = new PVector();
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);
    PVector convertedRightHand = new PVector();
    context.convertRealWorldToProjective(rightHand,convertedRightHand);
    float rightHandMappedX = map(convertedRightHand.x, 0, 640, 0, width);
    float rightHandMappedY = map(convertedRightHand.y, 0, 480, 0, height);
    float rightHandZ = convertedRightHand.z;

    
    PVector leftHand = new PVector();
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,leftHand);
    PVector convertedLeftHand = new PVector();
    context.convertRealWorldToProjective(leftHand,convertedLeftHand);
    float leftHandMappedX = map(convertedLeftHand.x, 0, 640, 0, width);
    float leftHandMappedY = map(convertedLeftHand.y, 0, 480, 0, height);
    float leftHandZ = convertedLeftHand.z;
    
    float rightArmAngle = getLimbAngle(convertedTorso.x, convertedTorso.y, convertedRightHand.x, convertedRightHand.y);
    float leftArmAngle = getLimbAngle(convertedTorso.x, convertedTorso.y, convertedLeftHand.x, convertedLeftHand.y);
  
  
      // right arm
    skeletonLayer.pushMatrix();
    skeletonLayer.translate(convertedTorso.x, convertedTorso.y);
    skeletonLayer.rotate(rightArmAngle);
    //len = pythag(convertedTorso.x, convertedTorso.y, convertedRightHand.x, convertedRightHand.y);
    //skeletonLayer.scale(.0025*len,.0025*len);
    skeletonLayer.image(brushUp,-brushUp.width/2, -brushUp.height*2, brushUp.width, brushUp.height);
    skeletonLayer.popMatrix();
    
    // left arm 
    skeletonLayer.pushMatrix();
    skeletonLayer.translate(leftHandMappedX, leftHandMappedY);
    skeletonLayer.rotate(leftArmAngle);
    //len = pythag(convertedTorso.x, convertedTorso.y, convertedLeftHand.x, convertedLeftHand.y);
    //skeletonLayer.scale(.0025*len,.0025*len);
    skeletonLayer.image(brushUp,-brushUp.width/2, 0, brushUp.width, brushUp.height);
    skeletonLayer.popMatrix();

    skeletonLayer.endDraw();
  //image(skeletonLayer,0,0);
  image(skeletonLayer,0,0);

  
}

void drawBrushesNoAngle(int userId){
  skeletonLayer.beginDraw();
  skeletonLayer.background(0,0,255);
  
  if(scene1On){
    skeletonLayer.image(scene1, 0,0, width, height);
  }
  if(scene2On){
    skeletonLayer.image(scene2,0,0,width,height);
  }
  
  //int[] userList = context.getUsers();
  
  User u = allPresentUsers.get(userId);
  
  
   // update art layer based on hand position
    PVector torso = new PVector();
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_TORSO,torso);
    PVector convertedTorso = new PVector();
    context.convertRealWorldToProjective(torso,convertedTorso);
    float torsoMappedX = map(convertedTorso.x, 0, 640, 0, width);
    float torsoMappedY = map(convertedTorso.y, 0, 480, 0, height);
    float torsoZ = convertedTorso.z;
    
    PVector rightHand = new PVector();
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);
    PVector convertedRightHand = new PVector();
    context.convertRealWorldToProjective(rightHand,convertedRightHand);
    float rightHandMappedX = map(convertedRightHand.x, 0, 640, 0, width);
    float rightHandMappedY = map(convertedRightHand.y, 0, 480, 0, height);
    float rightHandZ = convertedRightHand.z;

    
    PVector leftHand = new PVector();
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,leftHand);
    PVector convertedLeftHand = new PVector();
    context.convertRealWorldToProjective(leftHand,convertedLeftHand);
    float leftHandMappedX = map(convertedLeftHand.x, 0, 640, 0, width);
    float leftHandMappedY = map(convertedLeftHand.y, 0, 480, 0, height);
    float leftHandZ = convertedLeftHand.z;
    
    float rightArmAngle = getLimbAngle(convertedTorso.x, convertedTorso.y, convertedRightHand.x, convertedRightHand.y);
    float leftArmAngle = getLimbAngle(convertedTorso.x, convertedTorso.y, convertedLeftHand.x, convertedLeftHand.y);
  
  
      // right arm
    skeletonLayer.pushMatrix();
    skeletonLayer.translate(rightHandMappedX, rightHandMappedY);
    //skeletonLayer.rotate(rightArmAngle);
    //len = pythag(convertedTorso.x, convertedTorso.y, convertedRightHand.x, convertedRightHand.y);
    //skeletonLayer.scale(.0025*len,.0025*len);
    if(u.rightActive){
    skeletonLayer.image(brushUp,-brushUp.width/2, 0, brushUp.width, brushUp.height);
    }
    else{
          skeletonLayer.image(brushTransp,-brushTransp.width/2, 0, brushTransp.width, brushTransp.height);
    }
    skeletonLayer.popMatrix();
    
    // left arm 
    skeletonLayer.pushMatrix();
    skeletonLayer.translate(leftHandMappedX, leftHandMappedY);
    //skeletonLayer.rotate(leftArmAngle);
    //len = pythag(convertedTorso.x, convertedTorso.y, convertedLeftHand.x, convertedLeftHand.y);
    //skeletonLayer.scale(.0025*len,.0025*len);
    if(u.leftActive){

    skeletonLayer.image(brushUp,-brushUp.width/2, 0, brushUp.width, brushUp.height);
    }
    else{
      skeletonLayer.image(brushTransp,-brushTransp.width/2, 0, brushTransp.width, brushTransp.height);
    }
    skeletonLayer.popMatrix();

    skeletonLayer.endDraw();
  //image(skeletonLayer,0,0);
  image(skeletonLayer,0,0);

  
}

float getLimbAngle(float x1, float y1, float x2, float y2){
  
  float headAngle = atan((y2 - y1) / (x2 - x1));
  
  if (x2 < x1){
    if(y2 < y1) { 
      // bottom left
      headAngle = headAngle - PI/2;
    }
    if (y2 > y1){
      // top left
      headAngle = headAngle - PI/2;
    }
  }
  if (x2 > x1){
    //headAngle = -1 * (PI/2 - headAngle) ;
    if (y2 > y1){
     // top right
    headAngle = headAngle + PI/2;
    } 
    if (y2 < y1){
      // bottom right
      headAngle = PI/2 + headAngle;
    }
  }
  
  return headAngle;
  
}


// draws the point cloud in the skeleton layer. 
void drawPointCloud(int userId){
  
  skeletonLayer.beginDraw();
  //skeletonLayer.fill(255,0,0);
  skeletonLayer.background(0,0,255);
  //skeletonLayer.clear();
  //PImage rgbImage = context.rgbImage(); 
  int[]   depthMap = context.depthMap();
  int[]   userMap = context.userMap();
  int     steps = 4;  // to speed up the drawing, draw every fourth point
  int     index;
  PVector realWorldPoint;
  
  if(scene1On){
    skeletonLayer.image(scene1, 0,0, width, height);
  }
  if(scene2On){
    skeletonLayer.image(scene2,0,0,width,height);
  }
  
  //int[] userList = context.getUsers();
  //User user = allPresentUsers.get(userList[userId]);
  
  
  // draw the dough boy. because for whatever reason it is just easier to put it on the same layer as the skeleton. 
  if (doughboy){
           doughy.mode = "closer";
           //skeletonLayer.beginDraw();
           //skeletonLayer.clear();
           //skeletonLayer.background(0,0,255);
           doughy.display(skeletonLayer);
           //skeletonLayer.endDraw();
          //mage(skeletonLayer,0,0);
         }
   
  // draw the pointcloud
  skeletonLayer.beginShape(POINTS);
  for(int y=0;y < context.depthHeight();y+=steps)
  {
    for(int x=0;x < context.depthWidth();x+=steps)
    {
      index = x + y * context.depthWidth();
      if(depthMap[index] > 0)
      {
        // draw the projected point
        realWorldPoint = context.depthMapRealWorld()[index];
        PVector convertedPoint = new PVector();
        context.convertRealWorldToProjective(realWorldPoint, convertedPoint);
        float mappedX = map(convertedPoint.x, 0, 640, 0, width);
        float mappedY = map(convertedPoint.y, 0, 480, 0, height);
        // don't draw anything if the pixel is part of the background
        if(userMap[index] == 0)
          skeletonLayer.noStroke();
        else
        {
          // else draw a color based on which user is at that pixel. Change the color every 100 frames.
          //skeletonLayer.stroke(userClr[ (userMap[index] - 1 + (frameCount / 100)) % userClr.length ]);       
          //stroke(rgbImage.pixels[index]);
          skeletonLayer.stroke(0, 150);
          skeletonLayer.strokeWeight(4);
          skeletonLayer.point(mappedX,mappedY);
          //skeletonLayer.ellipse(25,25,25,25);
      }
    }
  }
 }
 
 
  // display points on hands to indicate the current state of the brush.  
  PVector leftHand = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,leftHand);
  PVector convertedLeftHand = new PVector();
  context.convertRealWorldToProjective(leftHand,convertedLeftHand);
  float leftHandMappedX = map(convertedLeftHand.x, 0, 640, 0, width);
  float leftHandMappedY = map(convertedLeftHand.y, 0, 480, 0, height);
  float leftHandZ = convertedLeftHand.z;
  
  
  skeletonLayer.noStroke();
  //skeletonLayer.fill(100,255,255);
  //skeletonLayer.ellipse(leftHandMappedX, leftHandMappedY, 30,30);
  
  PVector rightHand = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);
  PVector convertedRightHand = new PVector();
  context.convertRealWorldToProjective(rightHand,convertedRightHand);
  float rightHandMappedX = map(convertedRightHand.x, 0, 640, 0, width);
  float rightHandMappedY = map(convertedRightHand.y, 0, 480, 0, height);
  float rightHandZ = convertedRightHand.z;
  
  PVector torso = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_TORSO,torso);
  PVector convertedTorso = new PVector();
  context.convertRealWorldToProjective(torso,convertedTorso);
  float torsoMappedX = map(convertedTorso.x, 0, 640, 0, width);
  float torsoMappedY = map(convertedTorso.y, 0, 480, 0, height);
  float torsoZ = convertedTorso.z;
  
  User u = allPresentUsers.get(userId);
  color u_right = u.getRightHandColor();
  color u_left = u.getLeftHandColor();
  String u_state = u.getState();
  
  skeletonLayer.noStroke();
  
  float rightTransparent = 0;
  float leftTransparent = 0;
  
  if(u.rightActive){
    rightTransparent = 255;
  }
  else{
    rightTransparent = 40;
  }
  if(u.leftActive){
    leftTransparent = 255;
  }
  else{
    leftTransparent = 40;
  }
  
  
  // depending on the state of the user, draw different icons at their hands. 
  if (u_state=="traditional" || u_state=="connect"){
    skeletonLayer.fill(hue(u_right), saturation(u_right), brightness(u_right), rightTransparent);
    skeletonLayer.ellipse(rightHandMappedX, rightHandMappedY, 35,35);
    skeletonLayer.fill(hue(u_left), saturation(u_left), brightness(u_left), leftTransparent);
    skeletonLayer.ellipse(leftHandMappedX, leftHandMappedY, 35,35);
  } else if (u_state=="thin" || u_state=="spike"){
    skeletonLayer.fill(hue(u_right), saturation(u_right), brightness(u_right), rightTransparent);
    skeletonLayer.ellipse(rightHandMappedX, rightHandMappedY, 15,15);
    skeletonLayer.fill(hue(u_left), saturation(u_left), brightness(u_left), leftTransparent);
    skeletonLayer.ellipse(leftHandMappedX, leftHandMappedY, 15,15);
  } 
  
   
 
  skeletonLayer.endShape();
  skeletonLayer.endDraw();
  //image(skeletonLayer,0,0);
  image(skeletonLayer,0,0);
}


// draw the skeleton with the selected joints 
void drawSkeleton(int userId)
{
  // to get the 3d joint data
  /*
  PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
  println(jointPos);
  */

   // context.beginDraw();
  //skeletonLayer.fill(255,0,0);
  background(0,0,255);
  
 


  PVector torso = new PVector(); 
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_TORSO,torso);
  PVector convertedTorso = new PVector();
  context.convertRealWorldToProjective(torso, convertedTorso);


  PVector rightHand = new PVector(); 
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,rightHand);
  PVector convertedRightHand = new PVector();
  context.convertRealWorldToProjective(rightHand, convertedRightHand);
  //float rightEllipseSize = map(convertedRightHand.z, 700, 2500,  50, 1);
  ellipse(convertedRightHand.x, convertedRightHand.y, 10, 10);
  //text("hand: " + convertedRightHand.x + " " + convertedRightHand.y, 10, 50);
//  yval = -(convertedRightHand.y-height/2);
    xval = (convertedRightHand.x-convertedTorso.x);
  //yval = map(convertedRightHand.y,0,height,1,-1);
  //xval = map(convertedRightHand.x,0,width,1,-1);
//  if (xval>=0){
//  theta1 = acos(yval/sqrt(sq(xval)+sq(yval)));
//  }
//  else{
//  theta1 = -acos(yval/sqrt(sq(xval)+sq(yval)));
//  }
  theta1 = PVector.angleBetween(new PVector(convertedRightHand.x-convertedTorso.x,convertedRightHand.y-convertedTorso.y,0.0),new PVector(0,convertedTorso.y-height,0.0));
  if (xval<0){
    theta1*= -1;
  }
  
  PVector leftHand = new PVector(); 
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,leftHand);
  PVector convertedLeftHand = new PVector();
  context.convertRealWorldToProjective(leftHand, convertedLeftHand);
  //float leftEllipseSize = map(convertedLeftHand.z, 700, 2500,  50, 1);
  ellipse(convertedLeftHand.x, convertedLeftHand.y, 10, 10);
  //yval = -(convertedLeftHand.y-height/2);
    xval = (convertedLeftHand.x-convertedTorso.x);
  //yval = map(convertedLeftHand.y,0,height,1,-1);
  //xval = map(convertedLeftHand.x,0,width,1,-1);
  theta2 = PVector.angleBetween(new PVector(convertedLeftHand.x-convertedTorso.x,convertedLeftHand.y-convertedTorso.y,0.0),new PVector(0,convertedTorso.y-height,0.0));
  if (xval<0){
    theta2*= -1;
  }

  
  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  




}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  curContext.startTrackingSkeleton(userId);
  User newUser = new User(userId);
  allPresentUsers.put(userId, newUser);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
  allPresentUsers.remove(userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}


// draw trail when butterfly draws. 
void butterflyTrail(PGraphics layer, float b_x_old, float b_y_old, float b_x, float b_y, float b_col){
  //fill(c);
  //print("TRAIL");
  layer.noStroke();
  layer.fill(b_col,255,255,100);
  //line(b_x_old, b_y_old, b_x, b_y);  
  //float bubbleSize = (b_x - b_x_old) * 5;
  float bubbleSize = 100;
  layer.ellipse(b_x, b_y, bubbleSize, bubbleSize);
  //layer.stroke(255,255,255);
  //layer.ellipse(0,0,100,100);
  for (int i=0; i<8; i++){
      layer.ellipse(b_x+random(0,40), b_y+ random(0,40), 10,10);
  }
}

// draw trail when butterfly draws. 
void capturedButterflyTrail(PGraphics layer, float b_x_old, float b_y_old, float b_x, float b_y, float b_col){
  layer.noStroke();
  //fill(c);
  //print("TRAIL");
  //layer.noStroke();
  //layer.stroke(random(0,255), 255,255,200);
  layer.fill(random(0,255),255,255,200);
  //line(b_x_old, b_y_old, b_x, b_y);  
  //float bubbleSize = (b_x - b_x_old) * 5;
  float bubbleSize = 100;
  //layer.ellipse(b_x, b_y, bubbleSize, bubbleSize);
  //layer.stroke(255,255,255);
  //layer.ellipse(0,0,100,100);
  for (int i=0; i<15; i++){
      layer.fill(random(0,255),255,255,200);
      layer.ellipse(b_x+random(0,40), b_y+ random(0,40), 10,10);
  }
}

void drawLeaf(){ // draw a leaf as follows

  float pointShift = random(-20,20); // here is a variable between -20 and 20 
  beginShape(); // start to draw a shape
  vertex(20, 45); // begin at this point x, y
  // bezierVertex(30,30,60,40,70 + random(-20,20),50); // moving only the pointy point meant that sometimes the leaf shape would turn into a heart shape, because the control points were not also moving. So I created a variable called pointShift
    bezierVertex(30,30, 60 + pointShift,40 + pointShift/2, 70 + pointShift,50); // make the pointy end of the leaf vary on the x axis (so the leaf gets longer or shorter) AND vary the y axis of the control points by the same amount. It should be possible to have 'normal' leaves, very short fat ones and very long thin ones.
    bezierVertex(60 + pointShift,55, 30,65, 20,45); // draw the other half of the shape
  endShape();

}

// for fill coloring. takes the x and y of the hand and makes the image piece that color. 
// this is the version that is recursive. 
void fillImage(float x, float y, color c){
    
    //print("LOG");    
    //print (x + " " + y + "\n");
    seurat.loadPixels();// TO DO: take the image as a parameter
    int loc = int(x) + int(y)*seurat.width;
    
    if((x>seurat.width) || (y>seurat.height) || (y<0) || (x<0)){
      return;
    }
      
  
    //if surface[x][y] != oldColor: # the base case
    //return
    float r = red(seurat.pixels[loc]);
    float g = green(seurat.pixels[loc]);
    float b = blue(seurat.pixels[loc]);
    
    //print(r + " " + g + " " + b + "\n");
    //img.pixels[loc] = c;
    if(!((r==0) && (g==0) && (b==0))){
      return;
    }
    seurat.pixels[loc] = c;
    seurat.updatePixels();
    fillImage(x + 1, y,  c); // right
    fillImage(x - 1, y,  c); // left
    fillImage(x, y + 1,  c); // down
    fillImage(x, y - 1,  c); // up
    
    seurat.updatePixels();
    
}





// this also colors the area within an image. is not recursive and doesn't fill the whole shape, but it does run faster. 
void colorArea(float xPos, float yPos, color c){
    
    print("Color area");  
    print(xPos + " " + yPos + "\n");
    seurat.loadPixels(); 
    
    int mouseLoc = int(xPos) + int(yPos)*seurat.width;
    seurat.pixels[mouseLoc] = color(255,0,0);
    
    
    
    boolean hasNextRight = true;
    int nextRight = mouseLoc;
    while(hasNextRight){
      print("while");
      
      
      
      // look up
      boolean hasNextUp = true;
      int nextUp = nextRight;
      while(hasNextUp){
        seurat.pixels[nextUp] = color(255,0,0);
        float r = red(seurat.pixels[nextUp-seurat.width]);
        float g = green(seurat.pixels[nextUp-seurat.width]);
        float b = blue(seurat.pixels[nextUp-seurat.width]);
        if(!((r==0) && (g==0) && (b==0))){
          nextUp = nextUp -seurat.width;  
        }
        else{
          hasNextUp=false;
        }
      }
      
      
      
      // look down
      boolean hasNextDown = true;
      int nextDown = nextRight;
      while(hasNextDown){
        
        float r = red(seurat.pixels[nextDown+seurat.width]);
        float g = green(seurat.pixels[nextDown+seurat.width]);
        float b = blue(seurat.pixels[nextDown+seurat.width]);
        if(((r==0) && (g==0) && (b==0))){
          seurat.pixels[nextDown+1] = color(255,0,0);
          nextDown = nextDown+seurat.width;
        }
        else{
          hasNextDown=false;
        }
      }
      
      // right
      float r = red(seurat.pixels[nextRight+1]);
      float g = green(seurat.pixels[nextRight+1]);
      float b = blue(seurat.pixels[nextRight+1]);
      //float t = opacity(seurat.pixels[nextRight+1]);
      print ("RGB: " + r + " " + g + " " + b + "\n");
      if(((r==0) && (g==0) && (b==0))){
        seurat.pixels[nextRight+1] = color(255,0,0);
        nextRight = nextRight + 1;
      }
      else{
        hasNextRight=false;
      }
    }
    
    /*
    // left
    boolean hasNextLeft = true;
    int nextLeft = mouseLoc;
    while(hasNextLeft){
      seurat.pixels[nextLeft] = color(255,0,0);
      
      // look up
      boolean hasNextUp = true;
      int nextUp = nextLeft;
      while(hasNextUp){
        seurat.pixels[nextUp] = color(255,0,0);
        float r = red(seurat.pixels[nextUp-width]);
        float g = green(seurat.pixels[nextUp-width]);
        float b = blue(seurat.pixels[nextUp-width]);
        if(!((r==0) && (g==0) && (b==0))){
          nextUp = nextUp -width;
        }
        else{
          hasNextUp=false;
        }
      }
      
      // look down
      boolean hasNextDown = true;
      int nextDown = nextLeft;
      while(hasNextDown){
        seurat.pixels[nextDown] = color(255,0,0);
        float r = red(seurat.pixels[nextDown+width]);
        float g = green(seurat.pixels[nextDown+width]);
        float b = blue(seurat.pixels[nextDown+width]);
        if(!((r==0) && (g==0) && (b==0))){
          nextDown = nextDown+width;
        }
        else{
          hasNextDown=false;
        }
      }
      
      
      float r = red(seurat.pixels[nextLeft-1]);
      float g = green(seurat.pixels[nextLeft-1]);
      float b = blue(seurat.pixels[nextLeft-1]);
      if(!((r==0) && (g==0) && (b==0))){
        nextLeft = nextLeft -1;
      }
      else{
        hasNextLeft=false;
      }
    }
    */
    seurat.updatePixels();
}

void testChangeImage(){
  seurat.loadPixels();
  for (int y = 0; y < seurat.height; y++) {
    for (int x = 0; x < seurat.width; x++) {
      int loc = x + y*seurat.width;
      
      // The functions red(), green(), and blue() pull out the 3 color components from a pixel.
      float r = red(seurat.pixels[loc]);
      float g = green(seurat.pixels[loc]);
      float b = blue(seurat.pixels[loc]);
      
      // take everything that is not completely white and make it black. ie flatten the greyscale 
      if (!((r==255) && (g==255) && (b==255))){
        r = 0;
        g = 0;
        b = 0;
         seurat.pixels[loc] =  color(255,0,0);
      }
      else{
         seurat.pixels[loc] =  color(0,0,255);
        //img.pixels[loc] = 0x00FFFFFF;
      }
    }
  }
  seurat.updatePixels();
}




// this is from the old code. 
// Each branch now receives
// its length as an argument.
void branch(float len) {

  line(0, 0, 0, -len);
  translate(0, -len);

  // Each branch’s length
  // shrinks by two-thirds.
  len *= 0.66;

  if (len > 2) {
    pushMatrix();
    rotate(theta2);
    // Subsequent calls to branch()
    // include the length argument.
    branch(len);
    popMatrix();

    pushMatrix();
    rotate(theta1);
    branch(len);
    popMatrix();
  }
}

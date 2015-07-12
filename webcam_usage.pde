PImage img;
PImage imgEnhanced;
ParticleSystem ps; // partical system reference from: https://processing.org/examples/simpleparticlesystem.html

ParticleSystem[] pss = new ParticleSystem[4];

import processing.video.*; 
// code for capturing from webcam from: https://processing.org/reference/libraries/video/Capture.html
// using pimage with camera capture from: http://forum.processing.org/one/topic/manipulate-pixels-from-capture-image.html

Capture cam;
color trackColor;
color[] trackColors = new color[4];

int resX = 176;
int resY = 144;

boolean calabMode = true;
boolean presentMode = false;

float contrast = 1f;
float bright = 64f;

boolean scaleMode = false;
float scaleRate = 1f;


void setup() {
  size(1280, 960);
  
  trackColor = color(255,0,0);
  trackColors[0] = color(252,0,0);
  trackColors[1] = color(0,252,0);
  trackColors[2] = color(0,0,252);
  trackColors[3] = color(252,252,0);

  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println("camera[" + i + "]: " + cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[43]);
    cam.start();     
  }   
  img = createImage(resX, resY, RGB);  
  
  ps = new ParticleSystem(new PVector(width/2,50));
  pss[0] = new ParticleSystem(new PVector(width/2,50));
  pss[1] = new ParticleSystem(new PVector(width/2,50));
  pss[2] = new ParticleSystem(new PVector(width/2,50));
  pss[3] = new ParticleSystem(new PVector(width/2,50));
}

void draw() {
  background(255);
  
  pushMatrix();
  
    scale(scaleRate);
    
    float moveUp = 0;
    float moveLeft = 0;
    
    moveUp = ((scaleRate*height)-height)/2;
    moveLeft = ((scaleRate*width)-width)/2;
    
    translate(-moveLeft, -moveUp);
    
    if (scaleMode){
      scaleRate = map(mouseY, 0.0, height, 0.0, 3.0);
    }
    
    if (cam.available() == true) {
      cam.read();
    }
    
    //img = loadImage(cam);
    img.copy(cam, 0, 0, cam.width, cam.height, 0, 0, cam.width, cam.height);
    imgEnhanced = new PImage(img.width, img.height);  
    if (calabMode){
      contrast = 5f * ( mouseX / (float)width); //value should go from 0 to 5
      bright = 255 * ( mouseY / (float)width  - 0.5); //value should go from -128 to +128
    }
    //PVector crosshare = ContrastAndBrightness(img,imgEnhanced, contrast,bright, trackColor); 
    //PVector crosshare = track(imgEnhanced, trackColor);
    PVector[] crosshares = ContrastAndBrightness(img,imgEnhanced, contrast,bright, trackColors); 
    
    
    if (!presentMode){
      image(imgEnhanced, 0,0, width, height); 
    }
    
    for (int i = 0 ; i < crosshares.length; i++){
      crosshares[i].x = map (crosshares[i].x, 0, resX, 0, width);
      crosshares[i].y = map (crosshares[i].y, 0, resY, 0, height);
      
      noFill();
      stroke(255);
      if (!presentMode){
        int rectSize = 50;
        line(crosshares[i].x, crosshares[i].y-rectSize/2, crosshares[i].x, crosshares[i].y+rectSize/2);
        line(crosshares[i].x-rectSize/2, crosshares[i].y, crosshares[i].x+rectSize/2, crosshares[i].y);
      }
      pss[i].origin(crosshares[i]);
      
      pss[i].addParticle();
      pss[i].run();
    }
    
    /*
    noFill();
    stroke(255);
    if (!presentMode){
      int rectSize = 50;
      line(crosshare.x, crosshare.y-rectSize/2, crosshare.x, crosshare.y+rectSize/2);
      line(crosshare.x-rectSize/2, crosshare.y, crosshare.x+rectSize/2, crosshare.y);
    }
    ps.origin(crosshare);
    
    ps.addParticle();
    ps.run();
    */
  popMatrix();
  
  if (!presentMode){
    for (int i = 0; i < trackColors.length; i++){
      fill(trackColors[i]);
      stroke(trackColors[i]);
      rect(50*i,0,50,50);
    }
  }
}

//image processing function to enhance contrast
//this doesn't make sense without also adjusting the brightness at the same time
PVector ContrastAndBrightness(PImage input, PImage output,float cont,float bright, color target)
{ // function from: http://forum.processing.org/one/topic/increase-contrast-of-an-image.html 
  // added all the other crazy functions into this one as well. 
   int w = input.width;
   int h = input.height;
   
   //our assumption is the image sizes are the same
   //so test this here and if it's not true just return with a warning
   if(w != output.width || h != output.height)
   {
     println("error: image dimensions must agree");
     return new PVector(0,0);
   }
   
   //this is required before manipulating the image pixels directly
   input.loadPixels();
   output.loadPixels();
   
   ArrayList<PVector> pxLocation = new ArrayList<PVector>();
      
   //loop through all pixels in the image
   for(int i = 0; i < w*h; i++)
   {  
       //get color values from the current pixel (which are stored as a list of type 'color')
       color inColor = input.pixels[i];
       
       //slow version for illustration purposes - calling a function inside this loop
       //is a big no no, it will be very slow, plust we need an extra cast
       //as this loop is being called w * h times, that can be a million times or more!
       //so comment this version and use the one below
       //int r = (int) red(input.pixels[i]);
       //int g = (int) green(input.pixels[i]);
       //int b = (int) blue(input.pixels[i]);
       
       //here the much faster version (uses bit-shifting) - uncomment to try
       int r = (inColor >> 16) & 0xFF; //like calling the function red(), but faster
       int g = (inColor >> 8) & 0xFF;
       int b = inColor & 0xFF;      
       
       //apply contrast (multiplcation) and brightness (addition)
       r = (int)(r * cont + bright); //floating point aritmetic so convert back to int with a cast (i.e. '(int)');
       g = (int)(g * cont + bright);
       b = (int)(b * cont + bright);
       
       //slow but absolutely essential - check that we don't overflow (i.e. r,g and b must be in the range of 0 to 255)
       //to explain: this nest two statements, sperately it would be r = r < 0 ? 0 : r; and r = r > 255 ? 255 : 0;
       //you can also do this with if statements and it would do the same just take up more space
       r = r < 0 ? 0 : r > 255 ? 255 : r;
       g = g < 0 ? 0 : g > 255 ? 255 : g;
       b = b < 0 ? 0 : b > 255 ? 255 : b;
       
       //and again in reverse for illustration - calling the color function is slow so use the bit-shifting version below
       //output.pixels[i] = color(r ,g,b);
       color outputPx = 0xff000000 | (r << 16) | (g << 8) | b; //this does the same but faster
       output.pixels[i]= outputPx; 
       
       int currR2 = (target >> 16) & 0xFF; 
       int currG2 = (target >> 8) & 0xFF;
       int currB2 = target & 0xFF;
       
       int distance  = 0;
       distance += Math.pow(r - currR2, 2);
       distance += Math.pow(g - currG2, 2);
       distance += Math.pow(b - currB2, 2);
       
       if (distance < 200){
         int x = i%img.width;
         int y = i/img.width;
         //println(distance, x, y);
         pxLocation.add(new PVector(x,y));
       }
   }
   
   //so that we can display the new image we must call this for each image
   input.updatePixels();
   output.updatePixels();
   
   if (pxLocation.size() >= 2){
     return avarageVectors(pxLocation);
   }
   return new PVector(0,0);
}

PVector[] ContrastAndBrightness(PImage input, PImage output,float cont,float bright, color[] target)
{ // function from: http://forum.processing.org/one/topic/increase-contrast-of-an-image.html 
  // added all the other crazy functions into this one as well. 
   int w = input.width;
   int h = input.height;
   
   PVector[] returnVectors = new PVector[4];
   for (int i = 0; i < returnVectors.length; i++){
     returnVectors[i] = new PVector(0,0);
   }
   
   //our assumption is the image sizes are the same
   //so test this here and if it's not true just return with a warning
   if(w != output.width || h != output.height)
   {
     println("error: image dimensions must agree");
     return returnVectors;
   }
   
   //this is required before manipulating the image pixels directly
   input.loadPixels();
   output.loadPixels();
   
   ArrayList<PVector> pxLocation0 = new ArrayList<PVector>();
   ArrayList<PVector> pxLocation1 = new ArrayList<PVector>();
   ArrayList<PVector> pxLocation2 = new ArrayList<PVector>();
   ArrayList<PVector> pxLocation3 = new ArrayList<PVector>();
      
   //loop through all pixels in the image
   for(int i = 0; i < w*h; i++)
   {  
       //get color values from the current pixel (which are stored as a list of type 'color')
       color inColor = input.pixels[i];
       
       //here the much faster version (uses bit-shifting)
       int r = (inColor >> 16) & 0xFF; 
       int g = (inColor >> 8) & 0xFF;
       int b = inColor & 0xFF;      
       
       //apply contrast (multiplcation) and brightness (addition)
       r = (int)(r * cont + bright); //floating point aritmetic so convert back to int with a cast (i.e. '(int)');
       g = (int)(g * cont + bright);
       b = (int)(b * cont + bright);
       
       //slow but absolutely essential - check that we don't overflow (i.e. r,g and b must be in the range of 0 to 255)
       //to explain: this nest two statements, sperately it would be r = r < 0 ? 0 : r; and r = r > 255 ? 255 : 0;
       //you can also do this with if statements and it would do the same just take up more space
       r = r < 0 ? 0 : r > 255 ? 255 : r;
       g = g < 0 ? 0 : g > 255 ? 255 : g;
       b = b < 0 ? 0 : b > 255 ? 255 : b;
       
       //and again in reverse for illustration - calling the color function is slow so use the bit-shifting version below
       color outputPx = 0xff000000 | (r << 16) | (g << 8) | b; 
       output.pixels[i]= outputPx; 
       
       for (int j = 0; j < target.length; j++){
         int currR2 = (target[j] >> 16) & 0xFF; 
         int currG2 = (target[j] >> 8) & 0xFF;
         int currB2 = target[j] & 0xFF;
         
         int distance  = 0;
         distance += Math.pow(r - currR2, 2);
         distance += Math.pow(g - currG2, 2);
         distance += Math.pow(b - currB2, 2);
         
         // why does Java not have JSON -.-
         if (distance < 200 && j == 0){
           int x = i%img.width;
           int y = i/img.width;
           //println(distance, x, y);
           pxLocation0.add(new PVector(x,y));
         }
         if (distance < 200 && j == 1){
           int x = i%img.width;
           int y = i/img.width;
           //println(distance, x, y);
           pxLocation1.add(new PVector(x,y));
         }
         if (distance < 200 && j == 2){
           int x = i%img.width;
           int y = i/img.width;
           //println(distance, x, y);
           pxLocation2.add(new PVector(x,y));
         }
         if (distance < 200 && j == 3){
           int x = i%img.width;
           int y = i/img.width;
           //println(distance, x, y);
           pxLocation3.add(new PVector(x,y));
         }
       }
   }
   
   //so that we can display the new image we must call this for each image
   input.updatePixels();
   output.updatePixels();
   
   //Java seriousely need to consider implementing JSON as a possiable data type.
   if (pxLocation0.size() >= 2){
     returnVectors[0] = avarageVectors(pxLocation0);
   }
   
   if (pxLocation1.size() >= 2){
     returnVectors[1] = avarageVectors(pxLocation1);
   }
   
   if (pxLocation2.size() >= 2){
     returnVectors[2] = avarageVectors(pxLocation2);
   }
   
   if (pxLocation3.size() >= 2){
     returnVectors[3] = avarageVectors(pxLocation3);
   }
   
   return returnVectors;
}

PVector track(PImage img, color trackColor){
  PVector returnVector = new PVector(0,0);
  ArrayList<PVector> pxLocation = new ArrayList<PVector>();
  
  for (int i = 0; i < img.pixels.length; i++){
    color inColor = img.pixels[i];
    int distance = colorCompare(inColor, trackColor);
    if (distance < 200){
      int x = i%img.width;
      int y = i/img.width;
      println(distance, x, y);
      pxLocation.add(new PVector(x,y));
    }
  }
  if (pxLocation.size() >= 2){
    return avarageVectors(pxLocation);
  }
  return returnVector;
}

PVector avarageVectors(ArrayList<PVector> vectors){
  PVector avarage = vectors.get(0);
  //println("Avarage:" + avarage);
  for (int i = 1; i < vectors.size(); i++){
    PVector next = vectors.get(i);
    
    avarage = new PVector ((avarage.x + next.x)/2, (avarage.y + next.y)/2);
  }
  //println("Avarage:" + avarage);
  return avarage;
}

// compare function from https://processing.org/discourse/beta/num_1239013312.html
int colorCompare( int colour1, int colour2 ) 
{

  int currR = (colour1 >> 16) & 0xFF; 
  int currG = (colour1 >> 8) & 0xFF;
  int currB = colour1 & 0xFF;

  int currR2 = (colour2 >> 16) & 0xFF; 
  int currG2 = (colour2 >> 8) & 0xFF;
  int currB2 = colour2 & 0xFF;

  int distance  = 0;
  distance += Math.pow(currR - currR2, 2);
  distance += Math.pow(currG - currG2, 2);
  distance += Math.pow(currB - currB2, 2);
  return distance ;
} 

void keyPressed() {
  if (key == ' ') {
    presentMode = !presentMode;
  } else if (key == '9') {
    calabMode = !calabMode;
  } else if (key == '8'){
    scaleMode = !scaleMode;
  }
}

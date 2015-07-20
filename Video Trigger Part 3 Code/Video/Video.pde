import processing.video.*;

Movie theMov;
Movie theMov2;
Movie theMov3;
Movie theMov4;
int movieType = 0;

void setup() { 
  size(1024, 768);

  theMov = new Movie(this, "All In One_REMADE.mp4");
  theMov.loop();
  theMov2 = new Movie(this, "First 2 Minutes White.mp4");
  theMov2.loop();
  theMov3 = new Movie(this, "Grows and Wind Comes in.mp4");
  theMov3.loop();
  theMov4 = new Movie(this, "Buildings.mp4");
  theMov4.loop();
}

void draw() { 
  background(0);

  switch(movieType) {
  case 0:
    background(200.200,200); 
    break; 
  case 1:
//    background(255, 0, 0);
    theMov.read();
    theMov.play();
    theMov2.stop();
    theMov3.stop();
    theMov4.stop();
    image(theMov, 0, 0, width, height);
    break;
  case 2:
//    background(0, 255, 0); 
    theMov2.read();
    theMov2.play();
    theMov.stop();
    theMov3.stop();
    theMov4.stop();
    image(theMov2, 0, 0, width, height);
    break;
  case 3:
//    background(0, 255, 0); 
    theMov3.read();
    theMov3.play();
    theMov.stop();
    theMov2.stop();
    theMov4.stop();
    image(theMov3, 0, 0, width, height);
    break;
  case 4:
//    background(0, 255, 0); 
    theMov4.read();
    theMov4.play();
    theMov.stop();
    theMov2.stop();
    theMov3.stop();
    image(theMov4, 0, 0, width, height);
    break;
  }
}

void keyPressed() {
  println(key);

  if (key == 'a') {
    movieType = 0;
  } else if (key == 's') {
    movieType = 1;
  } else if (key == '1') {
    movieType = 2;
  } else if (key == '2') {
    movieType = 3;
  } else if (key == '3') {
    movieType = 4;
  }
}

//void movieEvent(Movie m) { 
//    m.read();
//}


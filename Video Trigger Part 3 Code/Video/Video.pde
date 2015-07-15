import processing.video.*;

Movie theMov;
Movie theMov2;
int movieType = 0;

void setup() { 
  size(1024, 768);

  theMov = new Movie(this, "Try.mp4");
  theMov.loop();
  theMov2 = new Movie(this, "Wind.mp4");
  theMov2.loop();
}

void draw() { 
  background(0);

  switch(movieType) {
  case 0:
    background(0); 
    break; 
  case 1:
//    background(255, 0, 0);
    theMov.read();
    theMov.play();
    theMov2.pause();
    image(theMov, 0, 0, width, height);
    break;
  case 2:
//    background(0, 255, 0); 
    theMov2.read();
    theMov2.play();
    theMov.pause();
    image(theMov2, 0, 0, width, height);
    break;
  }
}

void keyPressed() {
  println(key);

  if (key == 'a') {
    movieType = 0;
  } else if (key == 's') {
    movieType = 1;
  } else if (key == 'd') {
    movieType = 2;
  }
}

//void movieEvent(Movie m) { 
//    m.read();
//}


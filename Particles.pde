class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  PImage display;
  float rotation; 
  //  float alphaVal = 255;

  Particle(PVector l) {
    //acceleration = new PVector(0.05,0);
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-1, 1), random(-2, 0));
    location = l.get();
    lifespan = 0.0;

    display = loadImage("Vine75px/Vine75px" + round(random(1, 3)) + ".png");
    rotation = 0;
  }

  Particle(PVector l, float angle) {
    //acceleration = new PVector(0.05,0);
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-1, 1), random(-2, 0));
    location = l.get();
    lifespan = 0.0;

    display = loadImage("Vine75px/Vine75px" + round(random(1, 3)) + ".png");
    rotation = angle;
  }

  void setLifespan( float life) {
    lifespan = life;
  }

  void setWind(boolean tog) {
    if (tog) {
      acceleration = new PVector(0.05, 0);
    } else {
      acceleration = new PVector(0, 0);
    }
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
  }

  // Method to display
  void display() {
    //stroke(0, lifespan);

    //ellipse(location.x,location.y,8,8);
    pushMatrix();
    translate(location.x-display.width/2, location.y-display.height/2);
    rotate(rotation);
    image(display, -75/2, -75/2);
    popMatrix();

    //    if (lifespan <= 0) {
    //    } else { 
    lifespan += 4.25;
    // alphaVal= alphaVal-8.5;
    // }
    noStroke(); 
    fill(170, 170, 170, lifespan);
    rectMode(CENTER);
    ellipse(location.x-30, location.y-30, 100, 100);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan > 255.0) {
      lifespan = 0; 
      return true;
    } else {
      return false;
    }
  }
}


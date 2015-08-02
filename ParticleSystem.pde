
class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  PVector previousO;
  PVector lastSpawn;
  boolean windMode = false;
  boolean overgrowMode = false;
  boolean make = true;
  
  ParticleSystem(PVector location) {
    origin = location.get();
    previousO = location.get();
    lastSpawn = location.get();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    if (make){
      PVector avarage;
      avarage = new PVector((origin.x+previousO.x)/2, (origin.y+previousO.y)/2);
      if (origin.dist(lastSpawn) > 35){
        float deltaX = lastSpawn.x - origin.x;
        float deltaY = lastSpawn.y - origin.y;
        float ang = atan(deltaY/deltaX);
        particles.add(new Particle(avarage,ang /*PVector.angleBetween( lastSpawn,origin)*/));
        lastSpawn = origin.get();
        
        if (overgrowMode){
          overgrow();
        }
        
        if (windMode){
          wind();
        }
      }
    }
  }
  
  void unmake(){
    make = false;
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
  
  void origin(PVector coord){
    if (coord.x != 0 && coord.y != 0){
      previousO = origin.get();
      origin = coord.get();
    }
  }
  
  void wind(){
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.setWind(true);
    }
    windMode = true;
  }
  
  void overgrow(){
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.freez();
    }
    overgrowMode = true;
  }
}

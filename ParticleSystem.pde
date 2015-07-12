
class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  PVector previousO;
  PVector lastSpawn;
  
  ParticleSystem(PVector location) {
    origin = location.get();
    previousO = location.get();
    lastSpawn = location.get();
    particles = new ArrayList<Particle>();
  }

  void addParticle() {
    PVector avarage;
    avarage = new PVector((origin.x+previousO.x)/2, (origin.y+previousO.y)/2);
    if (origin.dist(lastSpawn) > 55){
      float deltaX = lastSpawn.x - origin.x;
      float deltaY = lastSpawn.y - origin.y;
      float ang = atan(deltaY/deltaX);
      particles.add(new Particle(avarage,ang /*PVector.angleBetween( lastSpawn,origin)*/));
      lastSpawn = origin.get();
    }
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
}
